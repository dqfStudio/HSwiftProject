//
//  HTextFieldView.swift
//  HSwiftProject
//
//  Created by Wind on 2025/06/01.
//  Copyright © 2025 wind. All rights reserved.
//
//  HTextFieldView 是一个组合模式实现的输入框组件。
//
//  设计原则：
//  1. 链式配置 — 所有设置通过 config block 完成，类似 SnapKit 风格
//  2. 精细布局 — 每个侧边视图可独立设置 size、insets、alignment
//  3. 组合优于继承 — 内部持有 UITextField，布局集中在 layoutSubviews
//  4. 验证码自动填充 — 内置 OTP oneTimeCode + iOS 17+ 自动识别填充支持
//
//  使用示例：
//  ```
//  let input = HTextFieldView().config { c in
//      c.placeholder("请输入验证码")
//      c.maxLength(6).keyboard(.numberPad)
//      c.leftIcon(UIImage(named: "sms")) { v in
//          v.size(20, 20).insets(left: 12, right: 8)
//      }
//      c.rightCountdown { v in
//          v.width(90).insets(left: 8, right: 12)
//      }
//      c.autoFillOTP()
//  }
//
//  ```
//
//  ## 验证码自动填充机制
//
//  1. **textContentType = .oneTimeCode** (iOS 12+)
//     系统从 iMessage 中识别验证码短信，在键盘上方提供 QuickType 建议，
//     点击后自动填入。
//
//  2. **iOS 17+ 安全贴纸识别**
//     系统自动识别 iMessage 中的验证码并直接自动填充（无需用户点击建议条），
//     填充后通过 `onOTPFilled` 回调通知。
//
//  3. **自动提交** (iOS 17+)
//     设置 `autoSubmitOTP(true)` 后，验证码自动填入且达到 maxLength 时，
//     自动触发 `onOTPFilled` 回调并将 autoSubmit 标记置为 true，
//     外部可在 onOTPFilled 中执行提交逻辑。
//

import UIKit

// MARK: - 链式配置

/// HTextFieldView 的链式配置器。
/// 所有配置方法返回 Self，支持连续调用。
final class HTextFieldConfigurator {
    private let textField: UITextField
    private let owner: HTextFieldView

    private var pendingLeft: [PendingSideView] = []
    private var pendingRight: [PendingSideView] = []

    fileprivate init(owner: HTextFieldView) {
        self.owner = owner
        self.textField = owner.textField
    }

    // MARK: - 基础配置

