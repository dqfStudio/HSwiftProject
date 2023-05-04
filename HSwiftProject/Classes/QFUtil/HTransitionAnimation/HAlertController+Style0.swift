//
//  HAlertController+HAlert.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAlertController {
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 1
    }
    @objc
    func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case HCell0:
            return CGSize(width: self.tupleView.width, height: 101)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: 1)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 48)
        default:
            break
        }
        return CGSize.zero
    }
    @objc
    func tuple0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        case HCell1, HCell2:
            return UIEdgeInsets.zero
        default:
            break
        }
        return UIEdgeInsets.zero
    }
    @objc
    func tuple0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch indexPath.row {
        case HCell0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = alertModel.message
        case HCell1:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = HColorHex("#F7F8FA")
        case HCell2:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#3879FC")
            cell.label.text = alertModel.confirm
        default:
            break
        }
    }
    @objc
    func tuple0_didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        if indexPath.row == HCell2 {
            confirmBlock?()
        }
    }
}
