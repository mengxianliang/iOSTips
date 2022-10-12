//
//  ViewController.m
//  XLAnimationDemo
//
//  Created by mxl on 2022/10/12.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "Lottie.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) LOTAnimationView *animationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"NoSignal"];
    [self.view addSubview:animationView];
    animationView.frame = CGRectMake(100, 100, 200, 200);
    animationView.loopAnimation = YES;
    [animationView play];
    self.animationView = animationView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
    [self.view addGestureRecognizer:pan];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 200, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)panMethod:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat progress = [pan locationInView:self.view].x/self.view.bounds.size.width;
            self.animationView.animationProgress = progress;
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self.animationView play];
            break;
            
        default:
            break;
    }
}

- (void)buttonClick {
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    vc2.modalPresentationStyle = UIModalPresentationFullScreen;
    vc2.transitioningDelegate = self;
    [self presentViewController:vc2 animated:YES completion:nil];
}

- (IBAction)slider:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    self.animationView.animationProgress = slider.value;
}


// present 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"Loading" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:NO];
    return animationController;
}

// pop 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"Loading" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:NO];
    return animationController;
}


@end
