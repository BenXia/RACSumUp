//
//  SwiftUsageVC.swift
//  TestTemplateProject
//
//  Created by Ben on 2019/9/9.
//  Copyright © 2019 iOSStudio. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

fileprivate let edgeW = 10

@objc(SwiftUsageVC) class SwiftUsageVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIRelated()
        
        compareColdAndHotSignal()
    }
    
    fileprivate lazy var textFieldNum : UITextField = {
        let textField = UITextField()
        textField.placeholder = "账号"
        textField.returnKeyType = .next
        textField.clearButtonMode = .always
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        return textField
    }()

    fileprivate lazy var textFieldSec : UITextField = {
        let textField = UITextField()
        textField.placeholder = "密码"
        textField.returnKeyType = .done
        textField.clearButtonMode = .always
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        return textField
    }()

    fileprivate lazy var btn : UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setBackgroundImage(SwiftUsageVC.creatImageWithColor(color: UIColor.green), for: .normal)
        btn.setBackgroundImage(SwiftUsageVC.creatImageWithColor(color: UIColor.lightGray), for: .disabled)
        btn.isEnabled = false
        return btn
    }()
    
    fileprivate lazy var contentView : LyContentView = {
        let contentView = LyContentView()
        return contentView
    }()
}

extension SwiftUsageVC {
    fileprivate func initUIRelated() {
        view.addSubview(textFieldNum)
        view.addSubview(textFieldSec)
        view.addSubview(btn)
        view.addSubview(contentView)
        
        textFieldNum.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(edgeW)
            make.right.equalTo(view).offset(-edgeW)
            make.top.equalTo(view).offset(100)
            make.height.equalTo(30)
        }
        
        textFieldSec.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(edgeW)
            make.right.equalTo(view).offset(-edgeW)
            make.top.equalTo(textFieldNum.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(edgeW)
            make.right.equalTo(view).offset(-edgeW)
            make.top.equalTo(textFieldSec.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.bottom.equalTo(view).offset(-50)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
    }
}

//MARK: RAC其他用法
extension SwiftUsageVC {
    func bindViewModel() {
        // 1. 最简单的订阅
//        textFieldNum.reactive.continuousTextValues.observeResult { (result) in
//            switch result {
//            case .success(let object):
//                print("\(object as String)")
//            case .failure:
//                print("Error")
//            }
//        }
        
        // 2. 信号处理
//        textFieldNum.reactive.continuousTextValues.map { (text) -> Int in
//             return text.count
//         }.observeResult { (result) in
//             switch result {
//                 case .success(let object):
//                     print("\(object as Int)")
//                 case .failure:
//                     print("Error")
//             }
//         }
        
        // 3. 信号过滤
//        textFieldNum.reactive.continuousTextValues.filter { (text) -> Bool in
//            return text.count > 3
//        }.observeResult { (result) in
//            switch result {
//            case .success(let object):
//                print("\(object as String)")
//            case .failure:
//                print("Error")
//            }
//        }
        
        // 4. UIButton 点击信号
//        btn.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { (button) in
//            print("button clicked")
//        }
        
        btn.reactive.controlEvents(UIControl.Event.touchUpInside).observeResult({ (result) in
            switch result {
            case .success(_):
                print("button clicked")
            case .failure:
                print("Error")
            }
        })
        
        // 5. 组合信号
        // 5.1 冷信号
        let signalA = textFieldNum.reactive.continuousTextValues.map { (text) -> Bool in
            return text.count > 3
        }
        
        let signalB = textFieldSec.reactive.continuousTextValues.map { (text) -> Bool in
            return text.count > 3
        }
        
        // 多个信号处理btn的是否可以点击属性
        btn.reactive.isEnabled <~ Signal.combineLatest(signalA, signalB).map({ (accountValid : Bool , pwdValid : Bool) -> Bool in
            return accountValid && pwdValid
        })
        
        // 5.2 热信号
        let (signalX, observerA) = Signal<String, Never>.pipe()
        let (signalY, observerB) = Signal<String, Never>.pipe()
        Signal.combineLatest(signalX, signalY).observeValues { (value) in
            print( "收到的值\(value.0) + \(value.1)")
        }
        observerA.send(value: "1")
        //注意:如果加这个就是，发了一次信号就不能再发了
        observerA.sendCompleted()
        observerB.send(value: "2")
        observerB.sendCompleted()
        
        
        // 6. KVO VS MutableProperty
        btn.reactive.producer(forKeyPath: "isEnabled").start({ value in
            print(value)
        })

        let racValue = MutableProperty<Int>(1)
        racValue.producer.startWithValues { (make) in
            print(make)
        }
        racValue.value = 10
        
        // 7.通知
        NotificationCenter.default.reactive.notifications(forName: Notification.Name("reloadData"), object: nil).observeValues { (value) in
            
        }
        
        // 8. 方法调用拦截
        self.reactive.trigger(for: #selector(UIViewController.viewWillAppear(_:))).observeValues { () in
            print("viewWillAppear 被调用了")
        }
        
        // 9. 监听对象的生命周期
//        loginBtn.reactive.controlEvents(.touchUpInside).observeValues{ [weak self] (btn) in
//            let usageVC = UsageVC()
//
//            usageVC.reactive.lifetime.ended.observeCompleted {
//                print("usageVC 被销毁")
//            }
//
//            self?.navigationController?.pushViewController(usageVC, animated: true)
//        }
        
        // 10. 回调的RAC实现
//        contentView.signalTap.observeValues { (value) in
//            print("点击了view")
//        }
//
////        //使用闭包回调
////        contentView.taps = {
////
////        }
        
        // 11. 创建自定义的信号
//        let signal = self.createSignInSignal()
//
//        signal.observeResult { (result) in
//            switch result {
//            case .success(let object):
//                print("\(object as Bool)")
//            case .failure:
//                print("Error")
//            }
//        }
        
        
        // 12.延时加载
        QueueScheduler.main.schedule(after: Date(timeIntervalSinceNow: 1.0)){
            print("主线程调用")
        }
        
        QueueScheduler.init().schedule(after: Date.init(timeIntervalSinceNow: 0.3)){
            print("子线程调用")
        }
        
        // 13. 迭代器
        // 数组的迭代器
        let array:[String] = ["name","name2"]
        var arrayIterator =  array.makeIterator()
        while let temp = arrayIterator.next() {
            print(temp)
        }

        // swift 系统自带的遍历
        array.forEach { (value) in
            print(value)
        }
        
        // 字典的迭代器
        let dict:[String: String] = ["key":"name", "key1":"name1"]
        var dictIterator =  dict.makeIterator()
        while let temp = dictIterator.next() {
            print(temp)
        }
        
        // swift 系统自带的遍历
        dict.forEach { (key, value) in
            print("\(key) + \(value)")
        }
    }
    
