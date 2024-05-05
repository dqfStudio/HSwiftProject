//
//  HInputBoxView.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/15.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HInputBoxFinishBlock = (_ password: String) -> Void
typealias HInputBoxChangeBlock = (_ password: String) -> Void

class HInputBoxView: UIView, HTupleViewDelegate {
    
    //是否密文
    var isSecureTextEntry: Bool = false
    //间隔宽度
    var spaceWidth: CGFloat = 10.0
    
    var inputBoxFinishBlock: HInputBoxFinishBlock?
    var inputBoxChangeBlock: HInputBoxChangeBlock?
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: self.bounds)
        textField.backgroundColor = .clear
        textField.textColor = .clear
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        textField.delegate = self
        return textField
    }()
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: self.bounds, scrollDirection: .horizontal)
        tupleView.backgroundColor = .clear
        tupleView.disableBounce()
        return tupleView
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.backgroundColor = .clear
        self.tupleView.delegate = self
        self.addSubview(self.textField)
        self.addSubview(self.tupleView)
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return 6
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = (self.tupleView.width - self.spaceWidth * 5) / 6
        //根据给的固定间隔去计算宽度与高度
        if width > self.tupleView.height {//计算出来的宽度大于高度
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        }else {//计算出来的宽度小于高度
            return CGSize(width: width, height: width)
        }
    }
    
    func sizeForFooterInSection(_ section: Any) -> Any {
        if section as! Int == 5 {
            return CGSize.zero
        }
        //根据给的固定间隔去计算宽度与高度
        let width = (self.tupleView.width - self.spaceWidth * 5) / 6
        if width > self.tupleView.height {//计算出来的宽度大于高度
            //重新计算间隔
            let space = (self.tupleView.width - self.tupleView.height * 6) / 5
            return CGSize(width: space, height: self.tupleView.height)
        }else {//计算出来的宽度小于高度
            //重新计算间隔
            let space = (self.tupleView.width - width * 6) / 5
            return CGSize(width: space, height: self.tupleView.height)
        }
    }

    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {        
        let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
        let string = self.textField.text ?? ""
        if textField.isFirstResponder, indexPath.section == string.length {
            cell.backgroundColor = .clear
        } else {
            cell.backgroundColor = UIColor(hex: 0xF2F3F5)
        }
        let borderWidth: CGFloat = 2
        cell.cornerRadius = 8
        //设置边框
        if self.textField.isFirstResponder, indexPath.section == string.length {
            cell.borderWidth = borderWidth
            cell.borderColor = UIColor(hex: 0x3879FC)
        }else if self.textField.isFirstResponder, string.length == 6, indexPath.section == 5 {
            cell.borderWidth = borderWidth
            cell.borderColor = UIColor(hex: 0x3879FC)
            cell.backgroundColor = .clear
        }else {
            cell.borderWidth = borderWidth
            cell.borderColor = UIColor(hex: 0xF2F3F5)
        }
        //设置值
        if indexPath.section < string.length {
            if self.isSecureTextEntry {
                cell.label.text = "*"
            }else {
                cell.label.text = string.subString(start: indexPath.section, end: 1)
            }
        } else {
            cell.label.text = ""
        }
        cell.label.textAlignment = .center
        cell.label.textColor = UIColor(hex: 0x17191E)
        cell.label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    
    func tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.footer(HTupleBaseApex.self, nil, true, indexPath) as! HTupleBaseApex
        cell.backgroundColor = .clear
    }
    
    func didSelectCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }

}

// MARK: - UITextFieldDelegate
extension HInputBoxView: UITextFieldDelegate {
    
    func caretRectForPosition(_ position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tupleView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tupleView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {
            if #available(iOS 13.0, *) {
                UIMenuController.shared.hideMenu()
            } else {
                // Fallback on earlier versions
            }
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let string = textField.text!
        if string.length >= 0, string.length <= 6 {
            self.tupleView.reloadData()
            self.inputBoxChangeBlock?(string)
            if string.length == 6 {
                textField.resignFirstResponder()
                self.inputBoxFinishBlock?(string)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        if textField.text?.count ?? 0 >= 6 {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}
