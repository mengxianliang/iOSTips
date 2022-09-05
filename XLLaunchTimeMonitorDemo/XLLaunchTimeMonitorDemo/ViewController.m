//
//  ViewController.m
//  XLLaunchTimeMonitorDemo
//
//  Created by mxl on 2022/9/5.
//

#import "ViewController.h"
#import "XLLaunchTimeMonitor.h"
#import "SMCallTrace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [[XLLaunchTimeMonitor shareInstance] stop];
//    NSString *info = [[XLLaunchTimeMonitor shareInstance] info];
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"启动统计信息" message:info preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alertVC animated:true completion:nil];
    
    [SMCallTrace stop];
    [SMCallTrace save];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self method1];
}

- (void)method1 {
    sleep(1);
    [self method2];
}

- (void)method2 {
    sleep(2);
    [self method3];
}

- (void)method3 {
    sleep(3);
}

@end
