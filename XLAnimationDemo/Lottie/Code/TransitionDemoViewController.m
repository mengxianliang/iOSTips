//
//  TestViewController.m
//  XLAnimationDemo
//
//  Created by mxl on 2022/10/14.
//

#import "TransitionDemoViewController.h"

@interface TransitionDemoViewController ()

@end

@implementation TransitionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 200, 100, 100)];
    button.center = CGPointMake(self.view.center.x, button.center.y);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClick {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
