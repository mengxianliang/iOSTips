//
//  XLRunLoopMonitor.m
//  RunLoopMonitorDemo
//
//  Created by mxl on 2022/10/8.
//

#import "XLRunLoopMonitor.h"

@interface XLRunLoopMonitor(){
    CFRunLoopObserverRef runLoopObserver;
    @public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}

@end

@implementation XLRunLoopMonitor

+ (instancetype)shareInstance {
    static XLRunLoopMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[XLRunLoopMonitor alloc] init];
    });
    return monitor;
}

- (void)startMonitor {
    
    if (runLoopObserver) { return; }
    
    // 保证线程同步，设定超时时间
    dispatchSemaphore = dispatch_semaphore_create(0);
    
    // 创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    // 将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    // 创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程开启一个持续的循环用来进行监控
        while (YES) {
            // 通过信号量设定超时时间，如果超时，代表信号量仍然为0，即代表RunLoop没有更新状态
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 200*NSEC_PER_MSEC));
            if (semaphoreWait != 0) { // semaphoreWait 不为0，代表超时
                if (!self->runLoopObserver) {
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                // 判断上一次保留的状态，如果是kCFRunLoopBeforeSources或者kCFRunLoopAfterWaiting，代表正在卡顿，记录对战信息
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        NSLog(@"正在卡顿.....");
                        // 保存卡顿的堆栈信息
                    });
                }
            }
        }
    });
}

// 运行时状态回调方法
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    // 保存RunLoop状态
    XLRunLoopMonitor *monitor = (__bridge XLRunLoopMonitor*)info;
    monitor->runLoopActivity = activity;

    // 信号量+1
    dispatch_semaphore_t semaphore = monitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}


- (void)endMonitor {
    if (!runLoopObserver) { return; }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}


@end
