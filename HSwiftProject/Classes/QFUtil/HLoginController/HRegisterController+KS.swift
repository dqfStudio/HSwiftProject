//
//  HRegisterController+KS.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }
    @objc
    func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return 6
        case 2: return 1
        default: return 0
        }
    }
    @objc
    func tuple0_sizeForHeaderInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return CGSize(width: self.tupleView.width, height: 5)
        case 2: return CGSize.zero
        default: return CGSize.zero
        }
    }
    @objc
    func tuple0_sizeForFooterInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 1: return CGSize(width: tupleView.width, height: 15)
        case 2: return CGSize.zero
        default:return CGSize.zero
        }
    }
    @objc
    func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
        case 1: return CGSize(width: tupleView.width, height: 55)
        case 2: return CGSize(width: tupleView.width, height: 55)
        default: return CGSize.zero
        }
    }

    @objc
    func tuple0_edgeInsetsForHeaderInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc
    func tuple0_edgeInsetsForFooterInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc
    func tuple0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
        case 2: return UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        default: return UIEdgeInsetsZero
        }
    }

    @objc
    func tuple0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }

    @objc
    func tuple0_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = (headerBlock as! HTupleHeader)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc
    func tuple0_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        _ = (footerBlock as! HTupleFooter)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc
    func tuple0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleTextFieldCell.self, "tuple0", true) as! HTupleTextFieldCell
        cell.textField.backgroundColor = UIColor(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "昵称"

        cell.textField.textColor = UIColor(hex: "#BABABF")
        cell.textField.font = UIFont.systemFont(ofSize: 14)
        cell.textField.text = self.tupleView.objectForKey("state", state: 0) as? String

        cell.signalBlock = { (target, signal) in
            let cell = target as! HTupleTextFieldCell
            NSLog("选中%d", cell)
        }
    }

}
