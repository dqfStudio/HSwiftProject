//
//  HTextField.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HInputReturnBlock = (HTextField) -> Void

class HTextField : UITextField, UITextFieldDelegate {
    
    private var _leftLabel: UILabel?
    var leftLabel: UILabel {
        if _leftLabel == nil {
            _leftLabel = UILabel()
            _leftLabel!.font = UIFont.systemFont(ofSize: 14)
            super.leftViewMode = .always
            super.leftView = _leftLabel
            self.setLeftViewFrame()
        }
        return _leftLabel!
    }
    
    private var _rightLabel: UILabel?
    var rightLabel: UILabel {
        if _rightLabel == nil {
            _rightLabel = UILabel()
            _rightLabel!.font = UIFont.systemFont(ofSize: 14)
            super.rightViewMode = .always
            super.rightView = _rightLabel
            self.setRightViewFrame()
        }
        return _rightLabel!
    }

    private var _leftImage: HWebImageView?
    var leftImage: HWebImageView {
        if _leftImage == nil {
            _leftImage = HWebImageView()
            super.leftViewMode = .always
            super.leftView = _leftImage!
            self.setLeftViewFrame()
        }
        return _leftImage!
    }
    
    private var _rightImage: HWebImageView?
    var rightImage: HWebImageView {
        if _rightImage == nil {
            _rightImage = HWebImageView()
            super.rightViewMode = .always
            super.rightView = _rightImage!
            self.setRightViewFrame()
        }
        return _rightImage!
    }

    private var _leftButton: HWebButtonView?
    var leftButton: HWebButtonView {
        if _leftButton == nil {
            _leftButton = HWebButtonView()
            _leftButton!.textFont = UIFont.systemFont(ofSize: 14)
            super.leftViewMode = .always
            super.leftView = _leftButton!
            self.setLeftViewFrame()
        }
        return _leftButton!
    }
    
    private var _rightButton: HWebButtonView?
    var rightButton: HWebButtonView {
        if _rightButton == nil {
            _rightButton = HWebButtonView()
            _rightButton!.textFont = UIFont.systemFont(ofSize: 14)
            super.rightViewMode = .always
            super.rightView = _rightButton!
            self.setRightViewFrame()
        }
        return _rightButton!
    }
    
    private var _rightCountDownButton: HCountDownButton?
    var rightCountDownButton: HCountDownButton {
        if _rightCountDownButton == nil {
            _rightCountDownButton = HCountDownButton()
            _rightCountDownButton!.textFont = UIFont.systemFont(ofSize: 14)
            super.rightViewMode = .always
            super.rightView = _rightCountDownButton!
            self.setRightViewFrame()
        }
        return _rightCountDownButton!
    }
    
    private var _rightVerifyCodeView: HVerifyCodeView?
    var rightVerifyCodeView: HVerifyCodeView {
        if _rightVerifyCodeView == nil {
            _rightVerifyCodeView = HVerifyCodeView()
            super.rightViewMode = .always
            super.rightView = _rightVerifyCodeView!
            self.setRightViewFrame()
        }
        return _rightVerifyCodeView!
    }

    private var _leftWidth: CGFloat = 0
    var leftWidth: CGFloat {
        get {
            return _leftWidth
        }
        set {
            if _leftWidth != newValue {
                _leftWidth = newValue
                self.setLeftViewFrame()
            }
        }
    }
    private var _rightWidth: CGFloat = 0
    var rightWidth: CGFloat {
        get {
            return _rightWidth
        }
        set {
            if _rightWidth != newValue {
                _rightWidth = newValue
                self.setRightViewFrame()
            }
        }
    }

    private var _leftInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    var leftInsets: UIEdgeInsets {
        get {
            return _leftInsets
        }
        set {
            if _leftInsets != newValue {
                _leftInsets = newValue
                self.setLeftViewFrame()
            }
        }
    }

    private var _rightInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    var rightInsets: UIEdgeInsets {
        get {
            return _rightInsets
        }
        set {
            if _rightInsets != newValue {
                _rightInsets = newValue
                self.setRightViewFrame()
            }
        }
    }
    
    override var placeholder: String? {
        get {
            return self.attributedPlaceholder?.string ?? ""
        }
        set {
            if newValue!.length > 0 {
                let placeholderString: NSMutableAttributedString = NSMutableAttributedString(string: newValue!)
                let range: NSRange = NSRange(location: 0, length: placeholderString.length)
                if self.placeholderFont != nil {//字体
                    placeholderString.addAttribute(.font, value: self.placeholderFont!, range: range)
                }
                if self.placeholderColor != nil {//颜色
                    placeholderString.addAttribute(.foregroundColor, value: self.placeholderColor!, range: range)
                }
                self.attributedPlaceholder = placeholderString
            }
        }
    }

    private var _placeholderFont: UIFont?
    var placeholderFont: UIFont? {
        get {
            return _placeholderFont
        }
        set {
            if newValue != nil && _placeholderFont != newValue && self.attributedPlaceholder != nil {
                let placeholderString = NSMutableAttributedString(attributedString: self.attributedPlaceholder!)
                let range: NSRange = NSRange(location: 0, length: placeholderString.length)
                placeholderString.addAttribute(.font, value: newValue!, range: range)
                self.attributedPlaceholder = placeholderString
            }
            _placeholderFont = newValue
        }
    }
    private var _placeholderColor: UIColor?
    var placeholderColor: UIColor? {
        get {
            return _placeholderColor
        }
        set {
            if newValue != nil && _placeholderColor != newValue && self.attributedPlaceholder != nil {
                let placeholderString = NSMutableAttributedString(attributedString: self.attributedPlaceholder!)
                let range: NSRange = NSRange(location: 0, length: placeholderString.length)
                placeholderString.addAttribute(.foregroundColor, value: newValue!, range: range)
                self.attributedPlaceholder = placeholderString
            }
            _placeholderColor = newValue
        }
    }

