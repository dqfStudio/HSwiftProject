//
//  NSObject+HExclusive.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var kIdSetKey = "kIdSetKey"
private var kExclusiveSetKey = "kExclusiveSetKey"

typealias HExclusive = () -> Void

extension NSObject {
    
    private var exclusiveSet: NSMutableSet? {
        get {
            var set: NSMutableSet? = objc_getAssociatedObject(self, &kExclusiveSetKey) as? NSMutableSet
            if set == nil {
                set = NSMutableSet()
                objc_setAssociatedObject(self, &kExclusiveSetKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return set
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kExclusiveSetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func exclusive(exc: String, delay interval: TimeInterval, exclusive: HExclusive) {
        let excString: String = String(format: "%p%@", self, exc)
        if (self.exclusiveSet!.contains(excString) == false) {
            self.exclusiveSet!.add(excString)
            if interval > 0 {
                let deadline = DispatchTime.now() + interval
                DispatchQueue.global().asyncAfter(deadline: deadline) {
                    if (self.exclusiveSet!.contains(excString) == true) {
                        self.exclusiveSet!.remove(excString)
                    }
                }
            }
            exclusive()
        }
    }
    
    func removeExclusive(_ exc: String) {
        let excString: String = String(format: "%p%@", self, exc)
        if (self.exclusiveSet!.contains(excString) == true) {
            self.exclusiveSet!.remove(excString)
        }
    }

}

private var KSegStateKey = "_seg_"
private var segStatueKey = "segStatueKey"
private var segTotalStatueKey = "segTotalStatueKey"
private var segStatueDictKey = "segStatueDictKey"

extension NSObject {
    
    var segStatue: Int {
        get { return self.getAssociatedValueForKey(&segStatueKey) as! Int }
        set (newValue) { self.setAssociateWeakValue(newValue, key: &segStatueKey) }
    }
    
    var segTotalStatue: Int {
        get { return self.getAssociatedValueForKey(&segTotalStatueKey) as! Int }
        set (newValue) { self.setAssociateWeakValue(newValue, key: &segTotalStatueKey) }
    }
    
    private var segStatueDict: NSMutableDictionary {
        get {
            var set: NSMutableDictionary? = self.getAssociatedValueForKey(&segStatueDictKey) as? NSMutableDictionary
            if set == nil {
                set = NSMutableDictionary()
                self.setAssociateValue(set, key: &segStatueDictKey)
            }
            return set!
        }
        set (newValue) {
            self.setAssociateValue(newValue, key: &segStatueDictKey)
        }
    }
    
    func setObject(_ anObject: AnyObject, forKey aKey: String, segStatue statue: Int) {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)" as NSCopying
        self.segStatueDict.setObject(anObject, forKey: key)
    }
    
    func objectForKey(_ aKey: String, segStatue statue: Int) -> AnyObject {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)" as NSCopying
        return self.segStatueDict.object(forKey: key) as AnyObject
    }
    
    func removeObjectForKey(_ aKey: String, segStatue statue: Int) {
        let key = "\(aKey)+\(KSegStateKey)+\(statue)"
        self.segStatueDict.removeObject(forKey: key)
    }
    
    func removeObjectForSegStatue(_ statue: Int) {
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
    
    private var idSet: NSMutableSet {
        get {
            var set: NSMutableSet? = objc_getAssociatedObject(self, &kIdSetKey) as? NSMutableSet
            if set == nil {
                set = NSMutableSet()
                objc_setAssociatedObject(self, &kIdSetKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return set!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIdSetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func containsId(_ anId: String) -> Bool {
        return self.idSet.contains(anId)
    }
    
    func addId(_ anId: String) {
        if self.idSet.contains(anId) == false {
            self.idSet.add(anId)
        }
    }
    
    func removeId(_ anId: String) {
        if self.idSet.contains(anId) == true {
            self.idSet.remove(anId)
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
