//
//  ObjCUsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ObjCUsageVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LyModel.h"
#import "LyHeardView.h"
#import "LyViewController.h"

@interface ObjCUsageVC ()

@property (nonatomic, strong) LyHeardView *heardView;
@property (nonatomic, strong) UITextField *textField_num;
@property (nonatomic, strong) UITextField *textField_cell;
@property (nonatomic, strong) UIButton    *btn;
@property (nonatomic, strong) UILabel     *label;

@property (nonatomic, strong) RACCommand  *command;

@end

@implementation ObjCUsageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)initView {
    self.title = @"RAC例子";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.heardView];
    [self.view addSubview:self.textField_num];
    [self.view addSubview:self.textField_cell];
    [self.view addSubview:self.btn];
    [self.view addSubview:self.label];
    
    //1.KVO
    [[self.heardView rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //2.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    //3.监听文本框的文字改变
    RACSignal *signal1 = [self.textField_num rac_textSignal];
    RACSignal *signal2 = [self.textField_cell rac_textSignal];
    
    //4.多个信号连用
    //    [self rac_liftSelector:@selector(changeBtnStatusWithSig1:sig2:) withSignals:signal1,signal2, nil];
    
    //多个信号连用
    [[RACSignal combineLatest:@[signal1,signal2]] subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *str1 , NSString *str2) = x;
        
        self.btn.enabled = (str1.length > 0 && str2.length > 0);
    }];
    
    //[self test6];  // test1 ~ test23
    
    [self testWithReduce];
}

- (void)initData {
    NSDictionary *dict1 = @{@"name" : @"mc" , @"title" : @"1"};
    NSDictionary *dict2 = @{@"name" : @"yj" , @"title" : @"2"};
    NSDictionary *dict3 = @{@"name" : @"lf" , @"title" : @"3"};
    NSArray *array = @[dict1,dict2,dict3];
    
    //字典遍历
    [dict1.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(NSString *key , NSString *value) = x;
    }];
    
    NSMutableArray *arrayModel = [[NSMutableArray alloc] init];
    
    //字典数组 -> model数组
    //第1种
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        LyModel *model = [LyModel modelWithDict:x];
        [arrayModel addObject:model];
        
    } completed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新数据
            //注意：由于处理数据是在子线程,so要在主线程刷新UI,而且是在completed这才完成数据处理
        });
    }];
    
    //第2种
    NSArray *modelArray = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [LyModel modelWithDict:value];
        
    }] array];
}

- (LyHeardView *)heardView {
    if (!_heardView) {
        _heardView = [[LyHeardView alloc] init];
        _heardView.backgroundColor = [UIColor redColor];
        _heardView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    }
    return _heardView;
}

- (UITextField *)textField_cell {
    if (!_textField_cell) {
        _textField_cell = [[UITextField alloc] init];
        _textField_cell.frame = CGRectMake(0, 300, 100, 30);
        _textField_cell.backgroundColor = [UIColor yellowColor];
    }
    return _textField_cell;
}

- (UITextField *)textField_num {
    if (!_textField_num) {
        _textField_num = [[UITextField alloc] init];
        _textField_num.frame = CGRectMake(150, 300, 100, 30);
        _textField_num.backgroundColor = [UIColor orangeColor];
    }
    return _textField_num;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        _btn.backgroundColor = [UIColor blueColor];
        [_btn setTitle:@"可以点击" forState:UIControlStateNormal];
        [_btn setTitle:@"不可点击" forState:UIControlStateDisabled];
        [_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _btn.enabled = NO;
        _btn.frame = CGRectMake(0, 350, 200, 30);
    }
    return _btn;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.frame = CGRectMake(220, 350, 200, 30);
    }
    return _label;
}

/*
RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。

RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。
 
RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
使用场景:通常用来代替代理，有了它，就不必要定义代理了。
 
RACReplaySubject:重复提供信号类，RACSubject的子类。

RACReplaySubject与RACSubject区别:
RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
 */
