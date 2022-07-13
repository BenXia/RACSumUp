//
//  ColdHotSignalVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/7/20.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ColdHotSignalVC.h"
#import "ColdHotSignalVM.h"

@interface ColdHotSignalVC ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic, strong) ColdHotSignalVM *vm;

@end

@implementation ColdHotSignalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self testHotSignal];
    
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testHotSignal {
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [subscriber sendNext:@"A"];
        }];
 
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"B"];
        }];
 
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            [subscriber sendCompleted];
        }];
 
 
        return nil;
    }];
 
    RACSubject *subject = [RACSubject subject];
    NSLog(@"Subject created.");
 
    RACMulticastConnection *multicastConnection = [coldSignal multicast:subject];
    RACSignal *hotSignal = multicastConnection.signal;
 
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [multicastConnection connect];
    }];
 
    [hotSignal subscribeNext:^(id x) {
        NSLog(@"Subscribe 1 recieve value:%@.", x);
    }];
 
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [hotSignal subscribeNext:^(id x) {
            NSLog(@"Subscribe 2 recieve value:%@.", x);
        }];
    }];
}

- (void)bindViewModel {
    self.vm = [ColdHotSignalVM new];
    
    ColdHotSignalVM *vm = self.vm;
    
    [vm.com_combine.executing subscribeNext:^(NSNumber *x) {
        NSLog(@"executing next : %@", x);
    } error:^(NSError *error) {
        NSLog(@"executing error : %@", error);
    } completed:^{
        NSLog(@"executing completed");
    }];
    
    [vm.com_combine.executionSignals subscribeNext:^(RACSignal *sig) {
        [[sig onMainThread] subscribeNext:^(id x) {
            NSLog(@"executionSignals inner signal next : %@", x);
        } error:^(NSError *error) {
            NSLog(@"executionSignals inner signal error : %@", error);
        } completed:^{
            NSLog(@"executionSignals inner signal completed");
        }];
    } error:^(NSError *error) {
        NSLog(@"executionSignals error : %@", error);
    } completed:^{
        NSLog(@"executionSignals completed");
    }];
    
    [vm.com_combine.errors subscribeNext:^(NSError *x) {
        NSLog(@"errors next : %@", x);
    } error:^(NSError *error) {
        NSLog(@"errors error : %@", error);
    } completed:^{
        NSLog(@"errors completed");
    }];
}

- (IBAction)didClickStartButtonAction:(id)sender {
    [self.vm.com_combine execute:nil];
}

@end


