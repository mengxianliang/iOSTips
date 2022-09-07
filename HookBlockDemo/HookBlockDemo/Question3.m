//
//  Question3.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "Question3.h"
#import "objc/runtime.h"
#import "objc/message.h"
#import <mach-o/getsect.h>
#import "Block_Private.h"
#import "NSObject+Block.h"

extern const struct mach_header* _NSGetMachExecuteHeader(void);

//这两个全局变量保存可执行程序的代码段+数据段的开始和结束位置。
unsigned long imageTextStart = 0;
unsigned long imageTextEnd = 0;
void initImageTextStartAndEndPos(void)
{
    imageTextStart = (unsigned long)_NSGetMachExecuteHeader();
#ifdef __LP64__
    const struct segment_command_64 *psegment = getsegbyname("__TEXT");
#else
    const struct segment_command *psegment = getsegbyname("__TEXT");
#endif
    //imageTextEnd  等于代码段和数据段的结尾 + 对应的slide值。
    imageTextEnd = get_end() + imageTextStart - psegment->vmaddr;
}

@implementation NSObject (XLBlock)


void HookEveryBlockToPrintArguments(void) {
    exchangeSystemRetainMethodOf(NSClassFromString(@"__NSGlobalBlock__"));
    exchangeSystemRetainMethodOf(NSClassFromString(@"__NSStackBlock__"));
    exchangeSystemRetainMethodOf(NSClassFromString(@"__NSMallocBlock__"));
}

// 替换block的retain方法
void exchangeSystemRetainMethodOf(Class cls) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(cls, sel_registerName("retain"));
        Method method2 = class_getInstanceMethod(cls, sel_registerName("xl_retain"));
        method_exchangeImplementations(method1, method2);
    });
}

// 在被替换的方法中，替换消息转发方法
- (void)xl_retain {
    
//    NSLog(@"xl_retain = %@", self);
    struct Block_layout *layout = (__bridge struct Block_layout*)self;
    unsigned long invokePos = (unsigned long)layout->invoke;
    NSLog(@"invokePos = %lu, imageTextStart %lu, imageTextEnd = %lu",invokePos, imageTextStart, imageTextEnd);
    
    // 调用原始retain方法
    [self xl_retain];
}

@end

typedef void(^TestBlock)(int a, int b, int c);

@implementation Question3

- (void)start {
    // 定义一个block
    TestBlock block1 = ^(int a, int b, int c){
        NSLog(@"block1执行");
    };
    // 执行这个block
    block1(1, 2, 3);

//    // 定义另一个block
//    TestBlock block2 = ^(int a, int b, int c){
//        NSLog(@"block2执行");
//    };
//    // 执行这个block
//    block2(4, 5, 6);
//
//    // 定义另一个block
//    TestBlock block3 = ^(int a, int b, int c){
//        NSLog(@"block3执行");
//    };
//    // 执行这个block
//    block3(7, 8, 9);
    
    struct Block_layout *layout = (__bridge struct Block_layout*)self;
    unsigned long invokePos = (unsigned long)layout->invoke;

    NSLog(@"block1 invokePos = %lu", invokePos);
}

- (void)answer {
    initImageTextStartAndEndPos();
    // hook所有block
    HookEveryBlockToPrintArguments();
    [self start];
}

@end
