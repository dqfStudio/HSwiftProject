//
//  HCollView+InteractionMode.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 交互模式扩展
///
/// 提供更多高级手势和交互功能
extension HCollView {
    
    /// 交互模式
    enum InteractionMode {
        case normal       // 正常模式
        case selection    // 选择模式
        case dragDrop     // 拖拽排序模式
        case swipe        // 滑动操作模式
        case multiSelect  // 多选模式
        case custom       // 自定义模式
    }
    
    /// 交互管理器
    class InteractionManager {
        
        // MARK: - 单例
        static let shared = InteractionManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 当前交互模式
        private var currentInteractionMode: InteractionMode = .normal
        
        /// 是否启用拖拽排序
        var dragDropEnabled: Bool = false
        
        /// 是否启用滑动操作
        var swipeEnabled: Bool = false
        
        /// 是否启用多选模式
        var multiSelectEnabled: Bool = false
        
        /// 滑动操作配置
        struct SwipeActionsConfig {
            var leadingActions: [UIContextualAction] = []
            var trailingActions: [UIContextualAction] = []
        }
        
        /// 滑动操作配置
        var swipeActionsConfig: SwipeActionsConfig = SwipeActionsConfig()
        
        // MARK: - 方法
        
        /// 设置交互模式
        /// - Parameters:
        ///   - mode: 交互模式
        ///   - collectionView: 集合视图
        func setInteractionMode(_ mode: InteractionMode, in collectionView: UICollectionView) {
            currentInteractionMode = mode
            
            switch mode {
            case .normal:
                configureNormalMode(in: collectionView)
            case .selection:
                configureSelectionMode(in: collectionView)
            case .dragDrop:
                configureDragDropMode(in: collectionView)
            case .swipe:
                configureSwipeMode(in: collectionView)
            case .multiSelect:
                configureMultiSelectMode(in: collectionView)
            case .custom:
                break
            }
        }
        
        /// 配置正常模式
        /// - Parameter collectionView: 集合视图
        private func configureNormalMode(in collectionView: UICollectionView) {
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = false
            dragDropEnabled = false
            swipeEnabled = false
        }
        
        /// 配置选择模式
        /// - Parameter collectionView: 集合视图
        private func configureSelectionMode(in collectionView: UICollectionView) {
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = false
        }
        
        /// 配置拖拽排序模式
        /// - Parameter collectionView: 集合视图
        private func configureDragDropMode(in collectionView: UICollectionView) {
            dragDropEnabled = true
            
            if let collectionView = collectionView as? HCollView {
                collectionView.dragInteractionEnabled = true
                collectionView.reorderingCadence = .immediate
            }
        }
        
        /// 配置滑动操作模式
        /// - Parameter collectionView: 集合视图
        private func configureSwipeMode(in collectionView: UICollectionView) {
            swipeEnabled = true
        }
        
        /// 配置多选模式
        /// - Parameter collectionView: 集合视图
        private func configureMultiSelectMode(in collectionView: UICollectionView) {
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = true
            multiSelectEnabled = true
        }
        
        /// 获取当前交互模式
        /// - Returns: 当前交互模式
        func getCurrentInteractionMode() -> InteractionMode {
            return currentInteractionMode
        }
        
        /// 添加滑动操作
        /// - Parameters:
        ///   - actions: 滑动操作
        ///   - position: 操作位置
        func addSwipeActions(_ actions: [UIContextualAction], position: UICollectionView.SwipeActionsConfiguration.Position) {
            if position == .leading {
                swipeActionsConfig.leadingActions = actions
            } else {
                swipeActionsConfig.trailingActions = actions
            }
        }
        
        /// 清除滑动操作
        func clearSwipeActions() {
            swipeActionsConfig.leadingActions.removeAll()
            swipeActionsConfig.trailingActions.removeAll()
        }
        
        /// 启用拖拽排序
        /// - Parameter collectionView: 集合视图
        func enableDragDrop(in collectionView: UICollectionView) {
            dragDropEnabled = true
            
            if let collectionView = collectionView as? HCollView {
                collectionView.dragInteractionEnabled = true
                collectionView.reorderingCadence = .immediate
            }
        }
        
        /// 禁用拖拽排序
        /// - Parameter collectionView: 集合视图
        func disableDragDrop(in collectionView: UICollectionView) {
            dragDropEnabled = false
            
            if let collectionView = collectionView as? HCollView {
                collectionView.dragInteractionEnabled = false
            }
        }
        
