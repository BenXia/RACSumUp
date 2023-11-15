//
//  LyContentView.swift
//  LyRacDemo
//
//  Created by 张杰 on 2017/3/28.
//  Copyright © 2017年 张杰. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class LyContentView: UIView {
    let (signalTap, observerTap) = Signal<Any, Never>.pipe()
    
    typealias tapBlock = ()->()
    
    var taps : tapBlock = {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LyContentView {
    fileprivate func setUI() {
        backgroundColor = UIColor.yellow
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapClick(_:)))
        addGestureRecognizer(tap)
    }
    
    //使用RAC，替代delegate，闭包
    @objc fileprivate func tapClick(_ tap : UITapGestureRecognizer) {
        observerTap.send(value: tap)
        
        taps()
    }
}


