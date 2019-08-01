//
//  UsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "UsageVC.h"

@interface UsageVC ()

@end

@implementation UsageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[[self sig_simple] takeUntilBlock:^BOOL(id x) {
        int indexNum = [x intValue];
        
        if (indexNum == 3) {
            // Flag: 此处可以插入停止时需要做的事情
            NSLog(@"此处可以插入停止时需要做的事情");
            
            return YES;
        }
        
        return NO;
    }] subscribeNext:^(id x) {
        // need do nothing, 要做的在takeUntilBlock:中做完了
        
        NSLog(@"get next: %@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACSignal *)sig_simple {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        for (int i = 1; i < 6; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@(i)];
            });
        }
        
        return nil;
    }];
}

@end


