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
    
    private func createOrGetAssociatedObject<T: UIView>(
        key: UnsafeRawPointer,
        creationBlock: () -> T,
        setupBlock: (T) -> Void
    ) -> T {
        if let associatedObject = getAssociatedValueForKey(key) as? T {
            return associatedObject
        }
        let object = creationBlock()
        setupBlock(object)
        setAssociateValue(object, key: key)
        return object
    }
    
    private func makeBarButtonItem(customView: UIView) -> UIBarButtonItem {
        // UIBarButtonItem 的 customView 不要再加宽高约束，会和导航栏内部约束冲突。
        customView.translatesAutoresizingMaskIntoConstraints = true
        if customView.bounds.width < 44 || customView.bounds.height < 44 {
            customView.bounds.size = CGSize(
                width: max(customView.bounds.width, 44),
                height: max(customView.bounds.height, 44)
            )
        }
        return UIBarButtonItem(customView: customView)
    }
    
    private func makeItemButton(alignment: UIControl.ContentHorizontalAlignment) -> HNavigationItem {
        let buttonView = HNavigationItem(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        buttonView.titleLabel?.font = UIFont.font(ofSize: 17, weight: .medium)
        buttonView.contentHorizontalAlignment = alignment
        buttonView.textColor = .black
        return buttonView
    }
    
    // MARK: - Properties
    
    /// 左侧导航项
    var leftItem: HNavigationItem {
        let buttonView = createOrGetAssociatedObject(key: &kHVCNaviLeftItemKey) {
            makeItemButton(alignment: .left)
        } setupBlock: { [weak self] buttonView in
            self?.leftBarButtonItem = self?.makeBarButtonItem(customView: buttonView)
        }
        if leftBarButtonItem?.customView !== buttonView {
            leftBarButtonItem = makeBarButtonItem(customView: buttonView)
        }
        return buttonView
    }
    
    /// 标题项（会替换系统 title。普通标题请用 `navigationItem.title`）
    var titleItem: UILabel {
        let labelView: UILabel = createOrGetAssociatedObject(key: &kHVCNaviTitleItemKey) {
            let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 44))
            labelView.font = UIFont.font(ofSize: 17, weight: .medium)
            labelView.textColor = .black
            labelView.textAlignment = .center
            labelView.adjustsFontSizeToFitWidth = true
            labelView.minimumScaleFactor = 0.8
            return labelView
        } setupBlock: { [weak self] labelView in
            self?.titleView = labelView
        }
        if titleView !== labelView {
            titleView = labelView
        }
        return labelView
    }
    
    /// 右侧导航项
    var rightItem: HNavigationItem {
        let buttonView = createOrGetAssociatedObject(key: &kHVCNaviRightItemKey) {
            makeItemButton(alignment: .right)
        } setupBlock: { [weak self] buttonView in
            self?.rightBarButtonItem = self?.makeBarButtonItem(customView: buttonView)
        }
        if rightBarButtonItem?.customView !== buttonView {
            rightBarButtonItem = makeBarButtonItem(customView: buttonView)
        }
        return buttonView
    }
}
