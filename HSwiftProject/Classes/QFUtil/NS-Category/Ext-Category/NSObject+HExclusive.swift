//
//  NSObject+HExclusive.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var kExclusiveSetKey = "kExclusiveSetKey"

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
        set(newValue) {
            objc_setAssociatedObject(self, &kExclusiveSetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func exclusive(exc: String, block: () -> Void) {
        let excString: String = String(format: "%p%@", self, exc)
        if !self.exclusiveSet.contains(excString) {
            self.exclusiveSet.add(excString)
            block()
        }
    }
    
    func exclusive(exc: String, delay interval: TimeInterval, block: () -> Void) {
        let excString: String = String(format: "%p%@", self, exc)
        if !self.exclusiveSet.contains(excString) {
            self.exclusiveSet.add(excString)
            if interval > 0 {
                DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
                    if self.exclusiveSet.contains(excString) {
                        self.exclusiveSet.remove(excString)
                    }
                }
            }
            block()
        }
    }
    
    func removeExclusive(exc: String) {
        let excString: String = String(format: "%p%@", self, exc)
        if self.exclusiveSet.contains(excString) {
            self.exclusiveSet.remove(excString)
        }
    }

}

private var KSegStateKey = "_seg_"
private var segStatueKey = "segStatueKey"
private var segTotalStatueKey = "segTotalStatueKey"
private var segStatueDictKey = "segStatueDictKey"

extension NSObject {
    
    var segStatue: Int {
        get { return objc_getAssociatedObject(self, &segStatueKey) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &segStatueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var segTotalStatue: Int {
        get { return objc_getAssociatedObject(self, &segTotalStatueKey) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &segTotalStatueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var segStatueDict: NSMutableDictionary {
        get {
            if let dict = objc_getAssociatedObject(self, &segStatueDictKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                objc_setAssociatedObject(self, &segStatueDictKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dict
            }
        }
        set { objc_setAssociatedObject(self, &segStatueDictKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setObject(_ anObject: AnyObject, forKey aKey: String, segStatue statue: Int) {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)" as NSCopying
        self.segStatueDict.setObject(anObject, forKey: key)
    }
    
    func object(forKey aKey: String, segStatue statue: Int) -> AnyObject {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)" as NSCopying
        return self.segStatueDict.object(forKey: key) as AnyObject
    }
    
    func removeObject(forKey aKey: String, segStatue statue: Int) {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)"
        self.segStatueDict.removeObject(forKey: key)
    }
    
    func removeObject(forSegStatue statue: Int) {
        let key = "\(KSegStateKey)+\(statue)"
        self.segStatueDict.removeObject(forKey: key)
    }
    
    func clearSegStatue() {
        self.segStatue = 0
        if self.segStatueDict.count > 0 {
            self.segStatueDict.removeAllObjects()
        }
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