- (void)test1 {
    //1.创建信号
    RACSignal *signgam = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //2.发送
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // 3.订阅信号,才会激活信号.
    [signgam subscribeNext:^(id  _Nullable x) {
        
    }];
}

//RACSubject
//RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
//使用场景:通常用来代替代理，有了它，就不必要定义代理了。
- (void)test2 {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
}

//RACSubject替换代理delegate
- (IBAction)btnClick:(id)sender {
    // 创建第二个控制器
    LyViewController *twoVc = [[LyViewController alloc] init];
    
    // 设置代理信号
    twoVc.delegateSignal = [RACSubject subject];
    
    // 订阅代理信号
    [twoVc.delegateSignal subscribeNext:^(id x) {
        
        NSLog(@"收到第二个控制器返回来的消息");
    }];
    
    // 跳转到第二个控制器
    [self presentViewController:twoVc animated:YES completion:nil];
    
}

//RACReplaySubject
//使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
//使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
- (void)test3 {
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
}

/*
RACTuple:元组类,类似NSArray,用来包装值.
RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
使用场景：1.字典转模型
 */
//RACSequence和RACTuple简单使用
- (void)test4 {
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg", @"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@", key, value);
    }];
    
    // 3.字典转模型
    // 3.1 OC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (NSDictionary *dict in dictArr) {
//        FlagItem *item = [FlagItem flagWithDict:dict];
//        [items addObject:item];
//    }
//    
//    // 3.2 RAC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *flags = [NSMutableArray array];
//    
//    _flags = flags;
//    
//    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
//    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
//        // 运用RAC遍历字典，x：字典
//        
//        FlagItem *item = [FlagItem flagWithDict:x];
//        
//        [flags addObject:item];
//        
//    }];
//    
//    // 3.3 RAC高级写法:
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    // map:映射的意思，目的：把原始值value映射成一个新值
//    // array: 把集合转换成数组
//    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
//        
//        return [FlagItem flagWithDict:value];
//        
//    }] array];
}

/*
 RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
 
 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建
 */
- (void)test5 {
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    // 1.创建请求信号
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        
        return nil;
    }];
    // 2.订阅信号
    [signal1 subscribeNext:^(id x) {
        NSLog(@"接收数据");
    }];
    // 2.订阅信号
    [signal1 subscribeNext:^(id x) {
        NSLog(@"接收数据");
    }];
    
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求

    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者一信号");
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号");
    }];
    
    // 4.连接,激活信号
    [connect connect];
}

/*
 RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
 
 使用场景:监听按钮点击，网络请求
 */
- (void)test6 {
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    static int s_value = 0;
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                s_value++;
                
                [subscriber sendNext:@(s_value)];
                
                // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
                [subscriber sendCompleted];
                
            });
            

            
            return nil;
        }];
    }];
    
//    command.allowsConcurrentExecution = YES;
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    // 4.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
//    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 5.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");

        } else {
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    
    // 3.执行命令
    [[self.command execute:@1] subscribeNext:^(id  _Nullable x) {
        NSLog (@"get next value in 1 : %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog (@"error in 1");
    }];
    [[self.command execute:@2] subscribeNext:^(id  _Nullable x) {
        NSLog (@"get next value in 2 : %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog (@"error in 2");
    }];
}

// 代替代理
- (void)test7 {
    // 代替代理
    // 需求：自定义heardView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[self.heardView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
}

// KVO
- (void)test8 {
    // KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[self.heardView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// 监听事件
- (void)test9 {
    // 监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了");
    }];
}

// 代替通知
- (void)test10 {
    // 代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
}

// 监听文本框的文字改变
- (void)test11 {
    // 监听文本框的文字改变
    [_textField_num.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了%@",x);
    }];
}

// 处理多个请求，都返回结果的时候，统一做处理.
- (void)test12 {
    // 处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1, request2]];
}

