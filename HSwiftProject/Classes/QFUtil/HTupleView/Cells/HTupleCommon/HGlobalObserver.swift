//
//  HGlobalObserver.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/5.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

/// 定义观察者协议
@objc protocol HGlobalObserverProtocol: NSObjectProtocol {
    @objc
    optional func refreshColl()
    
    @objc
    optional func releaseColl()
}

/// 定义观察者
class HGlobalObserver: NSObject {

    static let share = HGlobalObserver()
    private var hashObjects = NSHashTable<HGlobalObserverProtocol>.weakObjects()

    func addObserver(_ anObserver: HGlobalObserverProtocol?) {
        if let anObserver = anObserver, !self.hashObjects.contains(anObserver) {
            self.hashObjects.add(anObserver)
        }
    }
    
    func perform(key: String, with object1: String? = nil, with object2: String? = nil, _ completion: @escaping () -> Void) {
        Task {
            let selector = NSSelectorFromString(key)
            let objects = self.hashObjects.allObjects.reversed()
            for object in objects {
                if object.responds(to: selector) {
                    await MainActor.run {
                        switch (object1, object2) {
                        case let (objc1?, objc2?):
                            _ = object.perform(selector, with: objc1, with: objc2)
                        case let (objc1?, nil):
                            _ = object.perform(selector, with: objc1)
                        case let (nil, objc2?):
                            _ = object.perform(selector, with: objc2)
                        case (nil, nil):
                            _ = object.perform(selector)
                        }
                    }
                }
            }
            await MainActor.run {
                completion()
            }
        }
    }
}
