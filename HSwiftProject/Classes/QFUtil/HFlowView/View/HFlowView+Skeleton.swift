//
//  HFlowView+Skeleton.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 骨架屏类型枚举
enum HFlowSkeletonType {
    case text         // 文本骨架
    case image        // 图片骨架
    case card         // 卡片骨架
    case custom       // 自定义骨架
}

/// 骨架屏配置结构体
struct HFlowSkeletonConfig {
    /// 骨架屏类型
    var type: HFlowSkeletonType
    /// 骨架屏数量
    var count: Int
    /// 骨架屏颜色
    var color: UIColor
    /// 动画类型
    var animationType: HFlowSkeletonAnimationType
    /// 动画速度
    var animationSpeed: TimeInterval
    
    /// 默认配置
    static let `default` = HFlowSkeletonConfig(
        type: .text,
        count: 5,
        color: UIColor.lightGray.withAlphaComponent(0.3),
        animationType: .shimmer,
        animationSpeed: 1.5
    )
}

/// 骨架屏动画类型枚举
enum HFlowSkeletonAnimationType {
    case none         // 无动画
    case shimmer      // 微光动画
    case pulse        // 脉冲动画
    case fade         // 淡入淡出动画
}

/// HFlowView 骨架屏扩展
///
/// 为 HFlowView 提供骨架屏功能，在数据加载过程中显示骨架屏，提升用户体验
///
/// 实现功能：
/// 1. 支持多种骨架屏类型
/// 2. 提供骨架屏动画效果
/// 3. 支持自定义骨架屏
/// 4. 自动管理骨架屏的显示和隐藏

