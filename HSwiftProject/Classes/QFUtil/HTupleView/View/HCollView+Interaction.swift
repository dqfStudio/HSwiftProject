//
//  HCollView+Interaction.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 交互扩展
///
/// 提供拖拽排序、滑动操作、多选模式等交互功能
extension HCollView {
    
    // MARK: - 拖拽排序
    
    /// 启用拖拽排序
    /// - Parameter handler: 拖拽完成回调
    func enableDragAndDrop(_ handler: @escaping (IndexPath, IndexPath) -> Void) {
        if #available(iOS 11.0, *) {
            dragInteractionEnabled = true
        }
    }
    
    /// 禁用拖拽排序
    func disableDragAndDrop() {
        if #available(iOS 11.0, *) {
            dragInteractionEnabled = false
        }
    }
    
    // MARK: - 滑动操作
    
    /// 滑动操作类型
    enum SwipeActionType {
        case delete
        case edit
        case custom(title: String, backgroundColor: UIColor, handler: () -> Void)
    }
    
    /// 启用左滑操作
    /// - Parameter actions: 滑动操作数组
    func enableLeftSwipeActions(_ actions: [SwipeActionType]) {
        // 这里需要实现左滑操作
        // 可以使用 UISwipeActionsConfiguration 或第三方库
    }
    
    /// 启用右滑操作
    /// - Parameter actions: 滑动操作数组
    func enableRightSwipeActions(_ actions: [SwipeActionType]) {
        // 这里需要实现右滑操作
        // 可以使用 UISwipeActionsConfiguration 或第三方库
    }
    
    // MARK: - 多选模式
    
    /// 多选模式状态
    var isMultiSelectMode: Bool {
        get {
            return objc_getAssociatedObject(self, &multiSelectModeKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &multiSelectModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateMultiSelectMode()
        }
    }
    
    /// 选中的 indexPath 集合
    var selectedIndexPaths: Set<IndexPath> {
        get {
            return objc_getAssociatedObject(self, &selectedIndexPathsKey) as? Set<IndexPath> ?? []
        }
        set {
            objc_setAssociatedObject(self, &selectedIndexPathsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 多选模式回调
    var multiSelectHandler: ((Set<IndexPath>) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &multiSelectHandlerKey) as? ((Set<IndexPath>) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &multiSelectHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 进入多选模式
    func enterMultiSelectMode(_ handler: ((Set<IndexPath>) -> Void)?) {
        isMultiSelectMode = true
        multiSelectHandler = handler
    }
    
    /// 退出多选模式
    func exitMultiSelectMode() {
        isMultiSelectMode = false
        selectedIndexPaths.removeAll()
        multiSelectHandler = nil
        (self as UICollectionView).reloadData()
    }
    
    /// 切换选中状态
    /// - Parameter indexPath: 要切换的 indexPath
    func toggleSelection(at indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
        } else {
            selectedIndexPaths.insert(indexPath)
        }
        
        // 刷新选中的 cell
        (self as UICollectionView).reloadItems(at: [indexPath])
        
        // 回调
        multiSelectHandler?(selectedIndexPaths)
    }
    
    /// 全选
    func selectAll() {
        selectedIndexPaths.removeAll()
        
        let sections = numberOfSections
        for section in 0..<sections {
            let items = numberOfItems(inSection: section)
            for item in 0..<items {
                selectedIndexPaths.insert(IndexPath(item: item, section: section))
            }
        }
        
        (self as UICollectionView).reloadData()
        multiSelectHandler?(selectedIndexPaths)
    }
    
    /// 取消全选
    func deselectAll() {
        selectedIndexPaths.removeAll()
        (self as UICollectionView).reloadData()
        multiSelectHandler?(selectedIndexPaths)
    }
    
    /// 更新多选模式
    private func updateMultiSelectMode() {
        // 根据多选模式状态更新 UI
        (self as UICollectionView).reloadData()
    }
    
    // MARK: - 分组展开/折叠
    
    /// 展开的 section 集合
    var expandedSections: Set<Int> {
        get {
            return objc_getAssociatedObject(self, &expandedSectionsKey) as? Set<Int> ?? Set(0..<numberOfSections)
        }
        set {
            objc_setAssociatedObject(self, &expandedSectionsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 切换 section 展开/折叠状态
    /// - Parameter section: 要切换的 section
    func toggleSection(_ section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        
        // 刷新 section
        reloadSections(IndexSet(integer: section))
    }
    
    /// 展开所有 section
    func expandAllSections() {
        expandedSections = Set(0..<numberOfSections)
        (self as UICollectionView).reloadData()
    }
    
    /// 折叠所有 section
    func collapseAllSections() {
        expandedSections.removeAll()
        (self as UICollectionView).reloadData()
    }
    
    /// 检查 section 是否展开
    /// - Parameter section: 要检查的 section
    /// - Returns: 是否展开
    func isSectionExpanded(_ section: Int) -> Bool {
        return expandedSections.contains(section)
    }
}

// 关联对象键
private var multiSelectModeKey: UInt8 = 0
private var selectedIndexPathsKey: UInt8 = 0
private var multiSelectHandlerKey: UInt8 = 0
private var expandedSectionsKey: UInt8 = 0

// MARK: - UICollectionViewDragDelegate (additional methods)
@available(iOS 11.0, *)
extension HCollView {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 实现拖拽开始时的逻辑
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        // 自定义拖拽预览
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }
}

// MARK: - UICollectionViewDropDelegate (additional methods)
@available(iOS 11.0, *)
extension HCollView {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
}
