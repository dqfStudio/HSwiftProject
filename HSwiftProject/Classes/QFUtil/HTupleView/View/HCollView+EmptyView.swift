//
//  HCollView+EmptyView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Empty View Management
extension HCollView {
    /// 更新空数据视图
    private func updateEmptyView() {
        // 移除旧的空视图
        subviews.forEach { view in
            if view.tag == HCollView.Constants.emptyViewTag {
                view.removeFromSuperview()
            }
        }
        
        // 添加新的空视图
        if let emptyView = emptyView {
            emptyView.tag = HCollView.Constants.emptyViewTag
            emptyView.frame = bounds
            addSubview(emptyView)
            emptyView.isHidden = true
        }
    }
    
    /// 显示或隐藏空数据视图
    func updateEmptyViewVisibility() {
        // 如果禁用了空数据视图，直接隐藏
        guard emptyViewEnabled else {
            emptyView?.isHidden = true
            return
        }
        
        let sections = numberOfSections
        var hasData = false
        
        for section in 0..<sections {
            if numberOfItems(inSection: section) > 0 {
                hasData = true
                break
            }
        }
        
        emptyView?.isHidden = hasData
    }
    
}