        /// 启用滑动操作
        func enableSwipe() {
            swipeEnabled = true
        }
        
        /// 禁用滑动操作
        func disableSwipe() {
            swipeEnabled = false
        }
        
        /// 启用多选模式
        /// - Parameter collectionView: 集合视图
        func enableMultiSelect(in collectionView: UICollectionView) {
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = true
            multiSelectEnabled = true
        }
        
        /// 禁用多选模式
        /// - Parameter collectionView: 集合视图
        func disableMultiSelect(in collectionView: UICollectionView) {
            collectionView.allowsMultipleSelection = false
            multiSelectEnabled = false
        }
    }
    
    /// 交互管理器
    var interactionManager: InteractionManager {
        return InteractionManager.shared
    }
    
    /// 设置交互模式
    /// - Parameter mode: 交互模式
    func setInteractionMode(_ mode: InteractionMode) {
        interactionManager.setInteractionMode(mode, in: self)
    }
    
    /// 获取当前交互模式
    /// - Returns: 当前交互模式
    func getCurrentInteractionMode() -> InteractionMode {
        return interactionManager.getCurrentInteractionMode()
    }
    
    /// 添加滑动操作
    /// - Parameters:
    ///   - actions: 滑动操作
    ///   - position: 操作位置
    func addSwipeActions(_ actions: [UIContextualAction], position: UICollectionView.SwipeActionsConfiguration.Position) {
        interactionManager.addSwipeActions(actions, position: position)
    }
    
    /// 清除滑动操作
    func clearSwipeActions() {
        interactionManager.clearSwipeActions()
    }
    
    /// 启用拖拽排序
    func enableDragDrop() {
        interactionManager.enableDragDrop(in: self)
    }
    
    /// 禁用拖拽排序
    func disableDragDrop() {
        interactionManager.disableDragDrop(in: self)
    }
    
    /// 启用滑动操作
    func enableSwipe() {
        interactionManager.enableSwipe()
    }
    
    /// 禁用滑动操作
    func disableSwipe() {
        interactionManager.disableSwipe()
    }
    
    /// 启用多选模式
    func enableMultiSelect() {
        interactionManager.enableMultiSelect(in: self)
    }
    
    /// 禁用多选模式
    func disableMultiSelect() {
        interactionManager.disableMultiSelect(in: self)
    }
    
    /// 获取选中的项目
    /// - Returns: 选中的项目索引路径数组
    func getSelectedItems() -> [IndexPath] {
        return indexPathsForSelectedItems ?? []
    }
    
    /// 选择所有项目
    func selectAllItems() {
        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
    }
    
    /// 取消选择所有项目
    func deselectAllItems() {
        for indexPath in indexPathsForSelectedItems ?? [] {
            deselectItem(at: indexPath, animated: false)
        }
    }
}

/// 拖拽排序扩展
extension HCollView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    /// 开始拖拽
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - itemsAt: 拖拽的项目索引路径
    ///   - session: 拖拽会话
    /// - Returns: 拖拽项
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPaths: [IndexPath]) -> [UIDragItem] {
        return indexPaths.map { indexPath in
            let itemProvider = NSItemProvider(object: "item")
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = indexPath
            return dragItem
        }
    }
    
    /// 放置
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - session: 拖拽会话
    ///   - destinationIndexPath: 目标索引路径
    /// - Returns: 放置协调器
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    /// 执行放置
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - session: 拖拽会话
    ///   - destinationIndexPath: 目标索引路径
    ///   - dropSessionDidUpdate: 放置会话更新
    /// - Returns: 放置协调器
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // 移动项目
                collectionView.performBatchUpdates {
                    // 这里应该更新数据源
                    // 示例：dataArray.move(from: sourceIndexPath.item, to: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}

/// 滑动操作扩展
extension HCollView: UICollectionViewDelegateFlowLayout {
    
    /// 滑动操作配置
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - indexPath: 索引路径
    /// - Returns: 滑动操作配置
    func collectionView(_ collectionView: UICollectionView, leadingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = interactionManager.swipeActionsConfig.leadingActions
        if !actions.isEmpty {
            return UISwipeActionsConfiguration(actions: actions)
        }
        return nil
    }
    
    /// 滑动操作配置
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - indexPath: 索引路径
    /// - Returns: 滑动操作配置
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = interactionManager.swipeActionsConfig.trailingActions
        if !actions.isEmpty {
            return UISwipeActionsConfiguration(actions: actions)
        }
        return nil
    }
}
