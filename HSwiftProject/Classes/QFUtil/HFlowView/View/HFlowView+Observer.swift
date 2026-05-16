//
//  HFlowView+Observer.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 全局观察者类，用于管理 HFlowView 的刷新通知
class HFlowObserver {
    
    /// 单例实例
    static let shared = HFlowObserver()
    
    /// 存储所有观察者
    private var observers: [Weak<HFlowView>] = []
    
    /// 私有初始化方法
    private init() {}
    
    /// 添加观察者
    /// - Parameter observer: HFlowView 实例
    static func addObserver(_ observer: HFlowView) {
        shared.observers.append(Weak(observer))
    }
    
    /// 移除观察者
    /// - Parameter observer: HFlowView 实例
    static func removeObserver(_ observer: HFlowView) {
        shared.observers = shared.observers.filter { $0.value !== observer && $0.value != nil }
    }
    
    /// 通知所有观察者刷新
    static func notifyRefresh() {
        // 过滤出有效的观察者
        let validObservers = shared.observers.compactMap { $0.value }
        // 通知所有有效的观察者
        DispatchQueue.main.async {
            validObservers.forEach { $0.reloadFlowDataIncremental() }
        }
    }
    
    /// 通知指定观察者刷新
    /// - Parameter observer: HFlowView 实例
    static func notifyRefresh(_ observer: HFlowView) {
        DispatchQueue.main.async {
            observer.reloadFlowDataIncremental()
        }
    }
}

// MARK: - Observer Pattern
extension HFlowView {
    
    /// 注册为观察者
    func registerAsObserver() {
        HFlowObserver.addObserver(self)
    }
    
    /// 移除观察者
    func removeObserver() {
        HFlowObserver.removeObserver(self)
    }
    
    /// 通知所有 HFlowView 实例刷新
    static func notifyAllRefresh() {
        HFlowObserver.notifyRefresh()
    }
}
