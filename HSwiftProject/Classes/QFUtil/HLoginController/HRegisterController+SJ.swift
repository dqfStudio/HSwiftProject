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
        return 2
    }
    @objc
    func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: tupleView.width, height: 55)
    }

    @objc
    func tuple1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleFieldCell.self, "tuple1", true) as! HTupleFieldCell
        cell.textField.backgroundColor = UIColor(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "+86"

        cell.textField.textColor = UIColor(hex: "#BABABF")
        cell.textField.font = .systemFont(ofSize: 14.0)
        
        cell.textField.text = self.tupleView.object(forKey: "state", state: 1) as? String

        cell.signalBlock = { (target, signal) in
            let cell = target as! HTupleFieldCell
            NSLog("选中%d", cell)
        }
    }

}
