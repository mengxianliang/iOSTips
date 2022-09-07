//
//  Question2.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "Question2.h"
#import "NSObject+Block.h"

typedef void(^TestBlock)(int a, int b, int c);

@implementation Question2

+ (void)answer {
    // 定义一个block
    TestBlock block = ^(int a, int b, int c){
        NSLog(@"block执行");
    };
    // hook这个block
    HookBlockToPrintArguments(block);
    // 执行这个block
    block(1, 2, 3);
}

@end
