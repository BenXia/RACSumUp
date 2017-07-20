//
//  RACCommand+Extension.m
//  QQingCommon
//
//  Created by 郭晓倩 on 16/3/23.
//  Copyright © 2016年 QQingiOSTeam. All rights reserved.
//

#import "RACCommand+Extension.h"

@implementation RACCommand (Extension)

- (void)executingNext:(ExecutingBlock)executingBlock {
    [[[self.executing skip:1]onMainThread]subscribeNext:^(NSNumber* x) {
        if (executingBlock) {
            executingBlock(x.boolValue);
        }
    }];
}

- (void)executingNextFirstCouple:(ExecutingBlock)executingBlock {
    [[[[self.executing skip:1] take:2] onMainThread]subscribeNext:^(NSNumber* x) {
        if (executingBlock) {
            executingBlock(x.boolValue);
        }
    }];
}


- (void)executationSignalNext:(ExecutionBlock)executionBlock {
    [[[self.executionSignals switchToLatest] onMainThread]subscribeNext:^(id x) {
        if (executionBlock) {
            executionBlock(x);
        }
    }];
}

- (void)executationSignalNextOneTime:(ExecutionBlock)executionBlock {
    [[[[self.executionSignals switchToLatest] take:1] onMainThread] subscribeNext:^(id x) {
        if (executionBlock) {
            executionBlock(x);
        }
    }];
}

- (void)executationSignalCompleted:(Block)completedBlock {
    [self.executionSignals subscribeNext:^(id x) {
        [[x onMainThread] subscribeCompleted:^{
            if (completedBlock) {
                completedBlock();
            }
        }];
    }];
}

- (void)errorNext:(ErrorBlock)errorBlock {
    [[self.errors onMainThread]subscribeNext:^(NSError* x) {
        if (errorBlock) {
            errorBlock(x);
        }
    }];
}

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray
              respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray
                        nextOnMainArray:(NSArray *)nextOnMainArray
                       errorOnMainArray:(NSArray *)errorOnMainArray {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignalWithSignalsArray:signalsArray
                              respectiveNextBlockArray:signalNextBlockArray
                             respectiveErrorBlockArray:signalErrorBlockArray
                                       nextOnMainArray:nextOnMainArray
                                      errorOnMainArray:errorOnMainArray];
    }];
}

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray
              respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignalWithSignalsArray:signalsArray
                              respectiveNextBlockArray:signalNextBlockArray
                             respectiveErrorBlockArray:signalErrorBlockArray];
    }];
}

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignalWithSignalsArray:signalsArray
                              respectiveNextBlockArray:signalNextBlockArray];
    }];
}

@end