    @discardableResult
    func font(_ font: UIFont) -> Self {
        textField.font = font; return self
    }

    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textField.textColor = color; return self
    }

    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        textField.textAlignment = alignment; return self
    }

    @discardableResult
    func placeholder(_ text: String) -> Self {
        owner._placeholder = text
        owner._updatePlaceholder()
        return self
    }

    @discardableResult
    func placeholderColor(_ color: UIColor) -> Self {
        owner._placeholderColor = color
        owner._updatePlaceholder()
        return self
    }

    @discardableResult
    func placeholderFont(_ font: UIFont) -> Self {
        owner._placeholderFont = font
        owner._updatePlaceholder()
        return self
    }

    // MARK: - 输入限制

    @discardableResult
    func maxLength(_ length: Int) -> Self {
        owner._maxLength = length; return self
    }

    @discardableResult
    func forbidPaste(_ forbid: Bool) -> Self {
        owner._forbidPaste = forbid; return self
    }

    @discardableResult
    func forbidWhitespace(_ forbid: Bool) -> Self {
        owner._forbidWhitespace = forbid; return self
    }

    @discardableResult
    func editable(_ editable: Bool) -> Self {
        owner._editable = editable; return self
    }

    // MARK: - 键盘

    @discardableResult
    func keyboard(_ type: UIKeyboardType) -> Self {
        textField.keyboardType = type; return self
    }

    @discardableResult
    func returnKey(_ type: UIReturnKeyType) -> Self {
        textField.returnKeyType = type; return self
    }

    @discardableResult
    func secure(_ secure: Bool) -> Self {
        textField.isSecureTextEntry = secure; return self
    }

    // MARK: - 容器边距

    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Self {
        owner._contentInsets = insets; return self
    }

    @discardableResult
    func contentInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        owner._contentInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    // MARK: - 侧边视图（左）

    @discardableResult
    func leftLabel(_ text: String, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.sizeToFit()
        let cfg = HSideViewConfig(width: l.bounds.width)
        block?(cfg)
        pendingLeft.append(PendingSideView(view: l, config: cfg))
        return self
    }

    @discardableResult
    func leftIcon(_ image: UIImage?, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let iv = UIImageView(image: image)
        iv.contentMode = .center
        let cfg = HSideViewConfig(width: 24)
        block?(cfg)
        pendingLeft.append(PendingSideView(view: iv, config: cfg))
        return self
    }

    @discardableResult
    func leftButton(_ title: String? = nil, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        if let title = title { btn.setTitle(title, for: .normal) }
        let cfg = HSideViewConfig(width: 60, interactive: true)
        block?(cfg)
        pendingLeft.append(PendingSideView(view: btn, config: cfg))
        return self
    }

    @discardableResult
    func leftWebImage(block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let iv = HWebImageView()
        iv.contentMode = .scaleAspectFit
        let cfg = HSideViewConfig(width: 24)
        block?(cfg)
        pendingLeft.append(PendingSideView(view: iv, config: cfg))
        return self
    }

    @discardableResult
    func leftWebButton(_ title: String? = nil, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let btn = HWebButtonView()
        btn.textFont = .systemFont(ofSize: 14)
        if let title = title { btn.setTitle(title, for: .normal) }
        let cfg = HSideViewConfig(width: 60, interactive: true)
        block?(cfg)
        pendingLeft.append(PendingSideView(view: btn, config: cfg))
        return self
    }

    @discardableResult
    func leftView(_ view: UIView, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let cfg = HSideViewConfig()
        block?(cfg)
        pendingLeft.append(PendingSideView(view: view, config: cfg))
        return self
    }

    // MARK: - 侧边视图（右）

    @discardableResult
    func rightLabel(_ text: String, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.sizeToFit()
        let cfg = HSideViewConfig(width: l.bounds.width)
        block?(cfg)
        pendingRight.append(PendingSideView(view: l, config: cfg))
        return self
    }

    @discardableResult
    func rightIcon(_ image: UIImage?, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let iv = UIImageView(image: image)
        iv.contentMode = .center
        let cfg = HSideViewConfig(width: 24)
        block?(cfg)
        pendingRight.append(PendingSideView(view: iv, config: cfg))
        return self
    }

    @discardableResult
    func rightCountdown(block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let btn = HCountDownButton()
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        let cfg = HSideViewConfig(width: 90, interactive: true)
        block?(cfg)
        pendingRight.append(PendingSideView(view: btn, config: cfg))
        return self
    }

    @discardableResult
    func rightButton(_ title: String? = nil, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        if let title = title { btn.setTitle(title, for: .normal) }
        let cfg = HSideViewConfig(width: 60, interactive: true)
        block?(cfg)
        pendingRight.append(PendingSideView(view: btn, config: cfg))
        return self
    }

    @discardableResult
    func rightWebImage(block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let iv = HWebImageView()
        iv.contentMode = .scaleAspectFit
        let cfg = HSideViewConfig(width: 24)
        block?(cfg)
        pendingRight.append(PendingSideView(view: iv, config: cfg))
        return self
    }

    @discardableResult
    func rightWebButton(_ title: String? = nil, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let btn = HWebButtonView()
        btn.textFont = .systemFont(ofSize: 14)
        if let title = title { btn.setTitle(title, for: .normal) }
        let cfg = HSideViewConfig(width: 60, interactive: true)
        block?(cfg)
        pendingRight.append(PendingSideView(view: btn, config: cfg))
        return self
    }

    @discardableResult
    func rightVerifyCode(width: CGFloat = 100, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let v = HVerifyCodeView()
        let cfg = HSideViewConfig(width: width, interactive: true)
        block?(cfg)
        pendingRight.append(PendingSideView(view: v, config: cfg))
        return self
    }

    @discardableResult
    func rightView(_ view: UIView, block: ((HSideViewConfig) -> Void)? = nil) -> Self {
        let cfg = HSideViewConfig()
        block?(cfg)
        pendingRight.append(PendingSideView(view: view, config: cfg))
        return self
    }

    // MARK: - 验证码自动填充

    /// 启用验证码自动填充（textContentType = .oneTimeCode）
    @discardableResult
    func autoFillOTP(_ enable: Bool = true) -> Self {
        owner._otpEnabled = enable
        if enable {
            owner.textField.textContentType = .oneTimeCode
        }
        return self
    }

    /// 自动填充完成后自动触发提交判断。
    /// 当验证码自动填入且长度达到 maxLength 时，自动触发 onOTPFilled。
    @discardableResult
    func autoSubmitOTP(_ enable: Bool = true) -> Self {
        owner._autoSubmitOTP = enable
        return self
    }

    // MARK: - 内部

    fileprivate func apply() {
        owner.removeSideViews()

        owner._sideViews.removeAll()
        for p in pendingLeft {
            let sv = HTextFieldSideView(view: p.view, side: .left, config: p.config)
            owner._sideViews.append(sv)
            owner.addSubview(p.view)
        }
        for p in pendingRight {
            let sv = HTextFieldSideView(view: p.view, side: .right, config: p.config)
            owner._sideViews.append(sv)
            owner.addSubview(p.view)
        }
        pendingLeft.removeAll()
        pendingRight.removeAll()
        owner.setNeedsLayout()
    }
}

