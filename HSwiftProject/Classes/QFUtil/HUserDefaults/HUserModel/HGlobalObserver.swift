//
//  HGlobalObserver.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/5.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

// 定义观察者协议
@objc protocol HGlobalObserverProtocol: NSObjectProtocol {
    @objc
    optional func refreshColl()
    @objc
    optional func releaseColl()
}

// 定义观察者枚举
enum HGlobalObserverType {
    case refreshColl
    case releaseColl

    var selector: Selector {
        switch self {
        case .refreshColl:
            return #selector(HGlobalObserverProtocol.refreshColl)
        case .releaseColl:
            return #selector(HGlobalObserverProtocol.releaseColl)
        }
    }
}

// 定义观察者
class HGlobalObserver {
    static let shared = HGlobalObserver()
    private var observers = NSHashTable<AnyObject>.weakObjects()

    func addObserver(_ observer: HGlobalObserverProtocol) {
        guard !observers.contains(observer as AnyObject) else { return }
        observers.add(observer as AnyObject)
    }

    private func callSelector(_ observer: AnyObject, selector: Selector, args: [Any]) {
        switch args.count {
        case 0: _ = observer.perform(selector)
        case 1: _ = observer.perform(selector, with: args[0])
        case 2: _ = observer.perform(selector, with: args[0], with: args[1])
        default: break
        }
    }

    func perform(_ observerType: HGlobalObserverType, with object1: Any? = nil, with object2: Any? = nil, completion: @escaping () -> Void) {
        Task {
            let selector = observerType.selector
            let args = [object1, object2].compactMap { $0 }
            for observer in observers.allObjects.reversed() where observer.responds(to: selector) {
                await MainActor.run {
                    callSelector(observer, selector: selector, args: args)
                }
            }
            await MainActor.run { completion() }
        }
    }
}
