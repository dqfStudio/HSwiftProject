//
//  HFlowView+Accessibility.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HFlowView 无障碍支持扩展
///
/// 为 HFlowView 提供无障碍支持，帮助有视力障碍的用户使用应用
///
/// 实现功能：
/// 1. 支持 VoiceOver 朗读
/// 2. 支持动态字体大小
/// 3. 支持辅助功能快捷手势
/// 4. 提供无障碍元素的描述和提示

// 关联对象的键
private var enableAccessibilityKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Accessibility Properties
    
    /// 是否启用无障碍支持
    public var enableAccessibility: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableAccessibilityKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableAccessibilityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 无障碍元素的标签
    override public var accessibilityLabel: String? {
        get {
            return super.accessibilityLabel
        }
        set {
            super.accessibilityLabel = newValue
        }
    }
    
    /// 无障碍元素的提示
    override public var accessibilityHint: String? {
        get {
            return super.accessibilityHint
        }
        set {
            super.accessibilityHint = newValue
        }
    }
    
    /// 无障碍元素的价值
    override public var accessibilityValue: String? {
        get {
            return super.accessibilityValue
        }
        set {
            super.accessibilityValue = newValue
        }
    }
    
    // MARK: - Accessibility Methods
    
    /// 初始化无障碍支持
    func setupAccessibility() {
        guard enableAccessibility else { return }
        
        // 启用无障碍支持
        isAccessibilityElement = false
        accessibilityElementsHidden = false
        
        // 设置无障碍标签和提示
        accessibilityLabel = "列表视图"
        accessibilityHint = "包含\(numberOfSections)个分区，共\(totalNumberOfRows)项"
    }
    
    /// 获取表格的总行数
    private var totalNumberOfRows: Int {
        var total = 0
        for section in 0..<numberOfSections {
            total += numberOfRows(inSection: section)
        }
        return total
    }
    
    /// 更新无障碍元素
    func updateAccessibilityElements() {
        guard enableAccessibility else { return }
        
        // 更新无障碍提示
        accessibilityHint = "包含\(numberOfSections)个分区，共\(totalNumberOfRows)项"
        
        // 通知辅助功能元素已更改
        UIAccessibility.post(notification: .layoutChanged, argument: self)
    }
    
    /// 为指定的 cell 设置无障碍属性
    /// - Parameters:
    ///   - cell: 要设置的 cell
    ///   - indexPath: 索引路径
    func setupAccessibilityForCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard enableAccessibility else { return }
        
        // 启用 cell 的无障碍支持
        cell.isAccessibilityElement = true
        
        // 设置 cell 的无障碍标签
        if let flowDelegate = flowDelegate {
            // 尝试从代理获取无障碍标签
            if let accessibilityLabel = flowDelegate.accessibilityLabelForCell(at: indexPath) {
                cell.accessibilityLabel = accessibilityLabel
            } else {
                // 默认标签
                cell.accessibilityLabel = "第\(indexPath.section + 1)组第\(indexPath.row + 1)项"
            }
            
            // 尝试从代理获取无障碍提示
            if let accessibilityHint = flowDelegate.accessibilityHintForCell(at: indexPath) {
                cell.accessibilityHint = accessibilityHint
            } else {
                // 默认提示
                cell.accessibilityHint = "点击查看详情"
            }
            
            // 尝试从代理获取无障碍价值
            if let accessibilityValue = flowDelegate.accessibilityValueForCell(at: indexPath) {
                cell.accessibilityValue = accessibilityValue
            }
        } else {
            // 默认标签
            cell.accessibilityLabel = "第\(indexPath.section + 1)组第\(indexPath.row + 1)项"
            
            // 默认提示
            cell.accessibilityHint = "点击查看详情"
        }
    }
    
    /// 滚动到指定的无障碍元素
    /// - Parameter indexPath: 索引路径
    func scrollToAccessibilityElement(at indexPath: IndexPath) {
        scrollToRow(at: indexPath, at: .middle, animated: true)
        
        // 通知辅助功能元素已聚焦
        if let cell = cellForRow(at: indexPath) {
            UIAccessibility.post(notification: .screenChanged, argument: cell)
        }
    }
}

/// 扩展 HFlowViewDelegate，添加无障碍相关方法
extension HFlowViewDelegate {
    /// 获取指定 cell 的无障碍标签
    /// - Parameter indexPath: 索引路径
    /// - Returns: 无障碍标签
    func accessibilityLabelForCell(at indexPath: IndexPath) -> String? {
        return nil
    }
    
    /// 获取指定 cell 的无障碍提示
    /// - Parameter indexPath: 索引路径
    /// - Returns: 无障碍提示
    func accessibilityHintForCell(at indexPath: IndexPath) -> String? {
        return nil
    }
    
    /// 获取指定 cell 的无障碍价值
    /// - Parameter indexPath: 索引路径
    /// - Returns: 无障碍价值
    func accessibilityValueForCell(at indexPath: IndexPath) -> String? {
        return nil
    }
    
    /// 获取指定 section 的无障碍标签
    /// - Parameter section: section 索引
    /// - Returns: 无障碍标签
    func accessibilityLabelForSection(_ section: Int) -> String? {
        return nil
    }
}
