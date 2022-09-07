//
//  Question2.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "Question2.h"
#import <objc/message.h>

/* ------------------------------- 来自于libclosure源码 ↓↓↓↓↓ -------------------------------*/
typedef void(*BlockCopyFunction)(void *, const void *);
typedef void(*BlockDisposeFunction)(const void *);
typedef void(*BlockInvokeFunction)(void *, ...);

// Values for Block_layout->flags to describe block objects
enum {
    BLOCK_DEALLOCATING =      (0x0001),  // runtime
    BLOCK_REFCOUNT_MASK =     (0xfffe),  // runtime
    BLOCK_INLINE_LAYOUT_STRING = (1 << 21), // compiler

#if BLOCK_SMALL_DESCRIPTOR_SUPPORTED
    BLOCK_SMALL_DESCRIPTOR =  (1 << 22), // compiler
#endif

    BLOCK_IS_NOESCAPE =       (1 << 23), // compiler
    BLOCK_NEEDS_FREE =        (1 << 24), // runtime
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25), // compiler
    BLOCK_HAS_CTOR =          (1 << 26), // compiler: helpers have C++ code
    BLOCK_IS_GC =             (1 << 27), // runtime
    BLOCK_IS_GLOBAL =         (1 << 28), // compiler
    BLOCK_USE_STRET =         (1 << 29), // compiler: undefined if !BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE  =    (1 << 30), // compiler
    BLOCK_HAS_EXTENDED_LAYOUT=(1 << 31)  // compiler
};

#define BLOCK_DESCRIPTOR_1 1
struct Block_descriptor_1 {
    uintptr_t reserved;
    uintptr_t size;
};

#define BLOCK_DESCRIPTOR_2 1
struct Block_descriptor_2 {
    // requires BLOCK_HAS_COPY_DISPOSE
    BlockCopyFunction copy;
    BlockDisposeFunction dispose;
};


#define BLOCK_DESCRIPTOR_3 1
struct Block_descriptor_3 {
    // requires BLOCK_HAS_SIGNATURE
    const char *signature;
    const char *layout;     // contents depend on BLOCK_HAS_EXTENDED_LAYOUT
};

struct Block_layout {
    void * __ptrauth_objc_isa_pointer isa;
    volatile int32_t flags; // contains ref count
    int32_t reserved;
    BlockInvokeFunction invoke;
    struct Block_descriptor_1 *descriptor;
    // imported variables
};

/* ------------------------------- 来自于libclosure源码 ↑↑↑↑↑ -------------------------------*/

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

@implementation NSObject (XLBlock)

// hook block
void HookBlockToPrintArguments(id block) {
    
    // 将block对象转换为结构体
    struct Block_layout *layout = (__bridge struct Block_layout *)block;
    // 保存原invoke
    layout->descriptor->reserved = (uintptr_t)layout->invoke;
    // 替换invoke
    layout->invoke = (void *)_objc_msgForward;
    
    // 替换block消息转发方法
    exchangeSystemForwardMethod();
}

// 替换block方法
void exchangeSystemForwardMethod(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSBlock");
        
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

@end


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
