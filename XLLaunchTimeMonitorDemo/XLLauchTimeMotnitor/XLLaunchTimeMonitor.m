//
//  XLLaunchTimeMonitor.m
//  XLLaunchTimeMonitorDemo
//
//  Created by mxl on 2022/9/5.
//

#import "XLLaunchTimeMonitor.h"
#import "BSBacktraceLogger.h"

static double TimerInterval = 0.01;

@interface XLLaunchTimeMonitor ()

@property (nonatomic, strong) NSMutableDictionary *timeInfo;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, assign) double launchTime;

@end

@implementation XLLaunchTimeMonitor

+ (instancetype)shareInstance {
    static XLLaunchTimeMonitor *counter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        counter = [[XLLaunchTimeMonitor alloc] init];
    });
    return counter;
}

- (instancetype)init {
    if (self = [super init]) {
        self.timeInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)start {
    [self startTimer];
    self.startDate = [NSDate date];
}

- (void)stop {
    [self stopTimer];
    self.launchTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
}

// 添加定时器
- (void)startTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    dispatch_source_set_timer(timer, start, TimerInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self updateTimerInfo];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)stopTimer {
    dispatch_source_cancel(self.timer);
}

- (void)updateTimerInfo {
    // 获取主线程方法堆栈中的方法名称集合
    NSArray *methodNames = [BSBacktraceLogger xl_backtraceOfMainThread];
    for (NSString *name in methodNames) {
        if ([self.timeInfo objectForKey:name] == nil) {
            [self.timeInfo setObject:@(TimerInterval) forKey:name];
        }else {
            double time = [[self.timeInfo objectForKey:name] doubleValue];
            time += TimerInterval;
            [self.timeInfo setObject:@(time) forKey:name];
        }
    }
}

- (NSString *)info {
    NSMutableString *allInfo = [[NSMutableString alloc] init];
    [allInfo appendString:[NSString stringWithFormat:@"启动耗时：%.3f秒,其中：",self.launchTime]];
    for (NSString *key in self.timeInfo.allKeys) {
        double time = [[self.timeInfo objectForKey:key] doubleValue];
//        NSLog(@" key = %@,value = %f", key, time);
        NSString *oneInfo = [NSString stringWithFormat:@"\n %@ 耗时 %.3f秒", key, time];
        [allInfo appendString:oneInfo];
    }
    return allInfo;
}

@end
