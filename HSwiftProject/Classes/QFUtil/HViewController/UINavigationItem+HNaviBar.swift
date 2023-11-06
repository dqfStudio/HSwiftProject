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
    
    var leftItem: HNavigationItem {
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
        buttonView.addTarget(self, action: #selector(leftItemPressed))
        self.setAssociateValue(buttonView, key: &kHVCNaviLeftItemKey)
        self.leftBarButtonItem = UIBarButtonItem(customView: buttonView)
        return buttonView
    }
    
    var titleItem: UILabel {
        if let titleItem = self.getAssociatedValueForKey(&kHVCNaviTitleItemKey) as? UILabel {
            return titleItem
        }
        let labelView = UILabel(frame: .zero)
        labelView.font = UIFont.font(ofSize: 17, weight: .medium)
        labelView.textColor = UIColor.black
        labelView.textAlignment = .center
        self.setAssociateValue(labelView, key: &kHVCNaviTitleItemKey)
        self.titleView = labelView
        return labelView
    }
    
    var rightItem: HNavigationItem {
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
        buttonView.addTarget(self, action: #selector(rightItemPressed))
        self.setAssociateValue(buttonView, key: &kHVCNaviRightItemKey)
        self.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        return buttonView
    }
    
    @objc
    private func leftItemPressed() {
        leftItem.pressedBlock?()
    }
    
    @objc
    private func rightItemPressed() {
        rightItem.pressedBlock?()
    }

}
