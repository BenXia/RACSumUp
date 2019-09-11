//
//  CocoaUsageVC.swift
//  TestTemplateProject
//
//  Created by Ben on 2019/9/9.
//  Copyright © 2019 iOSStudio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class CocoaUsageVC: BaseViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
    }

    func bindViewModel() {
        // 1. 最简单的订阅
//        accountTextField.reactive.continuousTextValues.observeResult { (result) in
//            switch result {
//            case .success(let object):
//                print("\(object as String)")
//            case .failure:
//                print("Error")
//            }
//        }
        
        // 2. 信号处理
//        accountTextField.reactive.continuousTextValues.map { (text) -> Int in
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
//        accountTextField.reactive.continuousTextValues.filter { (text) -> Bool in
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
//        loginBtn.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { (button) in
//            print("button clicked")
//        }
        
        loginBtn.reactive.controlEvents(UIControl.Event.touchUpInside).observeResult({ (result) in
            switch result {
            case .success(_):
                print("button clicked")
            case .failure:
                print("Error")
            }
        })
        
        // 5. 组合信号
        let signalA = accountTextField.reactive.continuousTextValues.map { (text) -> Bool in
            return text.count > 3
        }
        
        let signalB = passwordTextField.reactive.continuousTextValues.map { (text) -> Bool in
            return text.count > 3
        }
        
        //多个信号处理btn的是否可以点击属性
        loginBtn.reactive.isEnabled <~ Signal.combineLatest(signalA, signalB).map({ (accountValid : Bool , pwdValid : Bool) -> Bool in
            return accountValid && pwdValid
        })
        
        
        // 6. KVO VS MutableProperty
//        let racValue = MutableProperty<Int>(1)
//        racValue.producer.startWithValues { (make) in
//            print(make)
//        }
//        racValue.value = 10
        
        
        // 7. 方法调用拦截
//        self.reactive.trigger(for: #selector(UIViewController.viewWillAppear(_:))).observeValues { () in
//            print("viewWillAppear 被调用了")
//        }
        
        // 8. 监听对象的生命周期
//        loginBtn.reactive.controlEvents(.touchUpInside).observeValues{ [weak self] (btn) in
//            let usageVC = UsageVC()
//
//            usageVC.reactive.lifetime.ended.observeCompleted {
//                print("usageVC 被销毁")
//            }
//
//            self?.navigationController?.pushViewController(usageVC, animated: true)
//        }
        
        // 9. 创建自定义的信号
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


