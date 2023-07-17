//
//  UIViewController+HNavigationBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var kHVCNaviLeftItemKey = "kHVCNaviLeftItemKey"
private var kHVCNaviRightItemKey = "kHVCNaviRightItemKey"

extension UIViewController {
    
    var leftNaviItem: HNavigationItem {
        if let leftItem = self.getAssociatedValueForKey(&kHVCNaviLeftItemKey) as? HNavigationItem {
            return leftItem
        }
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .left
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = .black
        buttonView.addTarget(self, action: #selector(leftNaviItemPressed))
        self.setAssociateValue(buttonView, key: &kHVCNaviLeftItemKey)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonView)
        return buttonView
    }
    
    var rightNaviItem: HNavigationItem {
        if let rightItem = self.getAssociatedValueForKey(&kHVCNaviRightItemKey) as? HNavigationItem {
            return rightItem
        }
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .right
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = .black
        buttonView.addTarget(self, action: #selector(rightNaviItemPressed))
        self.setAssociateValue(buttonView, key: &kHVCNaviRightItemKey)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        return buttonView
    }
    
    @objc
    private func leftNaviItemPressed() {
        leftNaviItem.pressedBlock?()
    }
    
    @objc
    private func rightNaviItemPressed() {
        rightNaviItem.pressedBlock?()
    }

}
