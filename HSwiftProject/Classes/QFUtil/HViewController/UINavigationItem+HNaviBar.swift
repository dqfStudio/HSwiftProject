//
//  UINavigationItem+HNaviBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

// MARK: - Associated Objects

private var kHVCNaviLeftItemKey: Void?
private var kHVCNaviTitleItemKey: Void?
private var kHVCNaviRightItemKey: Void?

// MARK: - UINavigationItem Extension

extension UINavigationItem {
    
    // MARK: - Private Methods
    
    /// 创建或获取关联对象
    private func createOrGetAssociatedObject<T: UIView>(key: UnsafeRawPointer, creationBlock: () -> T, setupBlock: (T) -> Void) -> T {
        if let associatedObject = getAssociatedValueForKey(key) as? T {
            return associatedObject
        }
        let object = creationBlock()
        setupBlock(object)
        setAssociateValue(object, key: key)
        return object
    }
    
    // MARK: - Properties
    
    /// 左侧导航项
    var leftItem: HNavigationItem {
        return createOrGetAssociatedObject(key: &kHVCNaviLeftItemKey) {
            let buttonView = HNavigationItem(frame: .zero)
            buttonView.titleLabel?.font = UIFont.font(ofSize: 17, weight: .medium)
            buttonView.contentHorizontalAlignment = .left
            buttonView.textColor = .black
            return buttonView
        } setupBlock: { [weak self] buttonView in
            self?.leftBarButtonItem = UIBarButtonItem(customView: buttonView)
        }
    }
    
    /// 标题项
    var titleItem: UILabel {
        return createOrGetAssociatedObject(key: &kHVCNaviTitleItemKey) {
            let labelView = UILabel(frame: .zero)
            labelView.font = UIFont.font(ofSize: 17, weight: .medium)
            labelView.textColor = .white
            labelView.textAlignment = .center
            return labelView
        } setupBlock: { [weak self] labelView in
            self?.titleView = labelView
        }
    }
    
    /// 右侧导航项
    var rightItem: HNavigationItem {
        return createOrGetAssociatedObject(key: &kHVCNaviRightItemKey) {
            let buttonView = HNavigationItem(frame: .zero)
            buttonView.titleLabel?.font = UIFont.font(ofSize: 17, weight: .medium)
            buttonView.contentHorizontalAlignment = .right
            buttonView.textColor = .black
            return buttonView
        } setupBlock: { [weak self] buttonView in
            self?.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        }
    }
}
