//
//  HCollView+Skeleton.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 骨架屏扩展
///
/// 提供更丰富的骨架屏样式和动画效果
extension HCollView {
    
    /// 骨架屏样式
    enum SkeletonStyle {
        case solid         // 实心样式
        case gradient      // 渐变样式
        case pulse         // 脉冲样式
        case shimmer       // 闪光样式
    }
    
    /// 骨架屏管理器
    class SkeletonManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 骨架屏视图
        private var skeletonView: UIView?
        
        /// 骨架屏样式
        var style: SkeletonStyle = .shimmer
        
        /// 骨架屏颜色
        var skeletonColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        /// 骨架屏动画持续时间
        var animationDuration: TimeInterval = 1.5
        
        /// 是否显示骨架屏
        private var isShowing: Bool = false
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 显示骨架屏
        /// - Parameters:
        ///   - count: 骨架屏数量
        ///   - animated: 是否动画
        func showSkeleton(count: Int = 10, animated: Bool = true) {
            guard let collectionView = collectionView else { return }
            guard !isShowing else { return }
            
            // 隐藏集合视图
            collectionView.isHidden = true
            
            // 创建骨架屏视图
            let skeletonView = UIView(frame: collectionView.bounds)
            skeletonView.backgroundColor = collectionView.backgroundColor
            collectionView.superview?.addSubview(skeletonView)
            skeletonView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // 创建骨架屏单元格
            for i in 0..<count {
                let cellFrame = CGRect(
                    x: 10,
                    y: 10 + CGFloat(i) * 80,
                    width: skeletonView.bounds.width - 20,
                    height: 70
                )
                
                let skeletonCell = createSkeletonCell(frame: cellFrame)
                skeletonView.addSubview(skeletonCell)
            }
            
            // 保存骨架屏视图
            self.skeletonView = skeletonView
            isShowing = true
            
            // 开始动画
            if animated {
                startAnimation()
            }
        }
        
        /// 隐藏骨架屏
        /// - Parameter animated: 是否动画
        func hideSkeleton(animated: Bool = true) {
            guard isShowing, let skeletonView = skeletonView else { return }
            
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    skeletonView.alpha = 0
                }, completion: {
                    [weak self] _ in
                    skeletonView.removeFromSuperview()
                    self?.skeletonView = nil
                    self?.isShowing = false
                    self?.collectionView?.isHidden = false
                })
            } else {
                skeletonView.removeFromSuperview()
                self.skeletonView = nil
                isShowing = false
                collectionView?.isHidden = false
            }
        }
        
        /// 创建骨架屏单元格
        /// - Parameter frame: 单元格 frame
        /// - Returns: 骨架屏单元格
        private func createSkeletonCell(frame: CGRect) -> UIView {
            let cell = UIView(frame: frame)
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            cell.layer.cornerRadius = 8
            
            // 添加子视图
            let titleFrame = CGRect(x: 10, y: 10, width: frame.width - 20, height: 16)
            let titleView = createSkeletonSubview(frame: titleFrame)
            cell.addSubview(titleView)
            
            let contentFrame = CGRect(x: 10, y: 36, width: frame.width - 60, height: 12)
            let contentView = createSkeletonSubview(frame: contentFrame)
            cell.addSubview(contentView)
            
            let contentFrame2 = CGRect(x: 10, y: 54, width: frame.width - 100, height: 12)
            let contentView2 = createSkeletonSubview(frame: contentFrame2)
            cell.addSubview(contentView2)
            
            return cell
        }
        
        /// 创建骨架屏子视图
        /// - Parameter frame: 子视图 frame
        /// - Returns: 骨架屏子视图
        private func createSkeletonSubview(frame: CGRect) -> UIView {
            let view = UIView(frame: frame)
            view.backgroundColor = skeletonColor
            view.layer.cornerRadius = 4
            
            // 根据样式设置视图
            switch style {
            case .gradient:
                addGradient(to: view)
            case .shimmer:
                addShimmer(to: view)
            default:
                break
            }
            
            return view
        }
        
        /// 添加渐变效果
        /// - Parameter view: 目标视图
        private func addGradient(to view: UIView) {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [
                UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor,
                UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            view.layer.addSublayer(gradient)
        }
        
        /// 添加闪光效果
        /// - Parameter view: 目标视图
        private func addShimmer(to view: UIView) {
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: -view.bounds.width, y: 0, width: 3 * view.bounds.width, height: view.bounds.height)
            gradient.colors = [
                UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.0).cgColor,
                UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5).cgColor,
                UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.0).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            view.layer.addSublayer(gradient)
            
            // 添加动画
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = -gradient.bounds.width / 3
            animation.toValue = view.bounds.width + gradient.bounds.width / 3
            animation.duration = animationDuration
            animation.repeatCount = .infinity
            gradient.add(animation, forKey: "shimmer")
        }
        
        /// 开始动画
        private func startAnimation() {
            guard let skeletonView = skeletonView else { return }
            
            for subview in skeletonView.subviews {
                switch style {
                case .pulse:
                    addPulseAnimation(to: subview)
                default:
                    break
                }
            }
        }
        
        /// 添加脉冲动画
        /// - Parameter view: 目标视图
        private func addPulseAnimation(to view: UIView) {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1.0
            animation.toValue = 0.5
            animation.duration = animationDuration
            animation.autoreverses = true
            animation.repeatCount = .infinity
            view.layer.add(animation, forKey: "pulse")
        }
    }
    
    /// 骨架屏管理器
    var skeletonManager: SkeletonManager {
        get {
            if let manager = objc_getAssociatedObject(self, &skeletonManagerKey) as? SkeletonManager {
                return manager
            } else {
                let manager = SkeletonManager(collectionView: self)
                objc_setAssociatedObject(self, &skeletonManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &skeletonManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 显示骨架屏
    /// - Parameters:
    ///   - count: 骨架屏数量
    ///   - style: 骨架屏样式
    ///   - animated: 是否动画
    func showSkeleton(count: Int = 10, style: SkeletonStyle = .shimmer, animated: Bool = true) {
        skeletonManager.style = style
        skeletonManager.showSkeleton(count: count, animated: animated)
    }
    
    /// 隐藏骨架屏
    /// - Parameter animated: 是否动画
    func hideSkeleton(animated: Bool = true) {
        skeletonManager.hideSkeleton(animated: animated)
    }
    
    /// 设置骨架屏颜色
    /// - Parameter color: 骨架屏颜色
    func setSkeletonColor(_ color: UIColor) {
        skeletonManager.skeletonColor = color
    }
    
    /// 设置骨架屏动画持续时间
    /// - Parameter duration: 动画持续时间
    func setSkeletonAnimationDuration(_ duration: TimeInterval) {
        skeletonManager.animationDuration = duration
    }
}

// 关联对象键
private var skeletonManagerKey: UInt8 = 0
