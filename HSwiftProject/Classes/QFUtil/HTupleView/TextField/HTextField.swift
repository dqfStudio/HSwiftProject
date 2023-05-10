//
//  HTextField.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTextFieldReturnBlock = (HTextField) -> Void

class HTextField : UITextField, UITextFieldDelegate {
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.leftViewMode = .always
        self.leftView = label
        self.setLeftViewFrame()
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.rightViewMode = .always
        self.rightView = label
        self.setRightViewFrame()
        return label
    }()

    lazy var leftImage: HWebImageView = {
        let imageView = HWebImageView()
        self.leftViewMode = .always
        self.leftView = imageView
        self.setLeftViewFrame()
        return imageView
    }()
    
    lazy var rightImage: HWebImageView = {
        let imageView = HWebImageView()
        self.rightViewMode = .always
        self.rightView = imageView
        self.setRightViewFrame()
        return imageView
    }()

    lazy var leftItem: HWebButtonView = {
        let button = HWebButtonView()
        button.textFont = UIFont.systemFont(ofSize: 14)
        self.leftViewMode = .always
        self.leftView = button
        self.setLeftViewFrame()
        return button
    }()
    
    lazy var rightButton: HWebButtonView = {
        let button = HWebButtonView()
        button.textFont = UIFont.systemFont(ofSize: 14)
        self.rightViewMode = .always
        self.rightView = button
        self.setRightViewFrame()
        return button
    }()
    
    lazy var rightCountDownButton: HCountDownButton = {
        let button = HCountDownButton()
        button.textFont = UIFont.systemFont(ofSize: 14)
        self.rightViewMode = .always
        self.rightView = button
        self.setRightViewFrame()
        return button
    }()
    
    lazy var rightVerifyCodeView: HVerifyCodeView = {
        let view = HVerifyCodeView()
        self.rightViewMode = .always
        self.rightView = view
        self.setRightViewFrame()
        return view
    }()

    var leftWidth: CGFloat = 0.0 {
        didSet {
            if leftWidth != oldValue {
                self.setLeftViewFrame()
            }
        }
    }
    
    var rightWidth: CGFloat = 0.0 {
        didSet {
            if rightWidth != oldValue {
                self.setRightViewFrame()
            }
        }
    }

    var leftInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5) {
        didSet {
            if leftInsets != oldValue {
                self.setLeftViewFrame()
            }
        }
    }

    var rightInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) {
        didSet {
            if rightInsets != oldValue {
                self.setRightViewFrame()
            }
        }
    }
    
    override var placeholder: String? {
        get {
            return self.attributedPlaceholder?.string ?? ""
        }
        set {
            guard let newValue = newValue, !newValue.isEmpty else { return }
            let placeholderString = NSMutableAttributedString(string: newValue)
            let range = NSRange(location: 0, length: placeholderString.length)
            if let placeholderFont = self.placeholderFont {//字体
                placeholderString.addAttribute(.font, value: placeholderFont, range: range)
            }
            if let placeholderColor = self.placeholderColor {//颜色
                placeholderString.addAttribute(.foregroundColor, value: placeholderColor, range: range)
            }
            self.attributedPlaceholder = placeholderString
        }
    }

    var placeholderFont: UIFont? {
        didSet {
            guard let newValue = placeholderFont, let attributedPlaceholder = attributedPlaceholder else { return }
            let placeholderString = NSMutableAttributedString(attributedString: attributedPlaceholder)
            let range: NSRange = NSRange(location: 0, length: placeholderString.length)
            placeholderString.addAttribute(.font, value: newValue, range: range)
            self.attributedPlaceholder = placeholderString
        }
    }
    
    var placeholderColor: UIColor? {
        didSet {
            guard let newValue = placeholderColor, let attributedPlaceholder = attributedPlaceholder else { return }
            let placeholderString = NSMutableAttributedString(attributedString: attributedPlaceholder)
            let range: NSRange = NSRange(location: 0, length: placeholderString.length)
            placeholderString.addAttribute(.foregroundColor, value: newValue, range: range)
            self.attributedPlaceholder = placeholderString
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
    var returnBlock: HTextFieldReturnBlock?
    
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
        guard let leftView = super.leftView, leftWidth > 0 else { return }
        bounds.size.width = leftWidth
        let frame = bounds.inset(by: leftInsets)
        if frame != leftView.frame {
            leftView.frame = frame
        }
    }
    
    private func setRightViewFrame() {
        guard let rightView = super.rightView, rightWidth > 0 else { return }
        bounds.size.width = rightWidth
        let frame = bounds.inset(by: rightInsets)
        if frame != rightView.frame {
            rightView.frame = frame
        }
    }
    
    private var trimmingWhitespaceAndNewline: String? {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmingAllWhitespaceAndNewline: String? {
        return self.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //输入字符串
        if self.forbidWhitespaceAndNewline && string.length == 1 && string.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }
        if self.maxInput > 0, let textFieldText = textField.text {
            let strLength = textFieldText.count - range.length + string.count
            if strLength > self.maxInput {
                if string.length > 1 {//复制字符串
                    let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tmpString = textFieldText + string
                    //赋值
                    textField.text = tmpString.to(loc: self.maxInput)
                    //异步移动光标
                    DispatchQueue.main.async { [weak self, textField] in
                        self?.cursorLocation(textField, index: textFieldText.count)
                    }
                }else {//输入字符串
                    let tmpString = textFieldText + string
                    //赋值
                    textField.text = tmpString.to(loc: self.maxInput)
                }
            }
            return strLength <= self.maxInput
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.editEnabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.forbidWhitespaceAndNewline {
            self.text = self.trimmingAllWhitespaceAndNewline
        }
        self.text = self.trimmingWhitespaceAndNewline
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnBlock?(textField as! HTextField)
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

    /// Rect
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        //CGRect normalRect = [super leftViewRectForBounds:bounds] //此方法坐标获取有点儿不准确
        guard let leftView = super.leftView else {
            return .zero
        }
        var normalRect: CGRect = leftView.bounds
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
        guard let rightView = super.rightView else {
            return .zero
        }
        var normalRect: CGRect = rightView.bounds
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
        if let leftView = super.leftView {
            frame.x += leftView.width
            frame.width -= frame.x
        }
        frame.width -= self.rightInsets.left
        frame.width -= self.rightInsets.right
        if let rightView = super.rightView {
            frame.width -= rightView.width
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
