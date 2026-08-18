////
////  HTestView.swift
////  HSwiftProject
////
////  Created by owner on 2025/7/22.
////  Copyright © 2025 wind. All rights reserved.
////
//
//import UIKit
//
//// 组件基类（所有具体组件需继承）
//class DPMBaseComponentView: HBaseView {
//    // 复用标识（子类需重写）
//    class var reuseIdentifier: String {
//        return String(describing: self)
//    }
//    
//    // 复用前重置状态（子类按需重写）
//    func prepareForReuse() {}
//}
//
//// 热门商品组件（继承基类）
//class HotComponentView: DPMBaseComponentView {
//    private let titleLabel = UILabel()
//    private let imageView = UIImageView()
//    
//    override class var reuseIdentifier: String {
//        return "HotComponentView"
//    }
//    
//    // 复用前重置
//    override func prepareForReuse() {
//        titleLabel.text = nil
//        imageView.image = nil
//    }
//}
//
//class DPMStackViewReusePool {
//    // 存储复用组件：key=组件类型标识，value=可复用组件数组
//    private var reuseCache: [String: [DPMBaseComponentView]] = [:]
//    
//    // 从池中获取可复用组件（无则创建新实例）
//    func dequeueComponent<T: DPMBaseComponentView>(ofType type: T.Type) -> T {
//        let reuseId = T.reuseIdentifier
//        // 1. 尝试从缓存中获取
//        if var components = reuseCache[reuseId], !components.isEmpty {
//            let component = components.removeLast() as! T
//            return component
//        }
//        // 2. 缓存中无可用组件，创建新实例
//        let newComponent = T()
//        return newComponent
//    }
//    
//    // 将组件回收至复用池
//    func recycleComponent(_ component: DPMBaseComponentView) {
//        let reuseId = type(of: component).reuseIdentifier
//        component.prepareForReuse() // 回收前重置状态
//        if var components = reuseCache[reuseId] {
//            components.append(component)
//            reuseCache[reuseId] = components
//        } else {
//            reuseCache[reuseId] = [component]
//        }
//    }
//    
//    // 清空指定类型的复用缓存
//    func clearCache(for type: String) {
//        reuseCache.removeValue(forKey: type)
//    }
//}
//
//class DPMStackView: UIStackView {
//    // 组件复用池
//    private var componentReusePool = DPMStackViewReusePool()
//    
//    // 当前显示的组件数组（用于刷新时回收）
//    private var currentComponents: [DPMBaseComponentView] = []
//    
//    
//    // 回收至复用池
//    func recycleComponentViews() {
//        // 回收当前所有组件至复用池
//        currentComponents.forEach { component in
//            self.removeArrangedSubview(component)
//            componentReusePool.recycleComponent(component)
//        }
//        currentComponents.removeAll()
//    }
//    
//    // 核心方法：通过数据模型数组刷新组件
//    func addComponentView(_ view: DPMBaseComponentView) {
//        // 创建/复用组件
//        let component = componentReusePool.dequeueComponent(ofType: view.self)
//        self.addArrangedSubview(component)
//        currentComponents.append(component)
//    }
//    
//    // 强制刷新布局（批量更新后一次计算）
//    func reloadComponentViews() {
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//    }
//}
