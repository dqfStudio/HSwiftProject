//
//  HTextField.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTextFieldReturnBlock = (HTextField) -> Void
typealias HTextFieldDidChangeBlock = (HTextField) -> Void

typealias HTextFieldShouldBeginEditingBlock = (HTextField) -> Void
typealias HTextFieldDidEndEditingBlock = (HTextField) -> Void

extension UIView {
    // 扩展一个空方法，用于加载UITextField的leftView或rightView
    func loadEmpty() { }
}

class HTextField: UITextField, UITextFieldDelegate {
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.leftViewMode = .always
        self.leftView = label
        self.setLeftViewFrame()
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
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

    lazy var leftButton: HWebButtonView = {
        let button = HWebButtonView()
        button.textFont = .systemFont(ofSize: 14.0)
        self.leftViewMode = .always
        self.leftView = button
        self.setLeftViewFrame()
        return button
    }()
    
    lazy var rightButton: HWebButtonView = {
        let button = HWebButtonView()
        button.textFont = .systemFont(ofSize: 14.0)
        self.rightViewMode = .always
        self.rightView = button
        self.setRightViewFrame()
        return button
    }()
    
    lazy var rightCountDownButton: HCountDownButton = {
        let button = HCountDownButton()
        button.textFont = .systemFont(ofSize: 14.0)
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
    
    ///text发生变化时的回调
    var didChangeBlock: HTextFieldDidChangeBlock?
    
    ///输入结束时的回调
    var didEndEditingBlock: HTextFieldDidEndEditingBlock?
    var shouldBeginEditingBlock: HTextFieldShouldBeginEditingBlock?
    
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
        self.font = .systemFont(ofSize: 14.0)
    }

    private func setLeftViewFrame() {
        guard let leftView = super.leftView, leftWidth > 0 else { return }
        var leftBounds = self.bounds
        leftBounds.width = leftWidth
        let frame = leftBounds.inset(by: leftInsets)
        if frame != leftView.frame {
            leftView.frame = frame
        }
    }
    
    private func setRightViewFrame() {
        guard let rightView = super.rightView, rightWidth > 0 else { return }
        var rightBounds = self.bounds
        rightBounds.width = rightWidth
        let frame = rightBounds.inset(by: rightInsets)
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
        self.shouldBeginEditingBlock?(textField as! HTextField)
        return self.editEnabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.forbidWhitespaceAndNewline {
            self.text = self.trimmingAllWhitespaceAndNewline
        }
        self.text = self.trimmingWhitespaceAndNewline
        self.didEndEditingBlock?(textField as! HTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnBlock?(textField as! HTextField)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.didChangeBlock?(textField as! HTextField)
    }

    //移动光标
    private func cursorLocation(_ textField: UITextField, index: Int) {
        let range = NSRange(location: index, length: 0)
        if let start = textField.position(from: textField.beginningOfDocument, offset: range.location) {
            if let end = textField.position(from: start, offset: range.length) {
                if let textRange = textField.textRange(from: start, to: end) {
                    textField.selectionRects(for: textRange)
                }
            }
        }
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
