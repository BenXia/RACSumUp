//
//  Person.swift
//  LyRacDemo
//
//  Created by 张杰 on 2017/3/29.
//  Copyright © 2017年 张杰. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    //1.要设置为可选类型，要不就设置初始值
    var name : String?
    var age  : Int = 0
    var student : Student?
    var room : [Room]?
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}

extension Person : BaseModelDelegate {
    func dictContainModelClass() -> ([String : Any]) {
        return ["student" : "Student" as Any]
    }

    
    func arrayContainModelClass() -> ([String : Any]) {
        return ["room" : "Room"]
    }
}
