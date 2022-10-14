//
//  PAGDemoViewController.m
//  XLAnimationDemo
//
//  Created by mxl on 2022/10/14.
//

#import "PAGDemoViewController.h"
#include <libpag/PAGView.h>

@interface PAGDemoViewController ()

@property (nonatomic, strong) PAGView *pagView;

@end

@implementation PAGDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //读取PAG素材文件
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"18" ofType:@"pag"];
    PAGFile *pagFile = [PAGFile Load:resourcePath];
    
    //创建PAG播放视图PAGView
    PAGView *pagView = [[PAGView alloc] initWithFrame:CGRectMake(0, 100, 500, 500)];
    pagView.center = CGPointMake(self.view.center.x, pagView.center.y);
    [self.view addSubview:pagView];
    //关联PAGView和PAGFile
    [pagView setComposition:pagFile];
    //设置循环播放，默认只播放一次
    [pagView setRepeatCount:0];
    //播放
    [pagView play];
    self.pagView = pagView;
    
    [self.view addSubview:pagView];

    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pagView.frame), 500, 50)];
    slider.center = CGPointMake(self.view.center.x, slider.center.y);
    slider.value = 0;
    [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}

- (void)slideValueChanged:(UISlider *)slider {
    [self.pagView setProgress:slider.value];
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
