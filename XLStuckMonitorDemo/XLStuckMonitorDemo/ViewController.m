//
//  ViewController.m
//  XLStuckMonitorDemo
//
//  Created by mxl on 2022/10/11.
//

#import "ViewController.h"
#import "XLStuckMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XLStuckMonitor shareInstance] startMonitor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"sleep 开始");
    sleep(3);
    NSLog(@"sleep 结束");
}

@end
