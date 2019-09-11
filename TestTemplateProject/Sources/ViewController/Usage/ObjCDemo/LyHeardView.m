//
//  LyHeardView.m
//  LySwiftDemo
//
//  Created by 张杰 on 2017/3/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyHeardView.h"

@interface LyHeardView ()

@property(nonatomic,strong)UIButton *btn;

@property(nonatomic,strong)RACSignal  *signal;//只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出
@end

@implementation LyHeardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.btn];
        
        //点击了按钮
//        //第1种
//        [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable btn) {
//            
//            [self.subject sendNext:btn.currentTitle];
//            
//            //注意:加上这个点了一次就不能点第二次了
//            [self.subject sendCompleted];
//        }];
        
        //第2种
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
//    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//           
//            [subscriber sendNext:@"发送消息"];
//            [subscriber sendCompleted];
////            return nil;
//            return [RACDisposable disposableWithBlock:^{
//                
//            }];
//        }];
//        
//    }];
//    
//    // 3.执行命令
//    [self.command execute:@1];
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    self.command = command;
    
    
    // 3.执行命令
//    [self.command execute:@1];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.btn.frame = CGRectMake(10, 10, 50, 20);
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        _btn.backgroundColor = [UIColor lightGrayColor];
        [_btn setTitle:@"按钮" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    return _btn;
}

- (RACSubject *)subject
{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

@end