// 更新UI
- (void)updateUIWithR1:(id)data1 r2:(id)data2 {
    NSLog(@"更新UI%@  %@", data1, data2);
}

// takeUntilBlock 使用举例
- (void)test13 {
    [[[self sig_simple] takeUntilBlock:^BOOL(id x) {
        int indexNum = [x intValue];
        
        if (indexNum == 3) {
            // Flag: 此处可以插入停止时需要做的事情
            NSLog(@"此处可以插入停止时需要做的事情");
            
            return YES;
        }
        
        return NO;
    }] subscribeNext:^(id x) {
        // need do nothing, 要做的在takeUntilBlock:中做完了
        
        NSLog(@"get next: %@", x);
    }];
}

// takeUntilBlock 使用举例
- (RACSignal *)sig_simple {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        for (int i = 1; i < 6; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@(i)];
            });
        }
        
        return nil;
    }];
}

//过滤
- (void)test14 {
    //1.filter:过滤信号，使用它可以获取满足条件的信号
    [[self.textField_num.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"get next: %@", x);
    }];
    
    //2.ignore:忽略完某些值的信号
    [[self.textField_num.rac_textSignal ignore:@"1"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"get next: %@", x);
    }];
  
    //3.distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
    //使用场合:在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[self.textField_num.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"get next: %@", x);
    }];
}

- (void)test15 {
    //take:从开始一共取N次的信号
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}

//takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
- (void)test16 {
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    //一定不能少
    [signal sendCompleted];
}

- (void)test17 {
    //1.takeUntil:(RACSignal *):获取信号直到执行完这个信号
    // 监听文本框的改变，知道当前对象被销毁
    [self.textField_num.rac_textSignal takeUntil:self.rac_willDeallocSignal];
    
    //2.skip:(NSUInteger):跳过几个信号,不接受
    // 表示输入第一次，不会被监听到，跳过第一次发出的信号
    [[self.textField_num.rac_textSignal skip:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //3.switchToLatest
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    RACSubject *signal = [RACSubject subject];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
    
    [[signalOfSignals skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x is %@", x);
    }];
    
    RACSubject *signal2 = [RACSubject subject];
    [signalOfSignals sendNext:signal2];
    [signal2 sendNext:@2];
    
    RACSubject *signal3 = [RACSubject subject];
    [signalOfSignals sendNext:signal3];
    [signal3 sendNext:@3];
}

//秩序
- (void)test18 {
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

//时间
- (void)test19 {
    //1.timeout：超时，可以让一个信号在一定的时间后，自动报错
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
    
    //2.interval 定时：每隔一段时间发出信号
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //3.delay 延迟发送next。
    RACSignal *signal1 = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

//ReactiveCocoa常见宏
- (void)test20 {
    //1.用于给某个对象的某个属性绑定
    RAC(self.label, text) = self.textField_num.rac_textSignal;
    
    //2.监听某个对象的某个属性,返回的是信号
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"label   %@",x);
    }];
    
    //3.@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,解决循环引用问题
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSLog(@"%@",self);
        
        return nil;
    }];
}

- (void)changeBtnStatusWithSig1:(NSString *)str1 sig2:(NSString *)str2 {
    //    NSLog(@"1   %@,2   %@",data1,data2);
    
    self.btn.enabled = (str1.length > 0 && str2.length > 0);
}

//RAC代替delegate的方式
- (void)delegateWithRAC {
    //订阅信号
    //第一种方式：回调
    [self.heardView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击了%@",x);
    }];
    
    //第二种
    [[self.heardView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack_(UIButton *btn) = x;
        NSLog(@"点击了%@",btn.currentTitle);
    }];
}

// RACMulticastConnection:解决重复请求问题
- (void)replyRAC {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@""];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者一信号");
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号");
    }];
    
    // 4.连接,激活信号
    [connect connect];
}

