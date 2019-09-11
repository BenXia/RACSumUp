//
//  LyViewController.m
//  LyReactiveCocoaDemo
//
//  Created by 张杰 on 2017/2/28.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyViewController.h"

@interface LyViewController ()

@end

@implementation LyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)notice:(id)sender {
    // 通知第一个控制器，告诉它，按钮被点了
    
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:nil];
    }
}

@end
