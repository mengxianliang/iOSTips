//
//  ViewController.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/6.
//

#import "ViewController.h"
#import "Question1.h"
#import "Question2.h"
#import "Question3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第一个问题的答案
//    [Question1 answer];
    
    // 第二个问题的答案
//    [Question2 answer];
    
    // 第三个问题的答案
    [[[Question3 alloc] init] answer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[Question3 alloc] init] start];
}


@end
