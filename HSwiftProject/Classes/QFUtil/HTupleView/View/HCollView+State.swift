//
//  HCollView+State.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

private var Coll_State_Key = "_coll_"

/// Design data storage category for split
extension HCollView {

    private var collStateSource: NSMutableDictionary {
        get {
            if let dict = self.getAssociatedValueForKey(&kCollStateSourceKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &kCollStateSourceKey)
                return dict
            }
        }
    }

    /// The state represented by the collView split design
    var collState: Int {
        get {
            let value = self.getAssociatedValueForKey(&kCollStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.collState {
                self.setAssociateValue(NSNumber(value: newValue), key: &kCollStateKey)
                self.reloadData()
            }
        }
    }

    /// Add a value to a certain state
    func setObject(_ anObject: Any, forKey aKey: String, state: Int) {
        let key = aKey + Coll_State_Key + "\(state)"
        self.collStateSource.setObject(anObject, forKey: key as NSCopying)
    }

    /// Get a value of a certain state
    func object(forKey aKey: String, state: Int) -> Any? {
        let key = aKey + Coll_State_Key + "\(state)"
        return self.collStateSource.object(forKey: key)
    }

    /// Remove a value in a certain state
    func removeObject(forKey aKey: String, state: Int) {
        let key = aKey + Coll_State_Key + "\(state)"
        self.collStateSource.removeObject(forKey: key)
    }

    /// Delete the value of a certain state
    func removeObject(forState state: Int) {
        let key = Coll_State_Key + "\(state)"
        for (aKey, _) in self.collStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.collStateSource.removeObject(forKey: aKey)
            }
        }
    }

    /// Remove all values ​​of the state
    func clearCollState() {
        self.collStateSource.removeAllObjects()
    }

}
