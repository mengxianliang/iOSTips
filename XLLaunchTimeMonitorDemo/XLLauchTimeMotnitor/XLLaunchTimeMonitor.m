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

- (void)startTimer {
    // 获取队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    // 设置定时器，参数：1、timer 2、开始时间 3、间隔（纳秒） 4、误差（纳秒）
    dispatch_source_set_timer(timer, start, TimerInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 设置回调（block）
    dispatch_source_set_event_handler(timer, ^{
        [self updateTimerInfo];
    });
    // 启动定时器
    dispatch_resume(timer);
    // 保住定时器的命
    self.timer = timer;
}

- (void)stopTimer {
    dispatch_source_cancel(self.timer);
}

- (void)updateTimerInfo {
//    NSArray *methodNames = [NSThread callStackSymbols];
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
