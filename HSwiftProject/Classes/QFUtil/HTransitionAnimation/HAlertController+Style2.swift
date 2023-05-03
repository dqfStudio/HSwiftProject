//
//  HAlertController+Style2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAlertController {
    @objc
    func tuple2_numberOfSectionsInTupleView() -> Any {
        return 1
    }
    @objc
    func tuple2_numberOfItemsInSection(_ section: Any) -> Any {
        return 4
    }
    @objc
    func tuple2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case HCell0:
            return CGSize(width: self.tupleView.width, height: 60)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: 60)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 1)
        case HCell3:
            return CGSize(width: self.tupleView.width, height: 48)
        default:
            break
        }
        return CGSize.zero
    }
    @objc
    func tuple2_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsets(top: 24, left: 24, bottom: 12, right: 24)
        case HCell1:
            return UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)
        case HCell2, HCell3:
            return UIEdgeInsets.zero
        default:
            break
        }
        return UIEdgeInsets.zero
    }
    @objc
    func tuple2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch indexPath.row {
        case HCell0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = alertModel.title
        case HCell1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = alertModel.message
        case HCell2:
            let cell = itemBlock(nil, HTupleBlankCell.self, nil, true) as! HTupleBlankCell
            cell.blank.backgroundColor = HColorHex("#F7F8FA")
        case HCell3:
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
    func tuple2_didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        if indexPath.row == HCell3 {
            confirmBlock?()
        }
    }
}