// MARK: - HSideViewConfig

/// 侧边视图的精细配置，支持链式调用。
final class HSideViewConfig {
    /// 视图宽度（0 = 自动取 intrinsicContentSize）
    var width: CGFloat = 0
    /// 视图高度（0 = 自动撑满容器高度）
    var height: CGFloat = 0
    /// 外边距
    var insets: UIEdgeInsets = .zero
    /// 垂直对齐方式
    var alignment: HSideViewAlignment = .center
    /// 是否可交互（按钮等需要触摸的设为 true）
    var interactive: Bool = false

    init(width: CGFloat = 0, interactive: Bool = false) {
        self.width = width
        self.interactive = interactive
    }

    @discardableResult
    func size(_ w: CGFloat, _ h: CGFloat) -> Self { width = w; height = h; return self }

    @discardableResult
    func insets(_ value: CGFloat) -> Self { insets = UIEdgeInsets(top: 0, left: value, bottom: 0, right: value); return self }

    @discardableResult
    func insets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right); return self
    }

    @discardableResult
    func insets(_ insets: UIEdgeInsets) -> Self { self.insets = insets; return self }

    @discardableResult
    func align(_ alignment: HSideViewAlignment) -> Self { self.alignment = alignment; return self }

    @discardableResult
    func interactive(_ value: Bool) -> Self { interactive = value; return self }
}

/// 侧边视图垂直对齐
enum HSideViewAlignment {
    case center
    case top
    case bottom
}

// MARK: - 内部辅助类型

private struct PendingSideView {
    let view: UIView
    let config: HSideViewConfig
}

struct HTextFieldSideView {
    enum Side: String { case left, right }
    let view: UIView
    let side: Side
    let config: HSideViewConfig
}

// MARK: - HTextFieldView

/// 组合模式实现的输入框组件。
///
/// 布局配置通过 `config { c in ... }` 链式调用完成。
/// 业务回调通过属性赋值完成（如 `input.onOTPFilled = { ... }`），
/// 配置与逻辑分离，避免大量业务代码堆在 config 闭包中。
class HTextFieldView: UIView {

    // MARK: - Subview

    /// 内部文本输入框
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // MARK: - 侧边视图

    fileprivate var _sideViews: [HTextFieldSideView] = []
    var sideViews: [HTextFieldSideView] { _sideViews }

    func sideView(at index: Int, side: HTextFieldSideView.Side) -> UIView? {
        let filtered = _sideViews.filter { $0.side == side }
        guard index < filtered.count else { return nil }
        return filtered[index].view
    }

