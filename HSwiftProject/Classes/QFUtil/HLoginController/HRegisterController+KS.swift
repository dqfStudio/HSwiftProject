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
        return 2
    }
    @objc
    func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tuple0_sizeForHeaderInSection(_ section: Any) -> Any {
        return CGSize(width: self.tupleView.width, height: 5)
    }
    @objc
    func tuple0_sizeForFooterInSection(_ section: Any) -> Any {
        return CGSize(width: tupleView.width, height: 15)
    }
    @objc
    func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: tupleView.width, height: 55)
    }

    @objc
    func tuple0_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(HTupleBaseApex.self, nil, false) as! HTupleBaseApex
        cell.backgroundColor = .red
    }
    @objc
    func tuple0_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        let footerBlock = footerBlock as! HTupleFooter
        let cell = footerBlock(HTupleBaseApex.self, nil, false) as! HTupleBaseApex
        cell.backgroundColor = .blue
    }
    @objc
    func tuple0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleFieldCell.self, "tuple0", true) as! HTupleFieldCell
        cell.textField.backgroundColor = UIColor(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "昵称"

        cell.textField.textColor = UIColor(hex: "#BABABF")
        cell.textField.font = .systemFont(ofSize: 14.0)
        cell.textField.text = self.tupleView.object(forKey: "state", state: 0) as? String

        cell.signalBlock = { (target, signal) in
            let cell = target as! HTupleFieldCell
            NSLog("选中%d", cell)
        }
    }

}
