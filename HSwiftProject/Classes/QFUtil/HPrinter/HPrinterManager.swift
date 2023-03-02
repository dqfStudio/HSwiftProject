//
//  HPrinterManager.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/15.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

#if DEBUG

private var KPrinterManagerKey = "KPrinterManagerKey"

class HPrinterManager: NSObject {
    
    var printerDict: NSMutableDictionary? {
        get {
            var dict: NSMutableDictionary? = objc_getAssociatedObject(self, &KPrinterManagerKey) as? NSMutableDictionary
            if dict == nil {
                dict = NSMutableDictionary()
                objc_setAssociatedObject(self, &KPrinterManagerKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return dict
        }
        set(newValue) {
            objc_setAssociatedObject(self, &KPrinterManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static let share: HPrinterManager = {
        let instance = HPrinterManager()
        return instance
    }()
    
    func setObject(_ anObject: Any, forKey aKey: NSCopying) {
        self.printerDict!.setObject(anObject, forKey: aKey)
    }
    
    func containsObject(_ anObject: String) -> Bool {
        self.printerDict!.allKeys.contains(where: { (object) -> Bool in
            let objectStr: String = object as! String
            if anObject == objectStr {
                return true
            }
            return false
        })
    }
    
    func objectForKey(_ aKey: String) -> String? {
        if self .containsObject(aKey) {
            self.printerDict!.object(forKey: aKey)
        }
        return nil
    }
    
}

#endif
