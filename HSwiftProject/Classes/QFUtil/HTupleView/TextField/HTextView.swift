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

class HTextView : UITextView, UITextViewDelegate {

    /// 最大输入限制，小于等于0表示不限制，默认为0
    var maxInput: Int = 0
    
    /// 禁止粘贴，默认为false
    var forbidPaste: Bool = false
    
    /// 禁止输入空格和换行符，默认为false
    var forbidWhitespaceAndNewline: Bool = false
    
    /// 是否可编辑，默认为true
    var editEnabled: Bool = true
    
    /// 设置占位符
    var placeholder: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 设置占位符字体
    var placeholderFont: UIFont? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 设置占位符颜色
    var placeholderColor: UIColor = .gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 设置内容
    override var text: String! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 设置内容字体
    override var font: UIFont? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 设置属性内容
    override var attributedText: NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 点击键盘上的return键调用
    var returnBlock: HTextViewReturnBlock?
    
    /// Did Change Block
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
        self.font = UIFont.systemFont(ofSize: 14.0)
        self.placeholderFont = UIFont.systemFont(ofSize: 14.0)
    }
    
    private var trimmingWhitespaceAndNewline: String? {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmingAllWhitespaceAndNewline: String? {
        return self.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.setNeedsDisplay()
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
    
    override func draw(_ rect: CGRect) {
        if self.hasText { return }
        var newRect = CGRect.zero
        newRect.origin.x = 5.0
        newRect.origin.y = 8.0
        let tmpFont = self.placeholderFont ?? UIFont.systemFont(ofSize: 14.0)
        let size = self.placeholder.getStringSize(rectSize: rect.size, font: tmpFont)
        newRect.size.width = size.width
        newRect.size.height = size.height
        /// 将placeHolder画在textView上
        (self.placeholder as NSString).draw(in: newRect, withAttributes: [NSAttributedString.Key.font: tmpFont,
                                                                          NSAttributedString.Key.foregroundColor: self.placeholderColor])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
}

private extension String {
    /// 计算字符串的尺寸
    func getStringSize(rectSize: CGSize, font: UIFont) -> CGSize {
        let string = self as NSString
        let rect = string.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
}

extension HTextView {

    /// 须是字母与数字的组合，长度6-11位
    var isValidatedUserName: Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,11}$"
        return self.isValidateWithRegex(regex)
    }
    /// 字母、数字或其组合，长度6-12位
    var isValidatedPassword: Bool {
        let regex = "[a-zA-Z0-9]{6,12}$"
        return self.isValidateWithRegex(regex)
    }


    ///是否为空
    var isEmpty: Bool {
        return self.text?.isEmpty ?? true
    }
    ///纯字母
    var isOnlyAlpha: Bool {
        let regex = "[a-zA-Z]+$"
        return self.isValidateWithRegex(regex)
    }
    ///纯数字
    var isOnlyNumeric: Bool {
        let regex = "[0-9]+$"
        return self.isValidateWithRegex(regex)
    }
    ///须是字母与数字的组合，默认验证2-10000位
    var isAlphaNumeric: Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{2,}$"
        return self.isValidateWithRegex(regex)
    }
    ///字母、数字或两者的组合
    var isAlphaOrNumeric: Bool {
        let regex = "^[a-zA-Z0-9]+$"
        return self.isValidateWithRegex(regex)
    }



    ///是否有效的邮箱
    var isValidatedEmial: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的验证码
    var isValidatedVCode: Bool {
        let regex = "[0-9]{4,6}$"
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
        let MOBILE = "^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$"
        
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)"
        
        let CU = "(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        
        let CT = "(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)"
        
        if self.isValidateWithRegex(MOBILE) || self.isValidateWithRegex(CM) || self.isValidateWithRegex(CU) || self.isValidateWithRegex(CT) {
            return true
        }else {
            return false
        }
    }
    ///是否有效的身份证号
    var isValidatedIDCard: Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return self.isValidateWithRegex(regex)
    }



    ///是否有效的车牌号
    var isValidatedCarNo: Bool {
        let regex = "^[\\u4e00-\\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fa5]$"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的车型
    var isValidatedCarType: Bool {
        let regex = "^[\\u4E00-\\u9FFF]+$"
        return self.isValidateWithRegex(regex)
    }



    ///纯中文
    var isOnlyChinese: Bool {
        let regex = "[\\u4e00-\\u9fa5]+$"
        return self.isValidateWithRegex(regex)
    }
    /// 微信号校验 可以使用6—20个字母、数字、下划线和减号，必须以字母开头
    ///是否有效的微信号
    var isValidatedWechat: Bool {
        let regex = "^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$"
        return self.isValidateWithRegex(regex)
    }
    ///是否有效的银行卡账号
    var isValidatedBankCard: Bool {
        let regex = "[1-9]([0-9]{13,19})"
        return self.isValidateWithRegex(regex)
    }
    
    
    ///是否包含特殊字符
    var isContainIllegalCharacters: Bool {
        let regex = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$"
        //此处结果取反
        return !self.isValidateWithRegex(regex)
    }



    ///判断内容长度是否等于某个值
    func isEqualto(_ length: Int) -> Bool {
        if let text = text, text.count == length {
            return true
        }
        return false
    }
    ///判断内容长度是否在某两个值之间
    func isBetween(_ start: Int, _ end: Int) -> Bool {
        if let text = text, text.count >= start, text.count <= end {
            return true
        }
        return false
    }
    private func isValidateWithRegex(_ regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES \(regex)").evaluate(with: self.text)
    }
    
}
