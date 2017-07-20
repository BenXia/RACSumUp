//
//  ColdHotSignalVM.m
//  TestTemplateProject
//
//  Created by Ben on 2017/7/20.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ColdHotSignalVM.h"

@implementation ColdHotSignalVM

- (RACCommand *)com_combine {
    if (!_com_combine) {
        _com_combine = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[self sig_simpleOne] merge:[self sig_simpleTwo]];
        }];
    }
    
    return _com_combine;
}

- (RACSignal *)sig_simpleOne {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"OK"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

- (RACSignal *)sig_simpleTwo {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"OK"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

@end
