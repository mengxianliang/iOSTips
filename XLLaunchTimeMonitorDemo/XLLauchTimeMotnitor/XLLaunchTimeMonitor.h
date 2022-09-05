//
//  XLLaunchTimeMonitor.h
//  XLLaunchTimeMonitorDemo
//
//  Created by mxl on 2022/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLLaunchTimeMonitor : NSObject

+ (instancetype)shareInstance;

- (void)start;

- (void)stop;

- (NSString *)info;

@end

NS_ASSUME_NONNULL_END
