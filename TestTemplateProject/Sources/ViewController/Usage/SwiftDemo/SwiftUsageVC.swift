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
        QueueScheduler.main.schedule(after: Date(timeIntervalSinceNow: 1.0), action: {

        })
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


