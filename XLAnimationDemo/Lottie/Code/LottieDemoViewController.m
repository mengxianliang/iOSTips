//
//  LottieDemoViewController.m
//  XLAnimationDemo
//
//  Created by mxl on 2022/10/14.
//

#import "LottieDemoViewController.h"
#import "TransitionDemoViewController.h"
#import "Lottie.h"

@interface LottieDemoViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) LOTAnimationView *animationView;

@end

@implementation LottieDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"Watermelon"];
    [self.view addSubview:animationView];
    animationView.frame = CGRectMake(0, 100, 500, 500);
    animationView.center = CGPointMake(self.view.center.x, animationView.center.y);
    [animationView play];
    self.animationView = animationView;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationView.frame), 500, 50)];
    slider.center = CGPointMake(self.view.center.x, slider.center.y);
    slider.value = 0;
    [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 200, 100, 100)];
    button.center = CGPointMake(self.view.center.x, button.center.y);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"转场" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)slideValueChanged:(UISlider *)slider {
    self.animationView.animationProgress = slider.value;
}

#pragma mark - Lttie 转场动画
- (void)buttonClick {
    TransitionDemoViewController *vc = [[TransitionDemoViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

// present 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition1" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:NO];
    return animationController;
}

// 返回 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition2" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:NO];
    return animationController;
}

@end