    var leftView: UIView? { _sideViews.first(where: { $0.side == .left })?.view }
    var rightView: UIView? { _sideViews.first(where: { $0.side == .right })?.view }

    // MARK: - 配置存储

    fileprivate var _placeholder: String?
    fileprivate var _placeholderColor: UIColor?
    fileprivate var _placeholderFont: UIFont?
    fileprivate var _maxLength: Int = 0
    fileprivate var _forbidPaste: Bool = false
    fileprivate var _forbidWhitespace: Bool = true
    fileprivate var _editable: Bool = true
    fileprivate var _contentInsets: UIEdgeInsets = .zero

    fileprivate var _otpEnabled: Bool = false
    fileprivate var _autoSubmitOTP: Bool = false

    // MARK: - 回调用属性（非链式，配置与逻辑分离）

    /// 文本变化回调
    var onTextChange: ((String) -> Void)?
    /// 点击 return 回调
    var onReturn: ((String) -> Void)?
    /// 结束编辑回调
    var onDidEndEditing: ((String) -> Void)?
    /// 开始编辑前回调（返回 false 阻止编辑）
    var onShouldBeginEditing: (() -> Bool)?
    /// 验证码自动填充回调。
    /// - autoSubmitOTP(false，默认)：每次编辑变化都触发
    /// - autoSubmitOTP(true)：仅长度达到 maxLength 时触发一次
    var onOTPFilled: ((String) -> Void)?

    // 侧边视图之间的间距
    private var leftSpacing: CGFloat = 2
    private var rightSpacing: CGFloat = 2
    private var leftTextSpacing: CGFloat = 5
    private var rightTextSpacing: CGFloat = 10

    // MARK: - 链式配置入口

    @discardableResult
    func config(_ block: (HTextFieldConfigurator) -> Void) -> Self {
        let configurator = HTextFieldConfigurator(owner: self)
        block(configurator)
        configurator.apply()
        return self
    }

