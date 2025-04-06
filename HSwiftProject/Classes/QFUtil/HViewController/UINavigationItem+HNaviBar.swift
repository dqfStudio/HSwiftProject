//
//  HNavigationBar3.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var kHVCNaviLeftItemKey: Void?
private var kHVCNaviTitleItemKey: Void?
private var kHVCNaviRightItemKey: Void?

extension UINavigationItem {
    
    // 创建和设置关联对象
    private func createOrGetAssociatedObject<T: UIView>(key: UnsafeRawPointer, creationBlock: () -> T, setupBlock: (T) -> Void) -> T {
        if let associatedObject = self.getAssociatedValueForKey(key) as? T {
            return associatedObject
        }
        let object = creationBlock()
        setupBlock(object)
        self.setAssociateValue(object, key: key)
        return object
    }
    
    var leftItem: HNavigationItem {
        return createOrGetAssociatedObject(key: &kHVCNaviLeftItemKey) {
            let buttonView = HNavigationItem(frame: .zero)
            //buttonView.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            buttonView.titleLabel?.font = UIFont.font(ofSize: 17, weight: .medium)
            buttonView.contentHorizontalAlignment = .left
            buttonView.textColor = .black
            return buttonView
        } setupBlock: { [weak self] buttonView in
            self?.leftBarButtonItem = UIBarButtonItem(customView: buttonView)
        }
    }
    
    var titleItem: UILabel {
        return createOrGetAssociatedObject(key: &kHVCNaviTitleItemKey) {
            let labelView = UILabel(frame: .zero)
            labelView.font = UIFont.font(ofSize: 17, weight: .medium)
            labelView.textColor = UIColor.white
            labelView.textAlignment = .center
            return labelView
        } setupBlock: { [weak self] labelView in
            self?.titleView = labelView
        }
    }
    
    var rightItem: HNavigationItem {
        return createOrGetAssociatedObject(key: &kHVCNaviRightItemKey) {
            let buttonView = HNavigationItem(frame: .zero)
            //buttonView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
            buttonView.titleLabel?.font = UIFont.font(ofSize: 17, weight: .medium)
            buttonView.contentHorizontalAlignment = .right
            buttonView.textColor = .black
            return buttonView
        } setupBlock: { [weak self] buttonView in
            self?.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        }
    }
}
