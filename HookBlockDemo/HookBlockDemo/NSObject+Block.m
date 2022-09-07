//
//  NSObject+Block.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "NSObject+Block.h"
#import "Block_Private.h"
#import <objc/message.h>

@implementation NSObject (Block)

// hook block
void HookBlockToPrintArguments(id block) {
    // 将block对象转换为结构体
    struct Block_layout *layout = (__bridge struct Block_layout *)block;
    // 保存原invoke
    layout->descriptor->reserved = (uintptr_t)layout->invoke;
    // 替换invoke
    layout->invoke = (void *)_objc_msgForward;
    
    // 替换block消息转发方法
    exchangeSystemForwardMethod(block);
}

// 替换block方法
void exchangeSystemForwardMethod(id block) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [block class];
        Method method1 = class_getInstanceMethod(cls, @selector(methodSignatureForSelector:));
        Method method2 = class_getInstanceMethod(cls, @selector(xl_methodSignatureForSelector:));
        method_exchangeImplementations(method1, method2);
        
        Method method3 = class_getInstanceMethod(cls, @selector(forwardInvocation:));
        Method method4 = class_getInstanceMethod(cls, @selector(xl_forwardInvocation:));
        method_exchangeImplementations(method3, method4);
    });
}

- (NSMethodSignature *)xl_methodSignatureForSelector:(SEL)aSelector {
    struct Block_descriptor_3 *desc3 = _Block_descriptor_3((__bridge void *)self);
    if ( desc3 == NULL ) { return nil; }
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:desc3->signature];
    return signature;
}

- (void)xl_forwardInvocation:(NSInvocation *)anInvocation {
    struct Block_layout *layout = (__bridge struct Block_layout *)anInvocation.target;
    
    // 打印参数
    NSMutableString *argumentString = [[NSMutableString alloc] init];
    for (int i = 1; i < anInvocation.methodSignature.numberOfArguments; i++) {
        int arg;
        [anInvocation getArgument:&arg atIndex:(NSInteger)i];
        [argumentString appendString:[NSString stringWithFormat:@"%d ",arg]];
    }
    NSLog(@"block参数: %@", argumentString);
    
    // 还原block的invoke
    layout->invoke = (BlockInvokeFunction)layout->descriptor->reserved;
    // 执行block
    [anInvocation invokeWithTarget:(__bridge id _Nonnull)layout];
}

/* ------------------------------- 来自于网络 ↓↓↓↓↓ -------------------------------*/
// 获取descriptor_3（主要是为了获取方法签名）
static struct Block_descriptor_3 * _Block_descriptor_3(struct Block_layout *aBlock) {
    if (!(aBlock->flags & BLOCK_HAS_SIGNATURE)) return NULL;
    uint8_t *desc = (uint8_t *)aBlock->descriptor;
    desc += sizeof(struct Block_descriptor_1);
    if (aBlock->flags & BLOCK_HAS_COPY_DISPOSE) {
        desc += sizeof(struct Block_descriptor_2);
    }
    return (struct Block_descriptor_3 *)desc;
}
/* ------------------------------- 来自于网络 ↑↑↑↑↑ -------------------------------*/

@end