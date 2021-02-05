//
//  SingleOperationsVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "SingleOperationsVC.h"

@interface SingleOperationsVC ()

@property (nonatomic, assign) BOOL isEnter;

@end

@implementation SingleOperationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self testThrottleOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testThrottleOperation {
    [[[RACObserve(self, isEnter) distinctUntilChanged] throttle:5] subscribeNext:^(id  _Nullable x) {
        NSLog(@"get next value: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"get error: %@", error);
    }];
    
//    [[[RACObserve(self, isEnter) throttle:5] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"get next value: %@", x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"get error: %@", error);
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = NO;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = NO;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnter = YES;
    });
}

@end
