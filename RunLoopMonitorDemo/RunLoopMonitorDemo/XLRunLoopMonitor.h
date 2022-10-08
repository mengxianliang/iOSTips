//
//  XLRunLoopMonitor.h
//  RunLoopMonitorDemo
//
//  Created by mxl on 2022/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLRunLoopMonitor : NSObject

+ (instancetype)shareInstance;

- (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
