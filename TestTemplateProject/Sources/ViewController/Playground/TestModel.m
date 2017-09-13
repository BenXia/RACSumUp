//
//  TestModel.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/13.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

static TestModel *g_TestModelInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!g_TestModelInstance) {
            g_TestModelInstance = [[super allocWithZone:NULL] init];
        }
    });
    
    return g_TestModelInstance;
}

- (instancetype)allocWithZone:(NSZone *)zone {
    return [TestModel sharedInstance];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

@end