//命令RACCommand
- (void)executionSignals {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"%@",input);
        
#warning 注意：不能返回nil，如果不需要传递数据可以返回[RACSignal empty]
        //        return [RACSignal empty];
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            return nil;
        }];
    }];
    
    // 订阅信号
#warning 注意:必须要在执行命令前,订阅
    //executionSignals:信号源,信号中信号,signalOfSignals:信号:发送数据就是信号
    //第1种
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    // switchToLatest获取最新发送的信号,只能用于信号中信号
    //第2种
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    //第3种
    [[command.executing skip:1] subscribeNext:^(id  _Nullable x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
        } else {
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    
    // 2.执行命令
    [command execute:@1];
    
    [[self rac_valuesForKeyPath:@keypath(self,view.frame) observer:self] subscribeNext:^(id  _Nullable x) {
        
    }];
}

//避免重复订阅信号
- (void)test21 {
    /**
     RACDynamicSignal
     */
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"123"];
        return nil;
    }];
    
    RACMulticastConnection *connect = [signal publish];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [connect connect];
}

- (void)test22 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //注意:这里不能返回nil,可以返回空信号[RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"1"];
            return nil;
        }];
        
    }];
    
    //第1种
    //执行execute就会执行
    [[command execute:@1] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    //第2种
    //订阅信号
    //注意:订阅信号要在execute之前
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            
        }];
    }];
    
    //第3种
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
    }];
    
    //注意:一定要执行sendCompleted,否则不会执行完成
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isEx = [x boolValue];
        if (isEx) {
            NSLog(@"正在执行");
        } else {
            NSLog(@"执行完成");
        }
    }];
    
    [command execute:@1];
}

- (void)test23 {
    UIButton *btn = [[UIButton alloc] init];
    
    //第1种
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"1"];
            return nil;
        }];
    }];
    
    //第2种
    RACSubject *subject = [RACSubject subject];
    btn.rac_command = [[RACCommand alloc] initWithEnabled:subject signalBlock:^RACSignal *_Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"1"];
            return nil;
        }];
    }];
    
    [[btn.rac_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isEx = [x boolValue];
        [subject sendNext:@(!isEx)];
    }];
    
    //监听
    [btn.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
    }];
}

#pragma mark - 高级方法

//绑定(bind),映射(flattenMap,Map)
- (void)testWithBind {
    //1.bind
    [[self.textField_num.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value, BOOL *stop){
            return [RACSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //2.flattenMap
    [[self.textField_num.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [RACSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //3.map
    [[self.textField_num.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"输出:%@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

//组合(concat),必须前面的信号发送完成了，后面信号才能收到
- (void)testWithConcat {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        
#warning 注意:如果不调用sendCompleted，B信号就收不到
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}

// merge:把多个信号合并成一个信号
- (void)testWithMerge {
    // merge:把多个信号合并成一个信号
    // 创建多个信号
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
// 注意使用then，之前信号的值会被忽略掉.
- (void)testWithThen {
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
#warning 注意:如果不调用sendCompleted，就收不到信号
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
    }];
}

//zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件
- (void)testWithZip {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        RACTupleUnpack(NSNumber *num, NSNumber *num2, NSNumber *num3) = x;
        NSLog(@"%@ %@ %@",num,num2,num3);
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
}

//combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号
- (void)testCombineLatestWith {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@3];
        });
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@4];
        });
        
        return nil;
    }];
    
    // 把两个信号组合成一个信号,第一次必须组合的信号都有值，之后其中某个信号有新值，都会再触发事件
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    
    [combineSignal subscribeNext:^(RACTuple *x) {
        NSLog(@"%@ count = %ld", x, x.count);
    }];
    
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
}

//聚合
- (void)testWithReduce {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA, signalB] reduce:^id _Nullable(NSNumber *num1 ,NSNumber *num2){
        return [NSString stringWithFormat:@"%@ %@",num1,num2];
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值
}

@end




