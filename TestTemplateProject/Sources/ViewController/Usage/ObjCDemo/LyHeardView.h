//
//  LyHeardView.h
//  LySwiftDemo
//
//  Created by 张杰 on 2017/3/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LyHeardView : UIView

/*
信号提供者，自己可以充当信号，又能发送信号
使用场景:通常用来代替代理，有了它，就不必要定义代理了
 */
@property(nonatomic,strong)RACSubject *subject;

@property(nonatomic,strong)RACCommand *command;

@end
