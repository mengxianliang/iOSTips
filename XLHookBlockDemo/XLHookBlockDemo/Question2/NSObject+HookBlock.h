//
//  NSObject+HookBlock.h
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HookBlock)

// Hook一个block
void HookBlockToPrintArguments(id block);

// 替换NSBlock消息转发方法
void exchangeNSBlockForwardMethod(void);

@end

NS_ASSUME_NONNULL_END
