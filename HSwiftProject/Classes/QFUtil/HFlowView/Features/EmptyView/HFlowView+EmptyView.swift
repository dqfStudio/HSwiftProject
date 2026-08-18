//
//  HFlowView+EmptyView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  无数据时用 backgroundView 显示空态，随 reloadData / bounds 变化更新。
//

import UIKit

private var hflowEmptyViewEnabledKey: UInt8 = 0

extension HFlowView {

    var emptyViewEnabled: Bool {
        get { (objc_getAssociatedObject(self, &hflowEmptyViewEnabledKey) as? NSNumber)?.boolValue ?? true }
        set {
            objc_setAssociatedObject(self, &hflowEmptyViewEnabledKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateEmptyViewVisibility()
        }
    }

    /// 无数据时显示。走 `backgroundView`，不要再 `insertSubview`。
    var emptyView: UIView? {
        get {
            backgroundView?.tag == Constants.emptyViewTag ? backgroundView : nil
        }
        set {
            if backgroundView?.tag == Constants.emptyViewTag {
                backgroundView = nil
            }
            if let newView = newValue {
                newView.tag = Constants.emptyViewTag
                newView.frame = bounds
                backgroundView = newView
                newView.isHidden = true
                updateEmptyViewVisibility()
            }
        }
    }

    internal func updateEmptyViewFrame() {
        emptyView?.frame = bounds
    }

    func updateEmptyViewVisibility() {
        guard emptyViewEnabled else {
            emptyView?.isHidden = true
            return
        }

        var hasData = false
        for section in 0..<numberOfSections {
            if numberOfRows(inSection: section) > 0 {
                hasData = true
                break
            }
        }
        emptyView?.isHidden = hasData
    }

    /// Core `layoutSubviews` 钩子，选择器名勿改。
    @objc func hflow_empty_layoutSubviews() {
        updateEmptyViewFrame()
    }

    /// Core `reloadData` 钩子，选择器名勿改。
    @objc func hflow_empty_reloadData() {
        updateEmptyViewVisibility()
    }

    /// Config 钩子，选择器名勿改。
    @objc func hflow_config_applyEmpty(_ enabled: NSNumber) {
        emptyViewEnabled = enabled.boolValue
    }
}
