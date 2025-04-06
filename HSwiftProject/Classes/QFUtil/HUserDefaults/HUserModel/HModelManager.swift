//
//  HModelManager.swift
//  HSwiftProject
//
//  Created by owner on 2024/6/22.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation

class HModelManager: NSObject {
    private var observers = NSHashTable<NSObject>.weakObjects()

    func addObserver(_ observer: NSObject) {
        guard !observers.contains(observer) else { return }
        observers.add(observer)
    }
    func perform(key: String, completion: @escaping () -> Void) {
        Task {
            let selector = NSSelectorFromString(key)
            for observer in observers.allObjects.reversed() where observer.responds(to: selector) {
                await MainActor.run {
                    _ = observer.perform(selector)
                }
            }
            await MainActor.run { completion() }
        }
    }
}
