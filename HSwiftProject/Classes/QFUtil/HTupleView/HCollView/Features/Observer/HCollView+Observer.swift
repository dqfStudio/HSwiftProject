//
//  HCollView+Observer.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//
//  弱引用登记多个 HCollView，按 reloadCollKey / releaseCollKey 批量刷新或释放。
//

import Foundation

enum HCollObserverAction {
    case reloadData
    case custom(action: (HCollView) -> Void)
}

/// 弱引用表管理多个 HCollView，可按 `reloadCollKey` / `releaseCollKey` 批量操作。后添加的先执行。
@MainActor
class HCollObserver {

    private static let hashColls = NSHashTable<HCollView>.weakObjects()

    static func addObserver(_ observer: HCollView?) {
        guard let observer = observer, !hashColls.contains(observer) else { return }
        hashColls.add(observer)
    }

    static func removeObserver(_ observer: HCollView?) {
        guard let observer = observer else { return }
        hashColls.remove(observer)
    }

    static func perform(action: HCollObserverAction) {
        let objects = hashColls.allObjects.reversed()
        objects.forEach { coll in
            executeAction(action, on: coll)
        }
    }

    static func perform(where predicate: @escaping (HCollView) -> Bool, action: HCollObserverAction) {
        let objects = hashColls.allObjects.filter(predicate).reversed()
        objects.forEach { coll in
            executeAction(action, on: coll)
        }
    }

    static func refreshAll(completion: @escaping () -> Void) {
        let colls = hashColls.allObjects.reversed()
        colls.forEach { $0.reloadCollData() }
        completion()
    }

    static func refreshByKey(key: String, completion: @escaping () -> Void) {
        perform(where: { $0.reloadCollKey == key }, action: .reloadData)
        completion()
    }

    static func releaseByKey(key: String, completion: @escaping () -> Void) {
        let colls = hashColls.allObjects.filter { $0.releaseCollKey == key }.reversed()
        colls.forEach { $0.invokeFeature(HCollFeatureSelector.memoryRelease) }
        completion()
    }

    private static func executeAction(_ action: HCollObserverAction, on coll: HCollView) {
        switch action {
        case .reloadData:
            coll.reloadCollData()
        case .custom(let customAction):
            customAction(coll)
        }
    }
}

extension HCollView {
    /// Core `setup` 钩子，选择器名勿改。
    @objc func hcoll_observer_setup() {
        HCollObserver.addObserver(self)
    }

    /// Core `deinit` 钩子，选择器名勿改。
    @objc func hcoll_observer_deinit() {
        HCollObserver.removeObserver(self)
    }
}
