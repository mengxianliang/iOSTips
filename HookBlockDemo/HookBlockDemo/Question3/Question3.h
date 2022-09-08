//
//  Question3.h
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TestBlock)(int a, int b, int c);

@interface Question3 : NSObject

+ (void)answer;

@end

NS_ASSUME_NONNULL_END
