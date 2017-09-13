//
//  PlaygroundVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import "PlaygroundVC.h"
#import "TestModel.h"

static NSString *const kPostSuccess = @"kPostSuccess";

@interface PlaygroundVC ()

@end

@implementation PlaygroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TestModel sharedInstance].name = @"GuoDuo is fine";
    [[RACObserve([TestModel sharedInstance], name) onMainThread] subscribeNext:^(id x) {        // 不需要加上 takeUntil:self.rac_willDeallocSignal，否则订阅关系还在
        NSLog (@"[TestModel sharedInstance].name : %@", [TestModel sharedInstance].name);
    }];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPostSuccess object:nil] subscribeNext:^(id x) {     // 注意：需要加上 takeUntil:self.rac_willDeallocSignal，否则订阅关系还在
        @strongify(self);
        NSLog (@"Receive kPostSuccess notification self:%@", self);
    }];
}

- (void)dealloc {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TestModel sharedInstance].name = @"Fine 3Q~";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPostSuccess object:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


