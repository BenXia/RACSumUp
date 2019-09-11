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
        
        setUi()
        addRac()
        
//        let dict = ["name" : "kk" , "age" : 10 , "student" : ["friend" : "zk" , "cat" : 7] , "room" : [["size" : 8 , "bag" : "hello"] , ["size" : 6 , "bag" : "ko"]]] as [String : Any]
//
//        let p = Person.modelWithDict(dict : dict as [String : AnyObject]) as? Person
//        
//        print(p?.name)
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
    
    fileprivate func setUi() {
        
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
    
    //RAC的使用
    fileprivate func addRac() {
        
        //账号输入框的信号
        let signalA = textFieldNum.reactive.continuousTextValues.map { (text) -> Int in
            return text.count
        }
        
        let signalB = textFieldSec.reactive.continuousTextValues.map { (text) -> Int in
            return text.count
        }
        
        //多个信号处理btn的是否可以点击属性
        btn.reactive.isEnabled <~ Signal.combineLatest(signalA, signalB).map({ (a : Int , b : Int) -> Bool in
            return a > 1 && b > 6
        })
        
        //按钮的点击
        btn.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { (btn) in
            print("登录")
        }
        
        contentView.signalTap.observeValues { (value) in
            print("点击了view")
        }
        
//        //使用闭包回调
//        contentView.taps = {
//            
//        }
    }
    
}

//MARK: RAC其他用法
extension SwiftUsageVC {
    
    fileprivate func test() {
        
        //1.kvo
        btn.reactive.values(forKeyPath: "isEnabled").start({ value in
            print(value)
        })
        
        //2.通知
        NotificationCenter.default.reactive.notifications(forName: Notification.Name("reloadData"), object: nil).observeValues { (value) in
            
        }
        
        //3.textField
        textFieldNum.reactive.continuousTextValues.observeValues { (text) in
            
        }
        
        //4.按钮点击
        btn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
        }
        
        //5.延时加载
        QueueScheduler.main.schedule(after: Date(timeIntervalSinceNow: 1.0), action: {
            
        })
        
        //6.filter作用:过滤   当text>5才会输出
        textFieldNum.reactive.continuousTextValues.filter { (text) -> Bool in
            return text.count > 5
        }.observeValues { (value) in
            
        }
        
        //7.map
        textFieldNum.reactive.continuousTextValues.map { (text) -> UIColor in
            if text.count > 5 {
                return UIColor.blue
            } else {
                return UIColor.red
            }
        }.observeValues { (color) in
            
        }
        
        //8.多个信号结合使用,热信号
        let (signalA, observerA) = Signal<String, Never>.pipe()
        let (signalB, observerB) = Signal<String, Never>.pipe()
        Signal.combineLatest(signalA, signalB).observeValues { (value) in
            print( "收到的值\(value.0) + \(value.1)")
        }
        observerA.send(value: "1")
        //注意:如果加这个就是，发了一次信号就不能再发了
        observerA.sendCompleted()
        observerB.send(value: "2")
        observerB.sendCompleted()
    }
    
}

extension SwiftUsageVC {
    
    //1.将颜色 -> 图片
    class func creatImageWithColor(color:UIColor) -> UIImage{
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

