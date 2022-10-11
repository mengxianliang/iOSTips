//
//  NSObject+HookEveryBlock.h
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HookEveryBlock)

void HookEveryBlockToPrintArguments(void);

@end

NS_ASSUME_NONNULL_END
