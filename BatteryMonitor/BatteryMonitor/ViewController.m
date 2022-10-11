//
//  ViewController.m
//  BatteryMonitor
//
//  Created by mxl on 2022/10/11.
//

#import "ViewController.h"
#include "IOPowerSources.h"
#include "IOPSKeys.h"

#import <mach/mach.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIDevice currentDevice].batteryMonitoringEnabled = true;
    
    dispatch_block_t block =  dispatch_block_create_with_qos_class(DISPATCH_BLOCK_BARRIER, QOS_CLASS_UTILITY, 0, ^{
        
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}

- (double)getBatteryLevel {
    // 返回电量信息
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    // 返回电量句柄列表数据
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    // 返回数组大小
    int numOfSources = (int)CFArrayGetCount(sources);
    // 计算大小出错处理
    if (numOfSources == 0) {
        NSLog(@"Error in CFArrayGetCount");
        return -1.0f;
    }
    // 获取电源可读信息的字典
    pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, 0));
    if (!pSource) {
        NSLog(@"Error in IOPSGetPowerSourceDescription");
        return -1.0f;
    }
    psValue = (CFStringRef) CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));

    int curCapacity = 0;
    int maxCapacity = 0;
    double percentage;

    psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
    CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);

    psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
    CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);

    percentage = ((double) curCapacity / (double) maxCapacity * 100.0f);
    NSLog(@"curCapacity : %d / maxCapacity: %d , percentage: %.1f ", curCapacity, maxCapacity, percentage);
    return percentage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self getBatteryLevel];
    NSLog(@"当前电量 = %f", [UIDevice currentDevice].batteryLevel);
    [self checkCpuUsage];
    
}

- (void)checkCpuUsage {
    const task_t thisTask = mach_task_self();
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    kern_return_t kr = task_threads(thisTask, &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return;
    }
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_data_t thinfo;
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return;
        }
        thread_basic_info_t basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            float cpu_uase = basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
            if (cpu_uase > 0.8) {
                // cpu 占用过高
            }
        }
    }
}



@end
