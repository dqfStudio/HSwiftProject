//
//  UIControl+HSafeUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift

private let KDefaultInterval = 0.5  //默认时间间隔

extension UIControl {
    
    private var isIgnoreEvent: Bool {
        get { return self.getAssociatedValueForKey(#function) as! Bool }
        set { self.setAssociateWeakValue(newValue, key: #function) }
    }
    
    var timeInterval: TimeInterval {
        get { return self.getAssociatedValueForKey(#function) as! TimeInterval }
        set { self.setAssociateWeakValue(newValue, key: #function) }
    }
    
    @objc override class func swizzle() -> Void {
        Swizzle(UIControl.self) {
            #selector(sendAction(_:to:for:)) <-> #selector(safe_sendAction(_:to:for:))
        }
    }
    
    @objc private func safe_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        self.timeInterval = self.timeInterval == 0 ? KDefaultInterval : self.timeInterval
        
        if self.isIgnoreEvent {
            return
        }else if self.timeInterval > 0 {
            self.perform(#selector(resetState), with: nil, afterDelay: self.timeInterval)
        }
        
        self.isIgnoreEvent = true
        self.safe_sendAction(action, to: target, for: event)
    }
    
    @objc private func resetState() -> Void {
        self.isIgnoreEvent = false
    }

}
