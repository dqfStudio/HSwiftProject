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
    func tuple0_tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.header(HTupleBaseApex.self, nil, false, indexPath) as! HTupleBaseApex
        cell.backgroundColor = .red
    }
    @objc
    func tuple0_tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.footer(HTupleBaseApex.self, nil, false, indexPath) as! HTupleBaseApex
        cell.backgroundColor = .blue
    }
    @objc
    func tuple0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {        
        let cell = tuple.cell(HTupleFieldCell.self, "tuple0", true, indexPath) as! HTupleFieldCell
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
