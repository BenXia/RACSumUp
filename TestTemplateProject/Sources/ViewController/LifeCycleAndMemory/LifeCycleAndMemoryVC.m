//
//  LifeCycleAndMemoryVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "LifeCycleAndMemoryVC.h"

@interface LifeCycleAndMemoryVC ()

@end

@implementation LifeCycleAndMemoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self testColdSignal];
    [self testHotSignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testColdSignal {
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block BOOL needStop = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            int timeInterval = 0;
            while (!needStop) {  //1) {
                if (timeInterval == 10) {
                    [subscriber sendCompleted];
                }
                
                NSLog (@"sendNext: %d", timeInterval);
                
                [subscriber sendNext:@(timeInterval++)];
                
                sleep(1);
            }
            
            [subscriber sendCompleted];
        });
        
        return [RACDisposable disposableWithBlock:^{
            needStop = YES;
        }];
    }];
    
    [coldSignal setName:@"Cold signal for test"];
    
    RACDisposable *disposable = [coldSignal subscribeNext:^(id x) {
        NSLog (@"subscribeNext: %@", x);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [disposable dispose];
    });
}

- (void)testHotSignal {
    RACSubject *hotSignal = [[RACSubject alloc] init];
    [hotSignal setName:@"Hot signal for test"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        int timeInterval = 0;
        while (1) {
            if (timeInterval == 20) {
                [hotSignal sendCompleted];
            }
            
            NSLog (@"sendNext: %d", timeInterval);
            
            [hotSignal sendNext:@(timeInterval++)];
            
            sleep(1);
        }
    });

    RACDisposable *disposable1 = [hotSignal subscribeNext:^(id x) {
        NSLog (@"1subscribeNext: %@", x);
    }];
    (void)disposable1;
    RACDisposable *disposable2 = [hotSignal subscribeNext:^(id x) {
        NSLog (@"2subscribeNext: %@", x);
    }];
    (void)disposable2;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [disposable1 dispose];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [disposable2 dispose];
//    });
}

@end


