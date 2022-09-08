//
//  Question1.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "Question1.h"
#import "Block.h"

typedef void(^TestBlock)(void);

@implementation Question1

+ (void)answer {
    // 定义一个block
    TestBlock block = ^{
        NSLog(@"block执行");
    };
    // hook这个block
    HookBlockToPrintHelloWorld(block);
    // 执行这个block
    block();
}

void HookBlockToPrintHelloWorld(id block) {
    // 将block对象转换为结构体
    struct Block_layout *layout = (__bridge struct Block_layout *)block;
    // 替换invoke函数
    layout->invoke = printHelloWorld;
}

void printHelloWorld(void) {
    printf("Hello World");
}

@end
