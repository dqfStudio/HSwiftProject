//
//  HCollView+Observer.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollObserver: NSObject {
    static let shared = HCollObserver()
    private var observers = NSHashTable<HCollView>.weakObjects()
    
    private override init() { }

    func addObserver(_ observer: HCollView) {
        guard !observers.contains(observer) else { return }
        observers.add(observer)
    }
    
    func removeObserver(_ observer: HCollView) {
        guard observers.contains(observer) else { return }
        observers.remove(observer)
    }
    
    func notifyObservers(_ completion: @escaping () -> Void) {
        Task {
            for observer in observers.allObjects.reversed() {
                await MainActor.run {
                    observer.reloadData()
                }
            }
            await MainActor.run {
                completion()
            }
        }
    }
}