    ///最大输入限制，小于等于0表示不限制，默认为0
    var maxInput: Int = 0
    
    ///禁止粘贴，默认为false
    var forbidPaste: Bool = false
    
    ///禁止输入空格和换行符，默认为true
    var forbidWhitespaceAndNewline: Bool = true
    
    ///是否可编辑，默认为true
    var editEnabled: Bool = true
    
    ///点击键盘上的return键调用
    var returnBlock: HInputReturnBlock?
    
//    required init() {
//        super.init()
//        self.setup()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.delegate = self
        self.backgroundColor = UIColor.clear
        self.font = UIFont.systemFont(ofSize: 14)
    }

    private func setLeftViewFrame() {
        if super.leftView != nil && _leftWidth > 0 {
            var frame: CGRect = self.bounds
            frame.size.width = _leftWidth
            //调整frame
            frame.origin.x += _leftInsets.left
            frame.origin.y += _leftInsets.top
            frame.size.width -= _leftInsets.left + _leftInsets.right
            frame.size.height -= _leftInsets.top + _leftInsets.bottom
            if frame != super.leftView?.frame {
                super.leftView?.frame = frame
            }
        }
    }
    
    private func setRightViewFrame() {
        if super.rightView != nil && _rightWidth > 0 {
            var frame: CGRect = self.bounds
            frame.size.width = _rightWidth
            //调整frame
            frame.origin.x += _rightInsets.left
            frame.origin.y += _rightInsets.top
            frame.size.width -= _rightInsets.left + _rightInsets.right
            frame.size.height -= _rightInsets.top + _rightInsets.bottom
            if frame != super.rightView?.frame {
                super.rightView?.frame = frame
            }
        }
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

    /// delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.forbidWhitespaceAndNewline && string.length == 1 {//输入字符串
            if string.contains(" ") || string.contains("\n") {
                return false
            }
        }
        if self.maxInput > 0 && textField.text != nil {
            let strLength: Int = textField.text!.length - range.length + string.length
            if strLength > self.maxInput {
                var tmpString: String?
                if string.length > 1 {//复制字符串
                    let string = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    tmpString = textField.text! + string
                    //赋值
                    textField.text = tmpString?.to(loc: self.maxInput)
                    //异步移动光标
                    DispatchQueue.main.async { [weak self, textField] in
                        self!.cursorLocation(textField, index: textField.text!.length)
                    }
                }else {//输入字符串
                    tmpString = textField.text! + string
                    textField.text = tmpString?.to(loc: self.maxInput)
                }
            }
            return (strLength <= self.maxInput)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.editEnabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.forbidWhitespaceAndNewline {
            self.text = self.trimmingAllWhitespaceAndNewline()
        }
        self.text = self.trimmingWhitespaceAndNewline()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.returnBlock != nil {
            self.returnBlock!(textField as! HTextField)
        }
        return true
    }

    //移动光标
    private func cursorLocation(_ textField: UITextField, index: Int) {
        let range = NSRange(location: index, length: 0)
        let start: UITextPosition = textField.position(from: textField.beginningOfDocument, offset: range.location)!
        let end: UITextPosition = textField.position(from: start, offset: range.length)!
        textField.selectionRects(for: textField.textRange(from: start, to: end)!)
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

    /// Rect
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        //CGRect normalRect = [super leftViewRectForBounds:bounds] //此方法坐标获取有点儿不准确
        var normalRect: CGRect = super.leftView!.bounds
        let space: CGFloat = bounds.height / 2 - normalRect.height / 2
        if space <= 0 {
            normalRect.height = bounds.height
        }else {
            normalRect.y = space
        }
        
        normalRect.x += self.leftInsets.left
        return normalRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        //CGRect normalRect = [super rightViewRectForBounds:bounds] //此方法坐标获取有点儿不准确
        var normalRect: CGRect = super.rightView!.bounds
        normalRect.x = bounds.width - normalRect.width
        let space: CGFloat = bounds.height / 2 - normalRect.height / 2
        if space <= 0 {
            normalRect.height = bounds.height
        }else {
            normalRect.y = space
        }
        
        normalRect.x -= self.rightInsets.right
        return normalRect
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.calculateTextRectForBounds(bounds)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.calculateTextRectForBounds(bounds)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.calculateTextRectForBounds(bounds)
    }
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return self.calculateTextRectForBounds(bounds)
    }
    private func calculateTextRectForBounds(_ bounds: CGRect) -> CGRect {
        var frame: CGRect = bounds.insetBy(dx: 0, dy: 0)
        frame.x += self.leftInsets.left
        frame.x += self.leftInsets.right
        if super.leftView != nil {
            frame.x += super.leftView!.width
            frame.width -= frame.x
        }
        frame.width -= self.rightInsets.left
        frame.width -= self.rightInsets.right
        if super.rightView != nil {
            frame.width -= super.rightView!.width
        }
        //光标距右边输入框默认有10pt的距离
        //此处去掉此默认距离，以达到精准控制的目的
        frame.width += 10
        return frame
    }

}

extension HTextField {

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
