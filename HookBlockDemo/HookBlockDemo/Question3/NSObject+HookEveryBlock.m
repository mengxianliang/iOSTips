//
//  NSObject+HookEveryBlock.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "NSObject+HookEveryBlock.h"
#import "NSObject+HookBlock.h"
#import "fishhook.h"
#import "BlockHeader.h"
#import "objc/message.h"

@implementation NSObject (HookEveryBlock)

// 替换block实现
void replaceBlockInvokeFunction(const void *blockObj) {
    struct Block_layout *layout = (struct Block_layout*)blockObj;
    if (layout != NULL && layout->descriptor != NULL) {
        if (layout->invoke != _objc_msgForward) {
            layout->descriptor->reserved = layout->invoke;
            layout->invoke = _objc_msgForward;
        }
    }
}

// 替换系统retainBlock方法
void* (*objc_retainBlock_old)(const void *block);
void *objc_retainBlock_new(const void *block) {
    // hook这个block
    replaceBlockInvokeFunction(block);
    // 实现原方法
    return objc_retainBlock_old(block);
}

// hook所有block
void HookEveryBlockToPrintArguments(void) {
    
    // 替换NSBlock的消息转发方法
    exchangeNSBlockForwardMethod();
    
    // hook系统的objc_retainBlock方法
    struct rebinding rebns[1] = {"objc_retainBlock",objc_retainBlock_new,(void **)&objc_retainBlock_old};
    rebind_symbols(rebns, 1);
}

@end
