//
//  HRegisterController+SJ.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc
    func tuple1_numberOfSectionsInTupleView() -> Any {
        return 3
    }
    @objc
    func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return 5
        case 2: return 1
        default: return 0
        }
    }
    @objc
    func tuple1_sizeForHeaderInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return CGSize(width: self.tupleView.width, height: 5)
        case 2: return CGSize.zero
        default: return CGSize.zero
        }
    }
    @objc
    func tuple1_sizeForFooterInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return CGSize(width: tupleView.width, height: 15)
        case 2: return CGSize.zero
        default:return CGSize.zero
        }
    }
    @objc
    func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
        case 1:
            if (indexPath.row == 0) {
                return CGSize(width: tupleView.width, height: 55)
            }else if (indexPath.row == 3) {
                return CGSize(width: tupleView.width - 100, height: 55)
            }else if (indexPath.row == 4) {
                return CGSize(width: 100, height: 55)
            }
            return CGSize(width: tupleView.width, height: 55)
        case 2: return CGSize(width: tupleView.width, height: 55)
        default: return CGSize.zero
        }
    }

    @objc
    func tuple1_edgeInsetsForHeaderInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc
    func tuple1_edgeInsetsForFooterInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc
    func tuple1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
        case 2: return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        default: return UIEdgeInsetsZero
        }
    }

    @objc
    func tuple1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }

    @objc
    func tuple1_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = (headerBlock as! HTupleHeader)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc
    func tuple1_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        _ = (footerBlock as! HTupleFooter)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc
    func tuple1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleTextFieldCell.self, "tuple1", true) as! HTupleTextFieldCell
        cell.textField.backgroundColor = UIColor(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "+86"

        cell.textField.textColor = UIColor(hex: "#BABABF")
        cell.textField.font = UIFont.systemFont(ofSize: 14)
        
        cell.textField.text = self.tupleView.object(forKey: "state", state: 1) as? String

        cell.signalBlock = { (target, signal) in
            let cell = target as! HTupleTextFieldCell
            NSLog("选中%d", cell)
        }
    }

}
