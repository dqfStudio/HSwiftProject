//
//  HCollView+Core.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Combine

// MARK: - Core Functionality
extension HCollView {

    override var frame: CGRect {
        get { super.frame }
        set {
            let adjustedFrame = UIRectIntegral(newValue)
            let oldWidth = super.frame.width
            super.frame = adjustedFrame
            // Only invalidate layout on width changes (e.g., rotation), not on every Auto Layout pass
            if abs(adjustedFrame.width - oldWidth) > 0.5 {
                collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 更新对齐方式
        self.updateAlign()
        // 当 bounds 变化时更新空视图 frame
        updateEmptyViewFrame()
    }
    
    /// Update empty view frame to match current bounds
    internal func updateEmptyViewFrame() {
        subviews.forEach { view in
            if view.tag == Constants.emptyViewTag {
                view.frame = bounds
            }
        }
    }
    
    /// 更新对齐方式
    internal func updateAlign() {
        currentContentSize = contentSize // 保存contentSize
        contentInset = alignStrategy.calculateCntInset(for: self, cntSize: contentSize, cntInset: contentInset)
    }

    /// 初始化 HCollView 的设置
    ///
    /// 此方法在 HCollView 初始化时调用，配置各种默认设置，包括：
    /// - 注册全局刷新通知
    /// - 设置默认标签
    /// - 根据滚动方向配置弹跳行为
    /// - 配置外观（背景色、键盘 Dismiss 模式、滚动指示器等）
    /// - 禁用自动内容内边距调整（iOS 11.0+）
    /// - 设置节流刷新
    /// - 监听内存警告
    internal func setup() {
        // 注册全局刷新通知
        HCollObserver.addObserver(self)

        // 设置默认标签
        self.tag = kCollDefaultTag

        // 根据滚动方向配置弹跳行为
        if self.flowLayout?.scrollDirection == .vertical {
            self.enableVerticalBounce()
        } else {
            self.enableHorizontalBounce()
        }
        
        // 配置外观
        self.backgroundColor = .clear
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        // 禁用自动内容内边距调整（iOS 11.0+）
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        
        // 设置节流刷新
        setupRefreshThrottle()
        
        // 监听内存警告
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    /// 配置刷新节流操作
    ///
    /// 此方法配置刷新节流，避免频繁刷新导致的性能问题。
    /// 它使用 Combine 框架的 throttle 操作符，将短时间内的多次刷新请求合并为一次。
    /// - 节流间隔由 `refreshThrottleInterval` 属性控制，默认为 2 秒
    internal func setupRefreshThrottle() {
        // 清除之前的订阅
        cancellables.removeAll()
        
        // 重新配置节流操作
        refreshSubject
            .throttle(for: .seconds(refreshThrottleInterval), scheduler: RunLoop.main, latest: true)
            .sink {
                [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    /// 生成唯一标识符
    internal func generateIdentifier(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> String {
        var identifier = (pre ?? "") + NSStringFromClass(cls)
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        return identifier
    }
    
    /// Register and reuse header view with type safety
    @discardableResult
    func reuseHeader<T: HCollBaseApex>(_ cls: T.Type, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, pre, idx, indexPath)
        
        if !allHeaderIdentifiers.contains(identifier) {
            allHeaderIdentifiers.insert(identifier)
            register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }
        
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! T
        view.indexPath = indexPath
        view.isHeader = true
        view.coll = self
        
        return view
    }

    /// Register and reuse footer view with type safety
    @discardableResult
    func reuseFooter<T: HCollBaseApex>(_ cls: T.Type, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, pre, idx, indexPath)
        
        if !allFooterIdentifiers.contains(identifier) {
            allFooterIdentifiers.insert(identifier)
            register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }
        
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! T
        view.indexPath = indexPath
        view.isHeader = false
        view.coll = self
        
        return view
    }
    
    /// Register and reuse cell with type safety
    @discardableResult
    func reuseCell<T: HCollBaseCell>(_ cls: T.Type, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, pre, idx, indexPath)

        if !allCellIdentifiers.contains(identifier) {
            allCellIdentifiers.insert(identifier)
            register(cls, forCellWithReuseIdentifier: identifier)
        }

        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
        cell.indexPath = indexPath
        cell.coll = self

        return cell
    }
    
    /// Register supplementary view if not already registered
    internal func registerIfNeeded(_ identifier: String, forKind kind: String) {
        let isHeader = kind == UICollectionView.elementKindSectionHeader
        
        if isHeader {
            if !allHeaderIdentifiers.contains(identifier) {
                allHeaderIdentifiers.insert(identifier)
                register(HCollBaseApex.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
            }
        } else {
            if !allFooterIdentifiers.contains(identifier) {
                allFooterIdentifiers.insert(identifier)
                register(HCollBaseApex.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let outsideContentBlock = self.outsideContentBlock else {
            return super.point(inside: point, with: event)
        }
        
        // 检查点击是否在任何可见的item或者supplementary view上
        guard let layoutAttributes = collectionViewLayout.layoutAttributesForElements(in: bounds) else {
            return true
        }
        
        // 优化：先检查cell，再检查header/footer
        for attribute in layoutAttributes {
            if attribute.frame.contains(point) {
                switch attribute.representedElementCategory {
                case .cell, .supplementaryView:
                    return true
                default:
                    break
                }
            }
        }
        
        // 如果点击不在任何cell或header/footer上
        outsideContentBlock()
        return true
    }
    
}
