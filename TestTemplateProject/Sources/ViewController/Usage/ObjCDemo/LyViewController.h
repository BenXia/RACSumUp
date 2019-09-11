//
//  LyViewController.h
//  LyReactiveCocoaDemo
//
//  Created by 张杰 on 2017/2/28.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LyViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
