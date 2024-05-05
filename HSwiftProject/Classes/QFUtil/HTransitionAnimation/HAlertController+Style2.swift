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
        case 0:
            return CGSize(width: self.tupleView.width, height: 60)
        case 1:
            return CGSize(width: self.tupleView.width, height: 60)
        case 2:
            return CGSize(width: self.tupleView.width, height: 1)
        case 3:
            return CGSize(width: self.tupleView.width, height: 48)
        default:
            return CGSize(width: self.tupleView.width, height: 50)
        }
    }
    @objc
    func tuple2_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {        
        switch indexPath.row {
        case 0:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.edgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 12, right: 24)
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = self.alertModel.title
        case 1:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.edgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#17191E")
            cell.label.text = self.alertModel.message
        case 2:
            let cell = tuple.cell(HTupleBaseCell.self, nil, true, indexPath) as! HTupleBaseCell
            cell.backgroundColor = HColorHex("#F7F8FA")
        case 3:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#3879FC")
            cell.label.text = self.alertModel.confirm
            cell.selectBlock = {
                self.confirmBlock?()
            }
        default:
            break
        }
    }
}
