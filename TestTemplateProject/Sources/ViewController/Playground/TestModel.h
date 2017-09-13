//
//  TestModel.h
//  TestTemplateProject
//
//  Created by Ben on 2017/9/13.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, copy) NSString *name;

+ (instancetype)sharedInstance;

@end
