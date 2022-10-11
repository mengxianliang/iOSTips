//
//  NSObject+HookEveryBlock.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "NSObject+HookEveryBlock.h"
#import "NSObject+HookBlock.h"
#import "fishhook.h"

@implementation NSObject (HookEveryBlock)

// 替换系统retainBlock方法
void* (*objc_retainBlock_old)(const void *block);
void *objc_retainBlock_new(const void *block) {
    // hook 这个 block
    HookBlockToPrintArguments((__bridge id _Nonnull)(block));
    // 实现原方法
    return objc_retainBlock_old(block);
}

// hook所有block
void HookEveryBlockToPrintArguments(void) {
    // hook系统的objc_retainBlock方法
    struct rebinding rebns[1] = {"objc_retainBlock",objc_retainBlock_new,(void **)&objc_retainBlock_old};
    rebind_symbols(rebns, 1);
}

@end
