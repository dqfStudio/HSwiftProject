//
//  HFlowView+Utils.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Utility Methods
extension HFlowView {
    
    /// 滚动到顶部
    /// - Parameter animated: 是否带动画
    func scrollToTop(animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)
        if numberOfSections > 0 && numberOfRows(inSection: 0) > 0 {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        } else {
            setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
        }
    }
    
    /// 滚动到底部
    /// - Parameter animated: 是否带动画
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        let lastRow = numberOfRows(inSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    /// 滚动到指定索引路径
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - position: 滚动位置
    ///   - animated: 是否带动画
    func scrollToIndexPath(_ indexPath: IndexPath, at position: UITableView.ScrollPosition = .middle, animated: Bool = true) {
        if indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section) {
            scrollToRow(at: indexPath, at: position, animated: animated)
        }
    }
    
    /// 获取可见的索引路径
    /// - Returns: 可见的索引路径数组
    func visibleIndexPaths() -> [IndexPath] {
        return indexPathsForVisibleRows ?? []
    }
    
    /// 获取可见的 cell（直接使用 UITableView 的 visibleCells 属性）
    /// - Returns: 可见的 cell 数组
    func getVisibleCellsList() -> [UITableViewCell] {
        return self.visibleCells
    }
    
    /// 根据索引路径获取 cell
    /// - Parameter indexPath: 索引路径
    /// - Returns: UITableViewCell 实例
    func cellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell? {
        return cellForRow(at: indexPath)
    }
    
    /// 计算内容高度
    /// - Returns: 内容高度
    func calculateContentHeight() -> CGFloat {
        var height: CGFloat = 0
        for section in 0..<numberOfSections {
            // 计算 section header 高度
            if let headerHeight = delegate?.tableView?(self, heightForHeaderInSection: section) {
                height += headerHeight
            }
            // 计算 rows 高度
            for row in 0..<numberOfRows(inSection: section) {
                if let rowHeight = delegate?.tableView?(self, heightForRowAt: IndexPath(row: row, section: section)) {
                    height += rowHeight
                }
            }
            // 计算 section footer 高度
            if let footerHeight = delegate?.tableView?(self, heightForFooterInSection: section) {
                height += footerHeight
            }
        }
        return height
    }
    
    /// 检查索引路径是否有效
    /// - Parameter indexPath: 索引路径
    /// - Returns: 是否有效
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}

// MARK: - IndexPath Extension
extension IndexPath {
    
    /// 将 IndexPath 转换为字符串
    var stringValue: String {
        return "\(section)-\(row)"
    }
    
    /// 从字符串创建 IndexPath
    /// - Parameter string: 字符串，格式为 "section-row"
    /// - Returns: IndexPath 实例
    static func fromString(_ string: String) -> IndexPath? {
        let components = string.split(separator: "-")
        if components.count == 2, let section = Int(components[0]), let row = Int(components[1]) {
            return IndexPath(row: row, section: section)
        }
        return nil
    }
}
