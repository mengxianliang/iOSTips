//
//  ViewController.m
//  RunLoopMonitorDemo
//
//  Created by mxl on 2022/10/8.
//

#import "ViewController.h"
#import "XLRunLoopMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XLRunLoopMonitor shareInstance] startMonitor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"sleep 开始");
    sleep(3);
    NSLog(@"sleep 结束");
}

@end