// 关联对象的键
private var enableSkeletonKey: UInt8 = 0
private var skeletonConfigKey: UInt8 = 0
private var skeletonViewKey: UInt8 = 0
private var skeletonCellsKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Skeleton Properties
    
    /// 是否启用骨架屏
    public var enableSkeleton: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableSkeletonKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableSkeletonKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 骨架屏配置
    public var skeletonConfig: HFlowSkeletonConfig {
        get {
            if let config = objc_getAssociatedObject(self, &skeletonConfigKey) as? HFlowSkeletonConfig {
                return config
            }
            return HFlowSkeletonConfig.default
        }
        set {
            objc_setAssociatedObject(self, &skeletonConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 骨架屏视图
    private var skeletonView: UIView? {
        get {
            return objc_getAssociatedObject(self, &skeletonViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &skeletonViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 骨架屏 cell 数组
    private var skeletonCells: [UITableViewCell] {
        get {
            if let cells = objc_getAssociatedObject(self, &skeletonCellsKey) as? [UITableViewCell] {
                return cells
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &skeletonCellsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Skeleton Methods
    
    /// 显示骨架屏
    func showSkeleton() {
        guard enableSkeleton, skeletonView == nil else { return }
        
        // 创建骨架屏视图
        let skeletonView = UIView(frame: bounds)
        skeletonView.backgroundColor = backgroundColor
        skeletonView.tag = 9998
        
        // 创建骨架屏 cell
        createSkeletonCells()
        
        // 添加骨架屏 cell 到骨架屏视图
        var yOffset: CGFloat = 0
        for cell in skeletonCells {
            cell.frame = CGRect(x: 0, y: yOffset, width: bounds.width, height: 80)
            skeletonView.addSubview(cell)
            yOffset += 80
        }
        
        // 添加骨架屏视图到 HFlowView
        addSubview(skeletonView)
        self.skeletonView = skeletonView
        
        // 启动骨架屏动画
        startSkeletonAnimation()
    }
    
    /// 隐藏骨架屏
    func hideSkeleton() {
        guard let skeletonView = skeletonView else { return }
        
        // 停止骨架屏动画
        stopSkeletonAnimation()
        
        // 移除骨架屏视图
        UIView.animate(
            withDuration: 0.3,
            animations: {
                skeletonView.alpha = 0
            },
            completion: {
                _ in
                skeletonView.removeFromSuperview()
                self.skeletonView = nil
                self.skeletonCells.removeAll()
            }
        )
    }
    
    /// 创建骨架屏 cell
    private func createSkeletonCells() {
        skeletonCells.removeAll()
        
        for _ in 0..<skeletonConfig.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "skeletonCell")
            cell.backgroundColor = .clear
            
            // 根据骨架屏类型创建不同的骨架
            switch skeletonConfig.type {
            case .text:
                createTextSkeleton(for: cell)
            case .image:
                createImageSkeleton(for: cell)
            case .card:
                createCardSkeleton(for: cell)
            case .custom:
                createCustomSkeleton(for: cell)
            }
            
            skeletonCells.append(cell)
        }
    }
    
    /// 创建文本骨架
    /// - Parameter cell: 要添加骨架的 cell
    private func createTextSkeleton(for cell: UITableViewCell) {
        // 创建文本骨架
        let textSkeleton1 = UIView(frame: CGRect(x: 20, y: 20, width: bounds.width - 40, height: 15))
        textSkeleton1.backgroundColor = skeletonConfig.color
        textSkeleton1.layer.cornerRadius = 4
        cell.contentView.addSubview(textSkeleton1)
        
        let textSkeleton2 = UIView(frame: CGRect(x: 20, y: 45, width: bounds.width - 80, height: 12))
        textSkeleton2.backgroundColor = skeletonConfig.color
        textSkeleton2.layer.cornerRadius = 4
        cell.contentView.addSubview(textSkeleton2)
        
        let textSkeleton3 = UIView(frame: CGRect(x: 20, y: 62, width: bounds.width - 120, height: 12))
        textSkeleton3.backgroundColor = skeletonConfig.color
        textSkeleton3.layer.cornerRadius = 4
        cell.contentView.addSubview(textSkeleton3)
    }
    
    /// 创建图片骨架
    /// - Parameter cell: 要添加骨架的 cell
    private func createImageSkeleton(for cell: UITableViewCell) {
        // 创建图片骨架
        let imageSkeleton = UIView(frame: CGRect(x: 20, y: 10, width: 60, height: 60))
        imageSkeleton.backgroundColor = skeletonConfig.color
        imageSkeleton.layer.cornerRadius = 8
        cell.contentView.addSubview(imageSkeleton)
        
        // 添加文本骨架
        let textSkeleton1 = UIView(frame: CGRect(x: 90, y: 20, width: bounds.width - 110, height: 15))
        textSkeleton1.backgroundColor = skeletonConfig.color
        textSkeleton1.layer.cornerRadius = 4
        cell.contentView.addSubview(textSkeleton1)
        
        let textSkeleton2 = UIView(frame: CGRect(x: 90, y: 45, width: bounds.width - 150, height: 12))
        textSkeleton2.backgroundColor = skeletonConfig.color
        textSkeleton2.layer.cornerRadius = 4
        cell.contentView.addSubview(textSkeleton2)
    }
    
    /// 创建卡片骨架
    /// - Parameter cell: 要添加骨架的 cell
    private func createCardSkeleton(for cell: UITableViewCell) {
        // 创建卡片骨架
        let cardSkeleton = UIView(frame: CGRect(x: 10, y: 10, width: bounds.width - 20, height: 60))
        cardSkeleton.backgroundColor = skeletonConfig.color
        cardSkeleton.layer.cornerRadius = 8
        cell.contentView.addSubview(cardSkeleton)
        
        // 添加文本骨架
        let textSkeleton = UIView(frame: CGRect(x: 20, y: 25, width: bounds.width - 40, height: 15))
        textSkeleton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        textSkeleton.layer.cornerRadius = 4
        cardSkeleton.addSubview(textSkeleton)
    }
    
    /// 创建自定义骨架
    /// - Parameter cell: 要添加骨架的 cell
    private func createCustomSkeleton(for cell: UITableViewCell) {
        // 调用代理方法创建自定义骨架
        flowDelegate?.createCustomSkeleton(for: cell)
    }
    
    /// 启动骨架屏动画
    private func startSkeletonAnimation() {
        switch skeletonConfig.animationType {
        case .shimmer:
            startShimmerAnimation()
        case .pulse:
            startPulseAnimation()
        case .fade:
            startFadeAnimation()
        case .none:
            break
        }
    }
    
    /// 停止骨架屏动画
    private func stopSkeletonAnimation() {
        skeletonCells.forEach { cell in
            cell.contentView.subviews.forEach { subview in
                subview.layer.removeAllAnimations()
            }
        }
    }
    
    /// 启动微光动画
    private func startShimmerAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        skeletonCells.forEach { cell in
            cell.contentView.subviews.forEach { subview in
                guard let subGradientLayer = gradientLayer.copy() as? CAGradientLayer else { return }

                subGradientLayer.frame = CGRect(x: -subview.bounds.width, y: 0, width: subview.bounds.width * 3, height: subview.bounds.height)
                subview.layer.mask = subGradientLayer
                
                let animation = CABasicAnimation(keyPath: "transform.translation.x")
                animation.fromValue = 0
                animation.toValue = subview.bounds.width * 3
                animation.duration = skeletonConfig.animationSpeed
                animation.repeatCount = .infinity
                animation.timingFunction = CAMediaTimingFunction(name: .linear)
                
                subGradientLayer.add(animation, forKey: "shimmer")
            }
        }
    }
    
    /// 启动脉冲动画
    private func startPulseAnimation() {
        skeletonCells.forEach { cell in
            cell.contentView.subviews.forEach { subview in
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = 1
                animation.toValue = 0.3
                animation.duration = skeletonConfig.animationSpeed
                animation.repeatCount = .infinity
                animation.autoreverses = true
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                subview.layer.add(animation, forKey: "pulse")
            }
        }
    }
    
    /// 启动淡入淡出动画
    private func startFadeAnimation() {
        skeletonCells.forEach { cell in
            cell.contentView.subviews.forEach { subview in
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = 0.3
                animation.toValue = 1
                animation.duration = skeletonConfig.animationSpeed
                animation.repeatCount = .infinity
                animation.autoreverses = true
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                subview.layer.add(animation, forKey: "fade")
            }
        }
    }
}

/// 扩展 HFlowViewDelegate，添加骨架屏相关方法
extension HFlowViewDelegate {
    /// 创建自定义骨架
    /// - Parameter cell: 要添加骨架的 cell
    func createCustomSkeleton(for cell: UITableViewCell) {
        // 默认实现为空
    }
    
    /// 获取骨架屏配置
    /// - Returns: 骨架屏配置
    func getSkeletonConfig() -> HFlowSkeletonConfig {
        return HFlowSkeletonConfig.default
    }
    
    /// 当骨架屏显示时调用
    func skeletonDidShow() {
        // 默认实现为空
    }
    
    /// 当骨架屏隐藏时调用
    func skeletonDidHide() {
        // 默认实现为空
    }
}
