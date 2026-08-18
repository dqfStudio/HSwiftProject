//
//  HFlowView+Observer.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//
//  弱引用登记多个 HFlowView，按 reloadFlowKey / releaseFlowKey 批量刷新或释放。
//

import Foundation

enum HFlowObserverAction {
    case reloadData
    case custom(action: (HFlowView) -> Void)
}

/// 弱引用表管理多个 HFlowView，可按 `reloadFlowKey` / `releaseFlowKey` 批量操作。后添加的先执行。
@MainActor
class HFlowObserver {

    private static let hashFlows = NSHashTable<HFlowView>.weakObjects()

    static func addObserver(_ observer: HFlowView?) {
        guard let observer, !hashFlows.contains(observer) else { return }
        hashFlows.add(observer)
    }

    static func removeObserver(_ observer: HFlowView?) {
        guard let observer else { return }
        hashFlows.remove(observer)
    }

    static func perform(action: HFlowObserverAction) {
        let objects = hashFlows.allObjects.reversed()
        objects.forEach { flow in
            executeAction(action, on: flow)
        }
    }

    static func perform(where predicate: @escaping (HFlowView) -> Bool, action: HFlowObserverAction) {
        let objects = hashFlows.allObjects.filter(predicate).reversed()
        objects.forEach { flow in
            executeAction(action, on: flow)
        }
    }

    static func refreshAll(completion: @escaping () -> Void) {
        let flows = hashFlows.allObjects.reversed()
        flows.forEach { $0.reloadFlowData() }
        completion()
    }

    static func refreshByKey(key: String, completion: @escaping () -> Void) {
        perform(where: { $0.reloadFlowKey == key }, action: .reloadData)
        completion()
    }

    static func releaseByKey(key: String, completion: @escaping () -> Void) {
        let flows = hashFlows.allObjects.filter { $0.releaseFlowKey == key }.reversed()
        flows.forEach { $0.invokeFeature(HFlowFeatureSelector.memoryRelease) }
        completion()
    }

    private static func executeAction(_ action: HFlowObserverAction, on flow: HFlowView) {
        switch action {
        case .reloadData:
            flow.reloadFlowData()
        case .custom(let customAction):
            customAction(flow)
        }
    }
}

extension HFlowView {
    /// Core `setup` 钩子，选择器名勿改。
    @objc func hflow_observer_setup() {
        HFlowObserver.addObserver(self)
    }

    /// Core `deinit` 钩子，选择器名勿改。
    @objc func hflow_observer_deinit() {
        HFlowObserver.removeObserver(self)
    }
}
