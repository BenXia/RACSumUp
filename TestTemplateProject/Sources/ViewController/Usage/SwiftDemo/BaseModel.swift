//
//  BaseModel.swift
//  LyRacDemo
//
//  Created by 张杰 on 2017/3/29.
//  Copyright © 2017年 张杰. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

//    class func modelWithDict(dict : [String : AnyObject]) -> AnyObject {
//
////        let objc = self
//        //获得映射关系
//        let attributDic = attributesDic(dic: dict)
//        
//        //Runtime获取本类属性
//        var count : UInt32 = 0
//        let ivars = class_copyIvarList(self.classForCoder(), &count)
//        
//        for i in 0..<count {
//            
//            //1.取出属性名
//            let ivar = ivars?[Int(i)]
//            let ivarName = ivar_getName(ivar)
//            
//            //2.属性名称
//            let name = String(cString: ivarName!)
//            
//            //属性类型
//            var type = String(cString: ivar_getTypeEncoding(ivar))
//            
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
//            if ((value as? [String : AnyObject]) != nil) {
//                // @"@\"User\"" User
//                var rang = (type as NSString).range(of: "\"")
//                type = (type as NSString).substring(from: rang.location + rang.length)
//                rang = (type as NSString).range(of: "\"")
//                type = (type as NSString).substring(to: rang.location)
//                
//                let modelClass = NSClassFromString(type)
//                if modelClass != nil {
//                    value = modelClass?.modelWithDict(dict: value! as! [String : AnyObject])
//                }
//            }
//            
//            //5.数组，（三级转换）
//            if ((value as? [NSObject]) != nil) {
////                let idSelf = self
//                let obj = self as? BaseModelDelegate
//                let arrayClass = obj?.arrayContainModelClass()[value as! String]
//                let modelClass = NSClassFromString(arrayClass as! String)
//                
//                var array = [NSObject]()
//                for dic in value as! [[String : AnyObject]] {
//                    let model = modelClass?.modelWithDict(dict: dic)
//                    array.append(model! as! NSObject)
//                }
//                value = array as AnyObject?
//            }
//            
//            
//            if value != nil {
//                setValue(value!, forKey: key!)
//            }
//        }
//        return self
//    }
//    
//    override func setValue(_ value: Any?, forKey key: String) {
//        super.setValue(value, forKey: key)
//    }
//    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        
//    }
//    
////    @objc func arrayContainModelClass() -> ([String : AnyObject])
//    
//    //如果属性名与数据字典的key值不对应，那么在子类model中复写此方法，将属性名作为key，字典key值作为value
//    class func attributesDic(dic : [String : Any]) -> [String : String] {
//        var newDic:[String:String] = [:]
//        for key in dic.keys {
//            //复写时注意将属性名作为key 数据字典的key作为value
//            newDic[key] = key
//        }
//        return newDic
//    }
    
}
