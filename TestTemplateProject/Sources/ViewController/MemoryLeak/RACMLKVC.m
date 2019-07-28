//
//  RACMLKVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import "RACMLKVC.h"

@interface RACMLKVC ()

@property (nonatomic, strong) RACSignal *flattenMapSignal;

@end

@implementation RACMLKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self racMemoryLeakTestSample1];
    
    [self racMemoryLeakTestSample2];
}

- (void)racMemoryLeakTestSample1 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        LocationModel *model = [[LocationModel alloc] init];
        [subscriber sendNext:model];
        [subscriber sendCompleted];
        return nil;
    }];
    //@weakify(self);
    self.flattenMapSignal = [signal flattenMap:^RACSignal *(LocationModel *model) {
        //@strongify(self);
        return RACObserve(model, address);
    }];
    [self.flattenMapSignal subscribeNext:^(id x) {
        NSLog(@"subscribeNext - %@", x);
    }];
}

- (void)racMemoryLeakTestSample2 {
    RACSubject *subject = [RACSubject subject];
    [subject.rac_willDeallocSignal subscribeCompleted:^{
        NSLog(@"subject dealloc");
    }];
    
    [[subject map:^id(NSNumber *value) {
        return @([value integerValue] * 3);
    }] subscribeNext:^(id x) {
        NSLog(@"next = %@", x);
    }];
    [subject sendNext:@1];
    //[subject sendCompleted];
    //(1).帖子上说放开这一行则不会有内存泄漏（但是自己测试发现不加这行，也不会有内存泄漏）（http://netsecurity.51cto.com/art/201608/516249.htm）
    //    帖子上说 subscriber 中 nextBlock 持有 singals 和当前signal（即 subject），并且当前 signal（即 subject 持有了subsciber），所有出现了环引用
    //    但是看了最新的源码，发现已经没有了 signals 的局部变量，并且 subscriber 中的 nextBlock 不持有当前 signal（即 subject），所以只是  当前 signal（即subject持有了 subscriber），所以没有了环引用
    
    //    // (2).换成下面的 RACSignal 则不会内存泄漏
    //    // subscriber 中 nextBlock 持有 singals 和 signal，并且其中 singals 持有 signal，没有环引用
    //    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@1];
    //        return nil;
    //    }];
    //    [signal.rac_willDeallocSignal subscribeCompleted:^{
    //        NSLog(@"signal dealloc");
    //    }];
    //    [[signal map:^id(NSNumber *value) {
    //        return @([value integerValue] * 3);
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"next = %@", x);
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation LocationModel

@end


