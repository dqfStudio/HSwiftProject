//
//  NSDictionary+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 17/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import Foundation

extension NSDictionary {

    func containsObject(_ anObject: String) -> Bool {
        self.allKeys.contains(where: { (object) -> Bool in
            let objectStr: String = object as! String
            if anObject == objectStr {
                return true
            }
            return false
        })
    }
    
    func objectForKey(_ aKey: String) -> String? {
        if self.containsObject(aKey) {
            self.object(forKey: aKey)
        }
        return nil
    }
    
}
