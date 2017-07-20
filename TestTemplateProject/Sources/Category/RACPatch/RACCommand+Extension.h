//
//  RACCommand+Extension.h
//  QQingCommon
//
//  Created by 郭晓倩 on 16/3/23.
//  Copyright © 2016年 QQingiOSTeam. All rights reserved.
//

#import "RACCommand.h"

typedef void(^ExecutingBlock)(BOOL executing);
typedef void(^ExecutionBlock)(id x);


@interface RACCommand (Extension)

- (void)executingNext:(ExecutingBlock)executingBlock;

- (void)executingNextFirstCouple:(ExecutingBlock)executingBlock; //只取第一对（常用来首次加载动画）

- (void)executationSignalNext:(ExecutionBlock)executionBlock;

- (void)executationSignalNextOneTime:(ExecutionBlock)executionBlock; //只取一次

- (void)executationSignalCompleted:(Block)completedBlock;

- (void)errorNext:(ErrorBlock)errorBlock;

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray
              respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray
                        nextOnMainArray:(NSArray *)nextOnMainArray
                       errorOnMainArray:(NSArray *)errorOnMainArray;

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray
              respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray;

+ (RACCommand *)commandWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
               respectiveNextBlockArray:(NSArray *)signalNextBlockArray;

@end


