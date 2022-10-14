//
//  POPDemoViewController.m
//  XLAnimationDemo
//
//  Created by mxl on 2022/10/14.
//

#import "POPDemoViewController.h"
#import "POP.h"

@interface POPDemoViewController ()

@end

@implementation POPDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 200, 100, 100)];
    button1.backgroundColor = [UIColor blackColor];
    [button1 setTitle:@"弹性" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 400, 100, 100)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"衰减" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - POP 弹性动画
- (void)buttonClick1:(UIButton *)button {
    POPSpringAnimation* animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    // 设置动画开始值
    animation.fromValue = @(100);
    // 设置动画结束值
    animation.toValue = @(self.view.bounds.size.width/2);
    // 设置回弹速度
    animation.springSpeed = 20.0f;
    // 设置回弹幅度
    animation.springBounciness = 20.0f;
    // 执行动画
    [button.layer pop_addAnimation:animation forKey:@"POPSpringAnimation"];
}

#pragma mark - POP 衰减动画
- (void)buttonClick2:(UIButton *)button {
    POPDecayAnimation* animation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    // 设置动画开始值
    animation.fromValue = @(100);
    // 设置初始速度
    animation.velocity = @(500);
    // 执行动画
    [button.layer pop_addAnimation:animation forKey:@"POPDecayAnimation"];
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
