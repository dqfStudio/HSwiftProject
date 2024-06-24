//
//  HModelManager.swift
//  HSwiftProject
//
//  Created by owner on 2024/6/22.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation

class HModelManager: NSObject {
    private var hashObjects = NSHashTable<NSObject>.weakObjects()

    func addObserver(_ anObserver: NSObject?) {
        if let anObserver = anObserver, !self.hashObjects.contains(anObserver) {
            self.hashObjects.add(anObserver)
        }
    }
    func perform(key: String) {
        let selector = NSSelectorFromString(key)
        let objects = self.hashObjects.allObjects.reversed()
        objects.forEach {
            if $0.responds(to: selector) {
                $0.perform(selector)
            }
        }
    }
}
