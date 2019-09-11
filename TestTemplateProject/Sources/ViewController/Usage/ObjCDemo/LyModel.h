//
//  LyModel.h
//  LyReactiveCocoaDemo
//
//  Created by 张杰 on 2017/3/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *title;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
