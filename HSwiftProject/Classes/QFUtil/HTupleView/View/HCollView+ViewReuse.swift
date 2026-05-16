//
//  HCollView+ViewReuse.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 视图复用优化扩展
///
/// 进一步优化cell和supplementary view的复用机制
extension HCollView {
    
    /// 视图复用管理器
    class ViewReuseManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// cell 复用池
        private var cellReusePool: [String: [UICollectionViewCell]] = [:]
        
        /// supplementary view 复用池
        private var supplementaryViewReusePool: [String: [UICollectionReusableView]] = [:]
        
        /// 最大复用池大小
        var maxReusePoolSize: Int = 10
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 从复用池获取 cell
        /// - Parameters:
        ///   - identifier: 重用标识符
        ///   - indexPath: 索引路径
        /// - Returns: cell
        func dequeueCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell? {
            // 检查复用池
            if var cells = cellReusePool[identifier], !cells.isEmpty {
                let cell = cells.removeLast()
                cellReusePool[identifier] = cells
                return cell
            }
            
            return nil
        }
        
        /// 从复用池获取 supplementary view
        /// - Parameters:
        ///   - elementKind: 元素类型
        ///   - identifier: 重用标识符
        ///   - indexPath: 索引路径
        /// - Returns: supplementary view
        func dequeueSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView? {
            let key = "\(elementKind)_\(identifier)"
            
            // 检查复用池
            if var views = supplementaryViewReusePool[key], !views.isEmpty {
                let view = views.removeLast()
                supplementaryViewReusePool[key] = views
                return view
            }
            
            return nil
        }
        
        /// 将 cell 加入复用池
        /// - Parameter cell: cell
        func enqueueCell(_ cell: UICollectionViewCell) {
            guard let identifier = cell.reuseIdentifier else { return }
            
            // 检查复用池大小
            if var cells = cellReusePool[identifier] {
                if cells.count < maxReusePoolSize {
                    cells.append(cell)
                    cellReusePool[identifier] = cells
                }
            } else {
                cellReusePool[identifier] = [cell]
            }
        }
        
        /// 将 supplementary view 加入复用池
        /// - Parameters:
        ///   - view: supplementary view
        ///   - elementKind: 元素类型
        func enqueueSupplementaryView(_ view: UICollectionReusableView, ofKind elementKind: String) {
            guard let identifier = view.reuseIdentifier else { return }
            
            let key = "\(elementKind)_\(identifier)"
            
            // 检查复用池大小
            if var views = supplementaryViewReusePool[key] {
                if views.count < maxReusePoolSize {
                    views.append(view)
                    supplementaryViewReusePool[key] = views
                }
            } else {
                supplementaryViewReusePool[key] = [view]
            }
        }
        
        /// 清理复用池
        func clearReusePool() {
            cellReusePool.removeAll()
            supplementaryViewReusePool.removeAll()
        }
        
        /// 清理指定标识符的复用池
        /// - Parameter identifier: 重用标识符
        func clearReusePool(for identifier: String) {
            cellReusePool.removeValue(forKey: identifier)
            
            // 清理 supplementary view 复用池
            for (key, _) in supplementaryViewReusePool where key.contains(identifier) {
                supplementaryViewReusePool.removeValue(forKey: key)
            }
        }
        
        /// 获取复用池状态
        /// - Returns: 复用池状态
        func getReusePoolStatus() -> [String: Any] {
            var status: [String: Any] = [:]
            
            // cell 复用池状态
            var cellStatus: [String: Int] = [:]
            for (identifier, cells) in cellReusePool {
                cellStatus[identifier] = cells.count
            }
            status["cellReusePool"] = cellStatus
            
            // supplementary view 复用池状态
            var supplementaryViewStatus: [String: Int] = [:]
            for (key, views) in supplementaryViewReusePool {
                supplementaryViewStatus[key] = views.count
            }
            status["supplementaryViewReusePool"] = supplementaryViewStatus
            
            return status
        }
    }
    
    /// 视图复用管理器
    var viewReuseManager: ViewReuseManager {
        get {
            if let manager = objc_getAssociatedObject(self, &viewReuseManagerKey) as? ViewReuseManager {
                return manager
            } else {
                let manager = ViewReuseManager(collectionView: self)
                objc_setAssociatedObject(self, &viewReuseManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &viewReuseManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用优化的视图复用
    func enableOptimizedViewReuse() {
        // 这里可以替换默认的复用机制
        // 例如：重写 dequeueReusableCell 方法
    }
    
    /// 禁用优化的视图复用
    func disableOptimizedViewReuse() {
        viewReuseManager.clearReusePool()
    }
    
    /// 清理复用池
    func clearReusePool() {
        viewReuseManager.clearReusePool()
    }
    
    /// 获取复用池状态
    /// - Returns: 复用池状态
    func getReusePoolStatus() -> [String: Any] {
        return viewReuseManager.getReusePoolStatus()
    }
}

// 关联对象键
private var viewReuseManagerKey: UInt8 = 0

// MARK: - 重写 dequeue 方法以使用优化的复用机制
extension HCollView {
    
    /// 优化的 dequeueReusableCell 方法
    /// - Parameters:
    ///   - identifier: 重用标识符
    ///   - indexPath: 索引路径
    /// - Returns: cell
    func optimizedDequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        // 尝试从优化的复用池获取
        if let cell = viewReuseManager.dequeueCell(withReuseIdentifier: identifier, for: indexPath) {
            return cell
        }
        
        // 如果复用池没有，使用默认方法
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    /// 优化的 dequeueReusableSupplementaryView 方法
    /// - Parameters:
    ///   - elementKind: 元素类型
    ///   - identifier: 重用标识符
    ///   - indexPath: 索引路径
    /// - Returns: supplementary view
    func optimizedDequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        // 尝试从优化的复用池获取
        if let view = viewReuseManager.dequeueSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath) {
            return view
        }
        
        // 如果复用池没有，使用默认方法
        return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    /// 回收 cell
    /// - Parameter cell: cell
    func recycleCell(_ cell: UICollectionViewCell) {
        viewReuseManager.enqueueCell(cell)
    }
    
    /// 回收 supplementary view
    /// - Parameters:
    ///   - view: supplementary view
    ///   - elementKind: 元素类型
    func recycleSupplementaryView(_ view: UICollectionReusableView, ofKind elementKind: String) {
        viewReuseManager.enqueueSupplementaryView(view, ofKind: elementKind)
    }
}