    // MARK: -  快速访问

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(textField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    // MARK: - Internal

    fileprivate func removeSideViews() {
        _sideViews.forEach { $0.view.removeFromSuperview() }
        _sideViews.removeAll()
    }

    fileprivate func _updatePlaceholder() {
        guard let p = _placeholder else {
            textField.attributedPlaceholder = nil
            return
        }
        let attr = NSMutableAttributedString(string: p)
        let range = NSRange(location: 0, length: attr.length)
        if let pf = _placeholderFont {
            attr.addAttribute(.font, value: pf, range: range)
        }
        if let pc = _placeholderColor {
            attr.addAttribute(.foregroundColor, value: pc, range: range)
        }
        textField.attributedPlaceholder = attr
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let bounds = self.bounds
        let insets = _contentInsets
        let cr = bounds.inset(by: insets)
        let ch = cr.height
        guard ch > 0 else { return }

        // 左侧视图布局
        let lefts = _sideViews.filter { $0.side == .left }
        var lo = cr.minX
        for (i, sv) in lefts.enumerated() {
            let cfg = sv.config
            let w = cfg.width > 0 ? cfg.width : sv.view.intrinsicContentSize.width
            let h: CGFloat
            if cfg.height > 0 { h = min(cfg.height, ch) }
            else { h = ch - cfg.insets.top - cfg.insets.bottom }
            let y: CGFloat
            switch cfg.alignment {
            case .top:    y = cr.minY + cfg.insets.top
            case .center: y = cr.minY + (ch - h) * 0.5
            case .bottom: y = cr.maxY - h - cfg.insets.bottom
            }
            sv.view.frame = CGRect(x: lo + cfg.insets.left,
                                   y: y,
                                   width: max(w - cfg.insets.left - cfg.insets.right, 0),
                                   height: max(h, 0))
            lo = sv.view.frame.maxX + cfg.insets.right
            if i < lefts.count - 1 { lo += leftSpacing }
        }
        let lt = lo - cr.minX

        // 右侧视图布局
        let rights = _sideViews.filter { $0.side == .right }
        var ro = cr.maxX
        for (i, sv) in rights.reversed().enumerated() {
            let cfg = sv.config
            let w = cfg.width > 0 ? cfg.width : sv.view.intrinsicContentSize.width
            let h: CGFloat
            if cfg.height > 0 { h = min(cfg.height, ch) }
            else { h = ch - cfg.insets.top - cfg.insets.bottom }
            let y: CGFloat
            switch cfg.alignment {
            case .top:    y = cr.minY + cfg.insets.top
            case .center: y = cr.minY + (ch - h) * 0.5
            case .bottom: y = cr.maxY - h - cfg.insets.bottom
            }
            ro -= (w + cfg.insets.right)
            sv.view.frame = CGRect(x: ro + cfg.insets.left,
                                   y: y,
                                   width: max(w - cfg.insets.left - cfg.insets.right, 0),
                                   height: max(h, 0))
            ro -= cfg.insets.left
            if i < rights.count - 1 { ro -= rightSpacing }
        }
        let rt = cr.maxX - ro

        // 文本区域
        let tx = cr.minX + lt + (lt > 0 ? leftTextSpacing : 0)
        let tw = cr.width - lt - rt
                - (lt > 0 ? leftTextSpacing : 0)
                - (rt > 0 ? rightTextSpacing : 0)

        textField.frame = CGRect(x: tx, y: cr.minY, width: max(tw, 0), height: ch)
    }

    // MARK: - Event

    @objc private func textDidChange() {
        onTextChange?(textField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate

extension HTextFieldView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        onShouldBeginEditing?() ?? _editable
    }

    func textField(_: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if _forbidWhitespace,
           string.count == 1,
           string.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }

        // OTP 自动填充检测：
        // oneTimeCode 填充时 replacementString 是完整的验证码（如 "123456"），
        // range.location == 0，range.length == 当前 text 长度。
        // 此时 string.count 通常 == 验证码长度，但稳妥起见标记为 OTP 填充。
        let isOTPAutoFill = _otpEnabled
                            && !string.isEmpty
                            && range.location == 0
                            && range.length == (textField.text?.count ?? 0)
                            && string.count > 1

        if isOTPAutoFill {
            let code = string
            if _autoSubmitOTP && _maxLength > 0 && code.count >= _maxLength {
                textField.text = String(code.prefix(_maxLength))
                onOTPFilled?(String(code.prefix(_maxLength)))
                return false
            } else {
                onOTPFilled?(code)
                // 仍然让系统处理填入
                return true
            }
        }

        guard _maxLength > 0, let ct = textField.text else { return true }
        let nl = ct.count - range.length + string.count
        guard nl > _maxLength else { return true }

        if string.count > 1 {
            let safe = string.trimmingCharacters(in: .whitespacesAndNewlines)
            textField.text = String((ct + safe).prefix(_maxLength))
            DispatchQueue.main.async {
                if let pos = self.textField.position(from: self.textField.beginningOfDocument,
                                                offset: ct.count) {
                    self.textField.selectedTextRange = self.textField.textRange(from: pos, to: pos)
                }
            }
        } else {
            textField.text = String((ct + string).prefix(_maxLength))
        }
        return false
    }

    func textFieldDidEndEditing(_: UITextField) {
        if _forbidWhitespace {
            textField.text = textField.text?
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
        }
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        onDidEndEditing?(textField.text ?? "")
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        textField.resignFirstResponder()
        onReturn?(textField.text ?? "")
        return true
    }
}

// MARK: - HitTest & Paste

extension HTextFieldView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for sv in _sideViews where sv.config.interactive {
            if sv.view.frame.contains(point) {
                return sv.view.hitTest(convert(point, to: sv.view), with: event)
            }
        }
        if textField.frame.contains(point) { return textField }
        return super.hitTest(point, with: event)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if _forbidPaste {
            DispatchQueue.main.async {
                UIMenuController.shared.hideMenu()
            }
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    override var canBecomeFirstResponder: Bool { textField.canBecomeFirstResponder }
    @discardableResult
    override func becomeFirstResponder() -> Bool { textField.becomeFirstResponder() }
    @discardableResult
    override func resignFirstResponder() -> Bool { textField.resignFirstResponder() }
    override var isFirstResponder: Bool { textField.isFirstResponder }
}
