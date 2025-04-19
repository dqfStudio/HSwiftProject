//
//  HTextView.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/7.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HTextViewShouldBeginEditingBlock = (HTextView) -> Void
typealias HTextViewShouldEndEditingBlock = (HTextView) -> Void

typealias HTextViewDidChangeBlock = (HTextView) -> Void
typealias HTextViewDidChangeSelectionBlock = (HTextView) -> Void
typealias HTextViewReturnBlock = (HTextView) -> Void

class HTextView: UITextView, UITextViewDelegate {

    ///最大输入限制，小于等于0表示不限制，默认为0
    var maxInput: Int = 0
    
    ///禁止粘贴，默认为false
    var forbidPaste: Bool = false
    
    ///禁止输入空格和换行符，默认为false
    var forbidWhitespaceAndNewline: Bool = false
    
    ///是否可编辑，默认为true
    var editEnabled: Bool = true
    
    ///点击键盘上的return键调用
    var returnBlock: HTextViewReturnBlock?
    
    ///Did Change Block
    var didChangeBlock: HTextViewDidChangeBlock?
    var didChangeSelectionBlock: HTextViewDidChangeSelectionBlock?
    
    var shouldBeginEditingBlock: HTextViewShouldBeginEditingBlock?
    var shouldEndEditingBlock: HTextViewShouldEndEditingBlock?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    
    private func setup() {
        self.delegate = self
        self.backgroundColor = .clear
        self.font = .systemFont(ofSize: 14.0)
    }
    
    private var trimmingWhitespaceAndNewline: String? {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmingAllWhitespaceAndNewline: String? {
        return self.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didChangeBlock?(textView as! HTextView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.didChangeSelectionBlock?(textView as! HTextView)
    }
    
    /// delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //输入字符串
        if self.forbidWhitespaceAndNewline && text.length == 1 && text.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }
        if self.maxInput > 0, let textViewText = textView.text {
            let strLength = textViewText.count - range.length + text.count
            if strLength > self.maxInput {
                if text.length > 1 {//复制字符串
                    let string = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tmpString = textViewText + string
                    //赋值
                    textView.text = tmpString.to(loc: self.maxInput)
                    //异步移动光标
                    DispatchQueue.main.async { [weak self, textView] in
                        self?.cursorLocation(textView, index: textViewText.count)
                    }
                }else {//输入字符串
                    let tmpString = textViewText + text
                    //赋值
                    textView.text = tmpString.to(loc: self.maxInput)
                }
            }
            return strLength <= self.maxInput
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.shouldBeginEditingBlock?(textView as! HTextView)
        return self.editEnabled
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.shouldEndEditingBlock?(textView as! HTextView)
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.forbidWhitespaceAndNewline {
            self.text = self.trimmingAllWhitespaceAndNewline
        }
        self.text = self.trimmingWhitespaceAndNewline
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        self.returnBlock?(textView as! HTextView)
        return true
    }

    //移动光标
    private func cursorLocation(_ textView: UITextView, index: Int) {
        textView.selectedRange = NSRange(location: index, length: 0)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.forbidPaste {
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    UIMenuController.shared.hideMenu()
                } else {
                    UIMenuController.shared.setMenuVisible(false, animated: false)
                }
            }
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}
