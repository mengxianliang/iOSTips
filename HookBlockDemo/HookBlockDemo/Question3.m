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
#import "NSObject+EveryBlock.h"

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

extern void blockhook(void);
extern void blockhook_stret(void);

void replaceBlockInvokeFunction(const void *blockObj)
{
    //任何一个block对象都可以转化为一个struct Block_layout结构体。
    struct Block_layout *layout = (struct Block_layout*)blockObj;
    if (layout != NULL && layout->descriptor != NULL)
    {
        //这里只hook一个可执行程序image范围内定义的block代码块。
        //因为imageTextStart和imageTextEnd表示可执行程序的代码范围，因此如果某个block是在可执行程序中被定义
        //那么其invoke函数地址就一定是在(imageTextStart,imageTextEnd)范围内。
        //如果将这个条件语句去除就会hook进程中所有的block对象！
        unsigned long invokePos = (unsigned long)layout->invoke;
        printf("invokePos - %lu, %lu, %lu \n", invokePos, imageTextStart, imageTextEnd);
        if (invokePos > 1000000000 && invokePos < 9000000000)
        {
            if (layout->descriptor->reserved == NULL) {
                HookBlockToPrintArguments((__bridge id _Nonnull)(blockObj));
            }
            
//            printf("block ======= %@ \n", layout);
////            HookBlockToPrintArguments((__bridge id _Nonnull)(blockObj));
//            //将默认的invoke实现保存到保留字段，将统一的hook函数赋值给invoke成员。
//            int32_t BLOCK_USE_STRET = (1 << 29);  //如果模拟器下返回的类型是一个大于16字节的结构体，那么block的第一个参数为返回的指针，而不是block对象。
//            void *hookfunc = ((layout->flags & BLOCK_USE_STRET) == BLOCK_USE_STRET) ? blockhook_stret : blockhook;
//            if (layout->invoke != hookfunc)
//            {
//                layout->descriptor->reserved = layout->invoke;
//                layout->invoke = hookfunc;
//            }
        }
    }
}


void *(*__NSStackBlock_retain_old)(void *obj, SEL cmd) = NULL;
void *__NSStackBlock_retain_new(void *obj, SEL cmd)
{
    replaceBlockInvokeFunction(obj);
    return __NSStackBlock_retain_old(obj, cmd);
}

void *(*__NSMallocBlock_retain_old)(void *obj, SEL cmd) = NULL;
void *__NSMallocBlock_retain_new(void *obj, SEL cmd)
{
    replaceBlockInvokeFunction(obj);
    return __NSMallocBlock_retain_old(obj, cmd);
}


void *(*__NSGlobalBlock_retain_old)(void *obj, SEL cmd) = NULL;
void *__NSGlobalBlock_retain_new(void *obj, SEL cmd)
{
    replaceBlockInvokeFunction(obj);
    return __NSGlobalBlock_retain_old(obj, cmd);
}



typedef void(^TestBlock)(int a, int b, int c);

@implementation Question3

- (void)start {
    TestBlock block1 = ^(int a, int b, int c){
        NSLog(@"block1执行");
    };
    block1(1, 2, 3);
    

    TestBlock block2 = ^(int a, int b, int c){
        NSLog(@"block2执行");
    };
    block2(4, 5, 6);

    TestBlock block3 = ^(int a, int b, int c){
        NSLog(@"block3执行");
    };
    block3(7, 8, 9);
    
    struct Block_layout *layout = (__bridge struct Block_layout*)block1;
    unsigned long invokePos = (unsigned long)layout->invoke;
    NSLog(@"block1 invokePos = %lu", invokePos);
}


- (void)answer {
//    initImageTextStartAndEndPos();
//    __NSStackBlock_retain_old =(void *(*)(void*,SEL))class_replaceMethod(NSClassFromString(@"__NSStackBlock__"), sel_registerName("retain"), (IMP)__NSStackBlock_retain_new, nil);
//    __NSMallocBlock_retain_old = (void *(*)(void*,SEL))class_replaceMethod(NSClassFromString(@"__NSMallocBlock__"), sel_registerName("retain"), (IMP)__NSMallocBlock_retain_new, nil);
//    __NSGlobalBlock_retain_old = (void *(*)(void*,SEL))class_replaceMethod(NSClassFromString(@"__NSGlobalBlock__"), sel_registerName("retain"), (IMP)__NSGlobalBlock_retain_new, nil);
////    // hook所有block
////    HookEveryBlockToPrintArguments();
//    [self start];
    
    HookEveryBlockToPrintArguments();
    [self start];
    
}




@end