    private func createSignInSignal() -> Signal<Bool, Never> {
        let (signInSignal, observer) = Signal<Bool, Never>.pipe()
        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now()+0.5) {
            observer.send(value: true)
            observer.sendCompleted()
        }
        
//        self.signInService.signIn(withUsername: self.usernameTextField.text!, andPassword: self.passwordTextField.text!) {
//            success in
//
//            observer.send(value: success)
//            observer.sendCompleted()
//        }
        
        return signInSignal
    }
}

extension SwiftUsageVC {
    // 比较冷热信号
    // Swift中，SignalProducer 对应 RACSignal 为冷信号， Signal 对应的 RACSubject 为热信号。
    // 1.冷信号模式，是被动的，需要有人订阅才开启热信号，热信号是主动的,就算没有订阅者也会即刻推送;
    //   热信号可以有多个订阅者,一对多;冷信号只能一对一,当有新的订阅者,信号是重新完整发送的
    //   形象的说：热信号像是直播,冷信号像是点播
    // 2.冷信号个人用来进行网络请求，热信号进行类似代理或者通知的数据传递模式，
    //
    // 这样就可以简单的理解为，RAC其实就是把apple的一套 delegate，Notification，KVO等一系列方法综合起来了，用起来更舒服罢了。
    
    private func compareColdAndHotSignal() {
        // 1.1 冷信号
        let loadDataAction = Action.init(execute: getChatArray)
        loadDataAction.apply().start()
        
        // observer 监听
        loadDataAction.events.observe({ (event) in
            print(event)
        })
        
        // 1.2 冷信号
        let producer = SignalProducer<String, Never>.init { (observer, _) in
            print("新的订阅，启动操作")
            observer.send(value: "Hello")
            observer.send(value: "World")
        }
        
        let subscriber1 = Signal<String, Never>.Observer{ print("观察者1接收到值 \($0)") }
        let subscriber2 = Signal<String, Never>.Observer{ print("观察者2接收到值 \($0)") }
        print("观察者1订阅信号发生器")
        producer.start(subscriber1)
        print("观察者2订阅信号发生器")
        producer.start(subscriber2)
        //注意：发生器将再次启动工作
        
        
        // 2. 创建热信号
        let (signalA, observerA) = Signal<String, Never>.pipe()
        let (signalB, observerB) = Signal<String, Never>.pipe()
        
        // 联合信号
        Signal.combineLatest(signalA, signalB).observeValues { (value) in
            print( "收到的值\(value.0) + \(value.1)")
        }
        
        observerA.send(value: "1")
        //注意:如果加这个就是，发了一次信号就不能再发了
        observerA.sendCompleted()
        observerB.send(value: "2")
        observerB.sendCompleted()
        
        
        
        // 3. 创建空信号
        let emptySignal = Signal<Any, Never>.empty
        emptySignal.observe { (event) in
            
        }
        
    }
    
    func getChatArray() -> SignalProducer<Any, Never> {
        return SignalProducer<Any, Never>.init { (observer, _) in
//            self.request.GET(url: Host, paras: nil, success: { (request, response) in
//                if let response = response {
//                    self.dataArray = self.WebArray()
//
                    observer.send(value: "1")
                    
                    observer.sendCompleted()
//                }
//            }, failure: { (request, error) in
//                observer.sendCompleted()
//            })
        }
    }
}

extension SwiftUsageVC {
    //1.将颜色 -> 图片
    class func creatImageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


