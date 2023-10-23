//
//  UIControl+HSafeUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

//import UIKit
//
//private var kDefaultInterval = 0.5  //默认时间间隔
//private var isIgnoreEventKey = "isIgnoreEventKey"
//private var timeIntervalKey = "timeIntervalKey"
//
//extension UIControl {
//
//    private var isIgnoreEvent: Bool {
//        get { return self.getAssociatedValueForKey(&isIgnoreEventKey) as? Bool ?? false }
//        set { self.setAssociateWeakValue(newValue, key: &isIgnoreEventKey) }
//    }
//
//    var timeInterval: TimeInterval {
//        get { return self.getAssociatedValueForKey(&timeIntervalKey) as? TimeInterval ?? 0 }
//        set { self.setAssociateWeakValue(newValue, key: &timeIntervalKey) }
//    }
//
//    @objc
//    static func swizzle() {
//        methodSwizzleWithOrigSEL(#selector(sendAction(_:to:for:)), #selector(safe_sendAction(_:to:for:)))
//    }
//
//    @objc
//    private func safe_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
//
//        timeInterval = timeInterval == 0 ? kDefaultInterval : timeInterval
//
//        if isIgnoreEvent { return }
//        else if timeInterval > 0 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
//                self?.resetState()
//            }
//        }
//
//        isIgnoreEvent = true
//        safe_sendAction(action, to: target, for: event)
//
//    }
//
//    @objc
//    private func resetState() {
//        isIgnoreEvent = false
//    }
//
//}
