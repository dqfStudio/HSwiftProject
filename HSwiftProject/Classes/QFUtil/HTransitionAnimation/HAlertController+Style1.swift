//
//  HAlertController+Style1.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAlertController {
    @objc
    func tuple1_numberOfSectionsInTupleView() -> Any {
        return 1
    }
    @objc
    func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        return 4
    }
    @objc
    func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case 0:
            return CGSize(width: self.tupleView.width, height: 101)
        case 1:
            return CGSize(width: self.tupleView.width, height: 1)
        case 2:
            return CGSize(width: self.tupleView.width / 2, height: 48)
        case 3:
            return CGSize(width: self.tupleView.width / 2, height: 48)
        default:
            return CGSize(width: self.tupleView.width, height: 50)
        }
    }
    @objc
    func tuple1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {       
        switch indexPath.row {
        case 0:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = self.alertModel.message
        case 1:
            let cell = tuple.cell(HTupleBaseCell.self, nil, true, indexPath) as! HTupleBaseCell
            cell.backgroundColor = HColorHex("#F7F8FA")
        case 2:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = self.alertModel.cancel
            // 添加间隔线
            var bounds = cell.layoutViewBounds
            bounds = CGRect(x: bounds.width - 1, y: 0, width: 1, height: bounds.height)
            cell.label.addSubLayer(withFrame: bounds, color: HColorHex("#F7F8FA"))
            cell.selectBlock = {
                self.cancelBlock?()
            }
        case 3:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#3879FC")
            cell.label.text = self.alertModel.confirm
            cell.selectBlock = {
                self.cancelBlock?()
            }
        default:
            break
        }
    }
}
