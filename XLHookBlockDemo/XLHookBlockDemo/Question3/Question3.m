//
//  Question3.m
//  HookBlockDemo
//
//  Created by mxl on 2022/9/7.
//

#import "Question3.h"
#import "NSObject+HookEveryBlock.h"

@implementation Question3

+ (void)answer {
    
    // hook 所有block
    HookEveryBlockToPrintArguments();
    
    int val = 10;
    
    TestBlock block1 = ^(int a, int b, int c){
        NSLog(@"block1执行 val = %d", val);
    };
    block1(1, 2, 3);
    
    
    TestBlock block2 = ^(int a, int b, int c){
        NSLog(@"block2执行");
    };
    block2(4, 5, 6);

    TestBlock block3 = ^(int a, int b, int c){
        NSLog(@"block3执行");
    };
    block3(7, 8, 9);
}




@end
