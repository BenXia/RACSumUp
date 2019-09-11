//
//  NSObject-model.swift
//  LyRacDemo
//
//  Created by 张杰 on 2017/3/29.
//  Copyright © 2017年 张杰. All rights reserved.
//

import UIKit

@objc protocol BaseModelDelegate : NSObjectProtocol {
    //非必须实现的协议
    
    /* 字典数组 dictArray
     String:后台返回的key
     Any   :需要转换成那个class
     例子 ： return ["room" : "Room"]
     */
    @objc optional func arrayContainModelClass() -> ([String : Any])
    
    /* 2.字典dict
     String:后台返回的key
     Any   :需要转换成那个class
     例子 ： return ["student" : "Student" as Any]
     */
    @objc optional func dictContainModelClass() -> ([String : Any])
}

extension NSObject {
//    class func modelWithDict(dict : [String : Any]) -> NSObject {
//        
//        let objc = self.init()
//        //获得映射关系
//        let attributDic = attributesDic(dic: dict)
//        
//        //Runtime获取本类属性
//        var count : UInt32 = 0
//        let ivars = class_copyIvarList(objc.classForCoder, &count)
//        
//        for i in 0..<count {
//            
//            //1.取出属性名
//            let ivar = ivars?[Int(i)]
//            
//            var ivarName = ""
//            
//            if let constIVar = ivar {
//                ivarName = ivar_getName(constIVar as! String)
//            }
//            
//            //2.属性名称
//            let name = String(cString: ivarName)
//            
//            //属性类型,不知道为什么swift中获取不到属性的类型，全为""
////            var type = String(cString: ivar_getTypeEncoding(ivar)!)
//            
//            //3.取出要赋值的值
//            var key = attributDic[name]
//            if key == nil {
//                key = ""
//            }
//            //值
//            var value = dict[key!]
//            
//            //4.如果值是字典(二级转换)
//            if ((value as? [String : Any]) != nil) {
//                // @"@\"User\"" User
////                var rang = (type as NSString).range(of: "\"")
////                type = (type as NSString).substring(from: rang.location + rang.length)
////                rang = (type as NSString).range(of: "\"")
////                type = (type as NSString).substring(to: rang.location)
//                
//                let obj = objc as? BaseModelDelegate
//                let dictClass = obj?.dictContainModelClass!()[key!]
//                let modelClass = NSClassFromString("LyRacDemo.\(dictClass as! String)") as? NSObject.Type
//                if modelClass != nil {
//                    value = modelClass?.modelWithDict(dict: value! as! [String : Any])
//                }
//            }
//            
//            //5.数组，（三级转换）
//            if ((value as? [NSObject]) != nil) {
//                //                let idSelf = self
//                let obj = objc as? BaseModelDelegate
//                let arrayClass = obj?.arrayContainModelClass!()[key!]
//                let modelClass = NSClassFromString("LyRacDemo.\(arrayClass as! String)") as? NSObject.Type
//                
//                var array = [NSObject]()
//                for dic in value as! [[String : Any]] {
//                    let model = modelClass?.modelWithDict(dict: dic)
//                    array.append(model!)
//                }
//                value = array as Any?
//            }
//            
//            
//            if value != nil {
//                objc.setValue(value!, forKey: key!)
//            }
//        }
//        return objc
//    }
    
    //如果属性名与数据字典的key值不对应，那么在子类model中复写此方法，将属性名作为key，字典key值作为value
    class func attributesDic(dic : [String : Any]) -> [String : String] {
        var newDic:[String:String] = [:]
        for key in dic.keys {
            //复写时注意将属性名作为key 数据字典的key作为value
            newDic[key] = key
        }
        return newDic
    }
}


