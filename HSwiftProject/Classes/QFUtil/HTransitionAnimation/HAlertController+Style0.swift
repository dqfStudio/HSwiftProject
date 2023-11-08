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
    func tuple0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch indexPath.row {
        case HCell0:
            let cell = itemBlock(HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.sizeBlock = {
                return CGSize(width: self.tupleView.width, height: 101)
            }
            cell.edgeInsetsBlock = {
                return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            }
            cell.cellBlock = {
                cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 0
                cell.label.textColor = HColorHex("#17191E")
                cell.label.text = self.alertModel.message
            }
        case HCell1:
            let cell = itemBlock(HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = HColorHex("#F7F8FA")
            cell.sizeBlock = {
                return CGSize(width: self.tupleView.width, height: 1)
            }
        case HCell2:
            let cell = itemBlock(HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.sizeBlock = {
                return CGSize(width: self.tupleView.width, height: 48)
            }
            cell.cellBlock = {
                cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
                cell.label.textAlignment = .center
                cell.label.textColor = HColorHex("#3879FC")
                cell.label.text = self.alertModel.confirm
            }
            cell.selectBlock = {
                self.confirmBlock?()
            }
        default:
            break
        }
    }
}
