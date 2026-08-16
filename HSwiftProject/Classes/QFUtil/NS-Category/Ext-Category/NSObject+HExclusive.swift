//
//  NSObject+HExclusive.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var kExclusiveSetKey: Void?

extension NSObject {
    
    private var exclusiveSet: NSMutableSet {
        get {
            if let set = objc_getAssociatedObject(self, &kExclusiveSetKey) as? NSMutableSet {
                return set
            }
            let set = NSMutableSet()
            objc_setAssociatedObject(self, &kExclusiveSetKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return set
        }
        set {
            objc_setAssociatedObject(self, &kExclusiveSetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func exclusive(exc: String, block: () -> Void) {
        let excString = String(format: "%p%@", self, exc)
        objc_sync_enter(exclusiveSet)
        let canRun = !exclusiveSet.contains(excString)
        if canRun {
            exclusiveSet.add(excString)
        }
        objc_sync_exit(exclusiveSet)
        if canRun {
            block()
        }
    }
    
    func exclusive(exc: String, block: () -> Void, elseBlock: () -> Void) {
        let excString = String(format: "%p%@", self, exc)
        objc_sync_enter(exclusiveSet)
        let canRun = !exclusiveSet.contains(excString)
        if canRun {
            exclusiveSet.add(excString)
        }
        objc_sync_exit(exclusiveSet)
        if canRun {
            block()
        } else {
            elseBlock()
        }
    }
    
    func exclusive(exc: String, delay interval: TimeInterval, block: () -> Void) {
        let excString = String(format: "%p%@", self, exc)
        objc_sync_enter(exclusiveSet)
        let canRun = !exclusiveSet.contains(excString)
        if canRun {
            exclusiveSet.add(excString)
        }
        objc_sync_exit(exclusiveSet)
        guard canRun else { return }
        block()
        guard interval > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.removeExclusive(exc: exc)
        }
    }
    
    func removeExclusive(exc: String) {
        let excString = String(format: "%p%@", self, exc)
        objc_sync_enter(exclusiveSet)
        exclusiveSet.remove(excString)
        objc_sync_exit(exclusiveSet)
    }

}

extension UIView {
    
    func exclusiveOtherTouch() {
        self.isExclusiveTouch = true
    }
    
    static func exclusiveOtherTouch() {
        UIView.appearance().isExclusiveTouch = true
    }
    
}
