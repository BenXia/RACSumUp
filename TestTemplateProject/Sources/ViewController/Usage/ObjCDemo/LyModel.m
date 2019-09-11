//
//  LyModel.m
//  LyReactiveCocoaDemo
//
//  Created by 张杰 on 2017/3/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyModel.h"

@implementation LyModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[LyModel alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
