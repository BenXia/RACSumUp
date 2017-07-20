//
//  RACSignal+Extension.h
//  QQingCommon
//
//  Created by 王涛 on 15/11/5.
//  Copyright © 2015年 QQingiOSTeam. All rights reserved.
//

#import "RACSignal.h"

@interface RACSignal (Extension)

- (RACSignal *)onMainThread;

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray
                  respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray
                            nextOnMainArray:(NSArray *)nextOnMainArray
                           errorOnMainArray:(NSArray *)errorOnMainArray;

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray
                  respectiveErrorBlockArray:(NSArray *)signalErrorBlockArray;

+ (RACSignal *)createSignalWithSignalsArray:(NSArray <RACSignal *> *)signalsArray
                   respectiveNextBlockArray:(NSArray *)signalNextBlockArray;

@end


