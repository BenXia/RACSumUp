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
//        accountTextField.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { (button) in
//            print("button clicked")
//        }
        
//        accountTextField.reactive.controlEvents(UIControl.Event.touchUpInside).observeResult({ (result) in
//            switch result {
//            case .success(_):
//                print("button clicked")
//            case .failure:
//                print("Error")
//            }
//        })
        
        // 5. 组合信号
        let accountSignal = accountTextField.reactive.continuousTextValues.filter { (text) -> Bool in
            return text.count > 3
        }
        let passwordSignal = passwordTextField.reactive.continuousTextValues.filter { (text) -> Bool in
            return text.count > 3
        }
        loginBtn.reactive.isEnabled <~ accountSignal.combineLatest(with: passwordSignal).map({ $0 && $1 })
        //loginBtn.reactive.isEnabled <~ accountSignal.combineLatest(passwordSignal).map({ (accountValid, pwdValid) -> Bool in
        //    return accountValid && pwdValid
        //})
        
        
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
    }
}


