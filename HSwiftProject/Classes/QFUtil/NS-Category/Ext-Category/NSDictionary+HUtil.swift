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
        allKeys.contains { ($0 as? String) == anObject }
    }

    func objectForKey(_ aKey: String) -> String? {
        object(forKey: aKey) as? String
    }

}
