//
//  HLoginController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HLoginController: HViewController, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.origin.y += UIScreen.topBarHeight
        frame.size.height -= UIScreen.topBarHeight + (UIScreen.bottomBarHeight + 10)
        return HTupleView(frame: frame)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.leftItem.isHidden = true
        self.title = "登录"
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }

    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 5
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case 0:return CGSize(width: self.tupleView.width, height: 60)
        case 1:return CGSize(width: self.tupleView.width, height: 60)
        case 2:return CGSize(width: self.tupleView.width, height: 60)
        case 3:return CGSize(width: self.tupleView.width, height: 40)
        case 4:return CGSize(width: self.tupleView.width, height: 45)
        default:return CGSize.zero
        }
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        case 1:return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        case 2:return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        case 3:return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        case 4:return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        default:return UIEdgeInsets.zero
        }
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {    
        switch (indexPath.row) {
        case 0:
            let cell = tuple.reuseCell(HTupleFieldCell.self, nil, true, indexPath) as! HTupleFieldCell
            cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

            cell.textField.leftWidth = 80
            cell.textField.leftLabel.textAlignment = .center
            cell.textField.leftLabel.text = "+86"

            cell.textField.placeholder = "请输入手机号"
            cell.textField.textColor = UIColor(hex:"#BABABF")
            cell.textField.font = .systemFont(ofSize: 14.0)
            //cell.textField.inputValidator = HPhoneValidator.new

            cell.signalBlock = { (target, signal) in
                let cell = target as! HTupleFieldCell
                NSLog("选中%d", cell)
            }
        case 1:
            let cell = tuple.reuseCell(HTupleFieldCell.self, nil, true, indexPath) as! HTupleFieldCell
            cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

            cell.textField.leftWidth = 80
            cell.textField.leftLabel.textAlignment = .center
            cell.textField.leftLabel.text = "昵称"

            cell.textField.placeholder = "请输入昵称"
            cell.textField.textColor = UIColor(hex:"#BABABF")
            cell.textField.font = .systemFont(ofSize: 14.0)

            cell.signalBlock = { (target, signal) in
                let cell = target as! HTupleFieldCell
                NSLog("选中%d", cell)
            }
        case 2:
            let cell = tuple.reuseCell(HTupleFieldCell.self, nil, true, indexPath) as! HTupleFieldCell
            cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

            cell.textField.leftWidth = 80
            cell.textField.leftLabel.textAlignment = .center
            cell.textField.leftLabel.text = "验证码"

            cell.textField.placeholder = "请输入验证码"
            cell.textField.textColor = UIColor(hex:"#BABABF")
            cell.textField.font = .systemFont(ofSize: 14.0)
            //cell.textField.inputValidator = HNumericValidator.new

            cell.textField.rightWidth = 120
            cell.textField.rightButton.text = "获取验证码"
            cell.textField.rightButton.textFont = .systemFont(ofSize: 14.0)
            cell.textField.rightButton.pressed = { (sender, data) in

            }

            cell.signalBlock = { (target, signal) in
                let cell = target as! HTupleFieldCell
                NSLog("选中%d", cell)
            }
        case 3:
            _ = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath)
        case 4:
            let cell = tuple.reuseCell(HTupleButtonCell.self, nil, true, indexPath) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor(hex:"#CCCCCC")
            cell.buttonView.text = "登录"
            cell.buttonView.pressed = { (sender, data) in

            }

            cell.signalBlock = { (target, signal) in
                let cell = target as! HTupleButtonCell
                NSLog("选中%d", cell)
            }
        default:
            break
        }
    }

}
