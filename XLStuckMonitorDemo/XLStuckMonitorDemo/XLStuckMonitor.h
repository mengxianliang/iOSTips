//
//  XLStuckMonitor.h
//  XLStuckMonitorDemo
//
//  Created by mxl on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLStuckMonitor : NSObject

+ (instancetype)shareInstance;

- (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
