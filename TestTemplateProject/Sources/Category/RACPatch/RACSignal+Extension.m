//
//  RACSignal+Extension.m
//  QQingCommon
//
//  Created by 王涛 on 15/11/5.
//  Copyright © 2015年 QQingiOSTeam. All rights reserved.
//

#import "RACSignal+Extension.h"
#import "ReactiveObjC.h"

@implementation RACSignal (Extension)

- (RACSignal *)onMainThread {
    return [self deliverOn:RACScheduler.mainThreadScheduler];
}

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray
                  respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray
                            nextOnMainArray:(NSArray *)nextOnMainArray
                           errorOnMainArray:(NSArray *)errorOnMainArray {
    NSMutableArray *wrappedSignalsArray = [NSMutableArray arrayWithCapacity:signalsArray.count];
    
    for (int i = 0; i < signalsArray.count; i++) {
        RACSignal *originSignal = [signalsArray objectAtIndex:i];
        void (^originNextBlock)(id x) = [signalNextBlockArray objectAtIndex:i];
        void (^originErrorBlock)(id x) = [signalErrorBlockArray objectAtIndex:i];
        BOOL nextOnMain = [[nextOnMainArray objectAtIndex:i] boolValue];
        BOOL errorOnMain = [[errorOnMainArray objectAtIndex:i] boolValue];
        RACSignal *wrappedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [originSignal subscribeNext:^(id x) {
                if (nextOnMain) {
                    if ([NSThread isMainThread]) {
                        originNextBlock(x);
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            originNextBlock(x);
                        });
                    }
                } else {
                    originNextBlock(x);
                }

                [subscriber sendNext:x];
            } error:^(NSError *error) {
                if (errorOnMain) {
                    if ([NSThread isMainThread]) {
                        originErrorBlock(error);
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            originErrorBlock(error);
                        });
                    }
                } else {
                    originErrorBlock(error);
                }
                
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        [wrappedSignalsArray addObject:wrappedSignal];
    }
    
    return [RACSignal combineLatest:wrappedSignalsArray];
}

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray
                  respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray {
    NSMutableArray *wrappedSignalsArray = [NSMutableArray arrayWithCapacity:signalsArray.count];
    
    for (int i = 0; i < signalsArray.count; i++) {
        RACSignal *originSignal = [signalsArray objectAtIndex:i];
        void (^originNextBlock)(id x) = [signalNextBlockArray objectAtIndex:i];
        void (^originErrorBlock)(id x) = [signalErrorBlockArray objectAtIndex:i];
        RACSignal *wrappedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [originSignal subscribeNext:^(id x) {
                originNextBlock(x);
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                originErrorBlock(error);
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        [wrappedSignalsArray addObject:wrappedSignal];
    }
    
    return [RACSignal combineLatest:wrappedSignalsArray];
}

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray {
    NSMutableArray *wrappedSignalsArray = [NSMutableArray arrayWithCapacity:signalsArray.count];
    
    for (int i = 0; i < signalsArray.count; i++) {
        RACSignal *originSignal = [signalsArray objectAtIndex:i];
        void (^originNextBlock)(id x) = [signalNextBlockArray objectAtIndex:i];
        RACSignal *wrappedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [originSignal subscribeNext:^(id x) {
                originNextBlock(x);
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        [wrappedSignalsArray addObject:wrappedSignal];
    }
    
    return [RACSignal combineLatest:wrappedSignalsArray];
}

@end


