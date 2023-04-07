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
typealias HTextViewReturnBlock = (HTextView) -> Void

class HTextView : UITextView, UITextViewDelegate {

    ///最大输入限制，小于等于0表示不限制，默认为0
    var maxInput: Int = 0
    
    ///禁止粘贴，默认为false
    var forbidPaste: Bool = false
    
    ///禁止输入空格和换行符，默认为true
    var forbidWhitespaceAndNewline: Bool = true
    
    ///是否可编辑，默认为true
    var editEnabled: Bool = true
    
    ///点击键盘上的return键调用
    var returnBlock: HTextViewReturnBlock?
    
    ///Did Change Block
    var didChangeBlock: HTextViewDidChangeBlock?
    
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
        self.backgroundColor = UIColor.clear
        self.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func trimmingWhitespaceAndNewline() -> String? {
        if self.text != nil {
            return self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return self.text
    }

    private func trimmingAllWhitespaceAndNewline() -> String? {
        if self.text != nil {
            let content: String = self.text!.replacingOccurrences(of: " ", with: "")
            return content.replacingOccurrences(of: "\n", with: "")
        }
        return self.text
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        if self.didChangeBlock != nil {
//            self.didChangeBlock!(textView as! HTextView)
//        }
//    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.didChangeBlock != nil {
            self.didChangeBlock!(textView as! HTextView)
        }
    }
    
    /// delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.forbidWhitespaceAndNewline && text.length == 1 {//输入字符串
            if text.contains(" ") || text.contains("\n") {
                return false
            }
        }
        if self.maxInput > 0 && textView.text != nil {
            let strLength: Int = textView.text!.length - range.length + text.length
            if strLength > self.maxInput {
                var tmpString: String?
                if text.length > 1 {//复制字符串
                    let string = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    tmpString = textView.text! + string
                    //赋值
                    textView.text = tmpString?.to(loc: self.maxInput)
                    //异步移动光标
                    DispatchQueue.main.async { [weak self, textView] in
                        self!.cursorLocation(textView, index: textView.text!.length)
                    }
                }else {//输入字符串
                    tmpString = textView.text! + text
                    textView.text = tmpString?.to(loc: self.maxInput)
                }
            }else if text.length > 1 {//复制字符串
                let string = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let tmpString = textView.text! + string
                //赋值
                textView.text = tmpString.to(loc: self.maxInput)
                //异步移动光标
                DispatchQueue.main.async { [weak self, textView] in
                    self!.cursorLocation(textView, index: textView.text!.length)
                }
            }
            return (strLength <= self.maxInput)
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.shouldBeginEditingBlock != nil {
            self.shouldBeginEditingBlock!(textView as! HTextView)
        }
        return self.editEnabled
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.shouldEndEditingBlock != nil {
            self.shouldEndEditingBlock!(textView as! HTextView)
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.forbidWhitespaceAndNewline {
            self.text = self.trimmingAllWhitespaceAndNewline()
        }
        self.text = self.trimmingWhitespaceAndNewline()
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if self.returnBlock != nil {
            self.returnBlock!(textView as! HTextView)
        }
        return true
    }

    //移动光标
    private func cursorLocation(_ textView: UITextView, index: Int) {
        let range = NSRange(location: index, length: 0)
        let start: UITextPosition = textView.position(from: textView.beginningOfDocument, offset: range.location)!
        let end: UITextPosition = textView.position(from: start, offset: range.length)!
        textView.selectionRects(for: textView.textRange(from: start, to: end)!)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.forbidPaste {
            OperationQueue.main.addOperation {
                if #available(iOS 13.0, *) {
                    UIMenuController.shared.hideMenu()
                }else {
                    UIMenuController.shared.setMenuVisible(false, animated: false)
                }
            }
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}

extension HTextView {

    /// 须是字母与数字的组合，长度6-11位
    var isValidatedUserName: Bool {
        let regex: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,11}$"
        return self.isValidateWithRegex(regex)
    }
    /// 字母、数字或其组合，长度6-12位
    var isValidatedPassword: Bool {
        let regex: String = "[a-zA-Z0-9]{6,12}$"
        return self.isValidateWithRegex(regex)
    }


    ///是否为空
    var isEmpty: Bool {
        return self.text?.isEmpty ?? true
    }
    ///纯字母
    var isOnlyAlpha: Bool {
        let regex: String = "[a-zA-Z]+$"
        return self.isValidateWithRegex(regex)
    }
    ///纯数字
    var isOnlyNumeric: Bool {
        let regex: String = "[0-9]+$"
        return self.isValidateWithRegex(regex)
    }
    ///须是字母与数字的组合，默认验证2-10000位
    var isAlphaNumeric: Bool {
        let regex: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{2,}$"
        return self.isValidateWithRegex(regex)
    }
    ///字母、数字或两者的组合
    var isAlphaOrNumeric: Bool {
        let regex: String = "^[a-zA-Z0-9]+$"
        return self.isValidateWithRegex(regex)
    }



    ///是否有效的邮箱
    var isValidatedEmial: Bool {
        let regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的验证码
    var isValidatedVCode: Bool {
        let regex: String = "[0-9]{4,6}$"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的手机号
    var isValidatedMobile: Bool {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
         * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
         * 电信号段: 133,153,180,181,189,177,1700,199
         */
        let MOBILE: String = "^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$"
        
        let CM: String = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)"
        
        let CU: String = "(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        
        let CT: String = "(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)"
        
        if self.isValidateWithRegex(MOBILE) || self.isValidateWithRegex(CM) || self.isValidateWithRegex(CU) || self.isValidateWithRegex(CT) {
            return true
        }else {
            return false
        }
    }
    ///是否有效的身份证号
    var isValidatedIDCard: Bool {
        let regex: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return self.isValidateWithRegex(regex)
    }



    ///是否有效的车牌号
    var isValidatedCarNo: Bool {
        let regex: String = "^[\\u4e00-\\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fa5]$"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的车型
    var isValidatedCarType: Bool {
        let regex: String = "^[\\u4E00-\\u9FFF]+$"
        return self.isValidateWithRegex(regex)
    }



    ///纯中文
    var isOnlyChinese: Bool {
        let regex: String = "[\\u4e00-\\u9fa5]+$"
        return self.isValidateWithRegex(regex)
    }
    /// 微信号校验 可以使用6—20个字母、数字、下划线和减号，必须以字母开头
    ///是否有效的微信号
    var isValidatedWechat: Bool {
        let regex: String = "^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的银行卡账号
    var isValidatedBankCard: Bool {
        let regex: String = "[1-9]([0-9]{13,19})"
        return self.isValidateWithRegex(regex)
    }
    
    
    ///是否包含特殊字符
    var isContainIllegalCharacters: Bool {
        let regex: String = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$"
        //此处结果取反
        return !self.isValidateWithRegex(regex)
    }



    ///判断内容长度是否等于某个值
    func isEqualto(_ length: Int) -> Bool {
        if self.text == nil { return false }
        if self.text!.length == length {
            return true
        }
        return false
    }
    ///判断内容长度是否在某两个值之间
    func isBetween(_ start: Int, _ end: Int) -> Bool {
        if self.text == nil { return false }
        if self.text!.length >= start && self.text!.length <= end {
            return true
        }
        return false
    }
    private func isValidateWithRegex(_ regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES \(regex)").evaluate(with: self.text)
    }
    
}
