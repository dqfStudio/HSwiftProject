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
//     设置 `autoSubmitOTP(true)` 后，验证码自动填入或手动输入达到 maxLength 时，
//     触发 `onOTPFilled`（同一内容不会重复回调）。
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
        textField.font = font
        return self
    }

    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textField.textColor = color
        return self
    }

    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        textField.textAlignment = alignment
        return self
    }

    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textField.textAlignment = alignment
        return self
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
        owner._maxLength = max(0, length)
        owner.clampTextIfNeeded()
        return self
    }

    @discardableResult
    func forbidPaste(_ forbid: Bool) -> Self {
        owner._forbidPaste = forbid
        return self
    }

    @discardableResult
    func forbidWhitespace(_ forbid: Bool) -> Self {
        owner._forbidWhitespace = forbid
        return self
    }

    @discardableResult
    func editable(_ editable: Bool) -> Self {
        owner._editable = editable
        return self
    }

    // MARK: - 键盘

    @discardableResult
    func keyboard(_ type: UIKeyboardType) -> Self {
        textField.keyboardType = type
        return self
    }

    @discardableResult
    func returnKey(_ type: UIReturnKeyType) -> Self {
        textField.returnKeyType = type
        return self
    }

    @discardableResult
    func secure(_ secure: Bool) -> Self {
        textField.isSecureTextEntry = secure
        return self
    }

    // MARK: - 容器边距

    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Self {
        owner._contentInsets = insets
        return self
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
        iv.contentMode = .scaleAspectFit
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
        iv.contentMode = .scaleAspectFit
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

    /// 清空已有侧边视图。默认二次 `config` 不会抹掉未重新声明的侧边视图。
    @discardableResult
    func clearSideViews() -> Self {
        owner.removeSideViews()
        pendingLeft.removeAll()
        pendingRight.removeAll()
        return self
    }

    // MARK: - 验证码自动填充

    /// 启用验证码自动填充（textContentType = .oneTimeCode）
    @discardableResult
    func autoFillOTP(_ enable: Bool = true) -> Self {
        owner._otpEnabled = enable
        if enable {
            textField.textContentType = .oneTimeCode
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.smartDashesType = .no
            textField.smartQuotesType = .no
            textField.smartInsertDeleteType = .no
        } else {
            textField.textContentType = nil
        }
        return self
    }

    /// 自动填充完成后自动触发提交判断。
    /// 当验证码填入且长度达到 maxLength 时，触发 onOTPFilled。
    @discardableResult
    func autoSubmitOTP(_ enable: Bool = true) -> Self {
        owner._autoSubmitOTP = enable
        return self
    }

    // MARK: - 内部

    fileprivate func apply() {
        if !pendingLeft.isEmpty {
            owner.replaceSideViews(.left, with: pendingLeft)
            pendingLeft.removeAll()
        }
        if !pendingRight.isEmpty {
            owner.replaceSideViews(.right, with: pendingRight)
            pendingRight.removeAll()
        }
        owner.invalidateIntrinsicContentSize()
        owner.setNeedsLayout()
    }
}

// MARK: - HSideViewConfig

/// 侧边视图的精细配置，支持链式调用。
///
/// `insets` 是视图外侧边距，不从 `width` / `height` 中扣除。
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
    func width(_ w: CGFloat) -> Self { width = w; return self }

    @discardableResult
    func height(_ h: CGFloat) -> Self { height = h; return self }

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
final class HTextFieldView: UIView {

    /// 真正承接菜单 / 粘贴事件的内部输入框。
    /// 禁止粘贴必须拦在 UITextField 上，拦容器无效。
    private final class InnerTextField: UITextField {
        weak var container: HTextFieldView?

        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if container?._forbidPaste == true, action == #selector(paste(_:)) {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
        }

        override func paste(_ sender: Any?) {
            if container?._forbidPaste == true { return }
            super.paste(sender)
        }
    }

    // MARK: - Subview

    /// 内部文本输入框
    let textField: UITextField = {
        let tf = InnerTextField()
        tf.backgroundColor = .clear
        tf.font = .systemFont(ofSize: 14)
        return tf
    }()

    // MARK: - 侧边视图

    fileprivate var _sideViews: [HTextFieldSideView] = []
    var sideViews: [HTextFieldSideView] { _sideViews }

    func sideView(at index: Int, side: HTextFieldSideView.Side) -> UIView? {
        let filtered = _sideViews.filter { $0.side == side }
        guard index >= 0, index < filtered.count else { return nil }
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
    private var _lastSubmittedOTP: String?

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
    /// - autoSubmitOTP(false，默认)：检测到系统 OTP 整段填入时触发
    /// - autoSubmitOTP(true)：长度达到 maxLength 时触发（同一内容不重复）
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
        set {
            textField.text = clamped(newValue)
            resetOTPIfNeeded()
        }
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
        (textField as? InnerTextField)?.container = self
        addSubview(textField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    // MARK: - Internal

    fileprivate func replaceSideViews(_ side: HTextFieldSideView.Side, with pending: [PendingSideView]) {
        for sv in _sideViews where sv.side == side {
            sv.view.removeFromSuperview()
        }
        _sideViews.removeAll { $0.side == side }
        for p in pending {
            if p.config.interactive {
                p.view.isUserInteractionEnabled = true
            }
            _sideViews.append(HTextFieldSideView(view: p.view, side: side, config: p.config))
            addSubview(p.view)
        }
    }

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

    fileprivate func clampTextIfNeeded() {
        let current = textField.text
        let limited = clamped(current)
        if limited != current {
            textField.text = limited
        }
    }

    private func clamped(_ value: String?) -> String? {
        guard let value else { return nil }
        guard _maxLength > 0, value.count > _maxLength else { return value }
        return String(value.prefix(_maxLength))
    }

    private func sanitized(_ string: String) -> String {
        guard _forbidWhitespace else { return string }
        return string.filter { !$0.isWhitespace && !$0.isNewline }
    }

    private func utf16Length(_ string: String) -> Int {
        (string as NSString).length
    }

    private func isValidReplacementRange(_ range: NSRange, in string: String) -> Bool {
        range.location != NSNotFound && range.location + range.length <= utf16Length(string)
    }

    /// 按 Unicode 字符数截断替换结果，保留 range 前缀，再尽量填入 incoming / 后缀。
    private func clampedReplacement(current: String, range: NSRange, incoming: String) -> String {
        let ns = current as NSString
        let loc = min(range.location, ns.length)
        let end = min(range.location + range.length, ns.length)
        let prefix = ns.substring(to: loc)
        let suffix = ns.substring(from: end)
        guard _maxLength > 0 else { return prefix + incoming + suffix }

        var result = prefix
        let incomingBudget = _maxLength - result.count
        if incomingBudget > 0 {
            result += String(incoming.prefix(incomingBudget))
        }
        let suffixBudget = _maxLength - result.count
        if suffixBudget > 0 {
            result += String(suffix.prefix(suffixBudget))
        }
        return result
    }

    private func insertedPortion(current: String, range: NSRange, incoming: String) -> String {
        let prefix = (current as NSString).substring(to: min(range.location, utf16Length(current)))
        if _maxLength <= 0 { return incoming }
        return String(incoming.prefix(max(0, _maxLength - prefix.count)))
    }

    private func applyText(_ newText: String, cursorUTF16: Int? = nil, notify: Bool = true) {
        textField.text = newText
        if let cursorUTF16 {
            moveCursor(to: cursorUTF16)
        }
        if notify {
            onTextChange?(newText)
        }
        handleOTPAutoSubmit(newText)
    }

    private func moveCursor(to utf16Offset: Int) {
        let field = textField
        let offset = max(0, min(utf16Offset, utf16Length(field.text ?? "")))
        DispatchQueue.main.async { [weak field] in
            guard let field,
                  let pos = field.position(from: field.beginningOfDocument, offset: offset) else { return }
            field.selectedTextRange = field.textRange(from: pos, to: pos)
        }
    }

    private func emitOTPFilled(_ code: String) {
        guard _lastSubmittedOTP != code else { return }
        _lastSubmittedOTP = code
        onOTPFilled?(code)
    }

    private func resetOTPIfNeeded() {
        let value = textField.text ?? ""
        if _maxLength <= 0 || value.count < _maxLength {
            _lastSubmittedOTP = nil
        }
    }

    private func handleOTPAutoSubmit(_ value: String) {
        guard _otpEnabled, _autoSubmitOTP, _maxLength > 0, value.count >= _maxLength else { return }
        emitOTPFilled(String(value.prefix(_maxLength)))
    }

    // MARK: - Layout

    override var intrinsicContentSize: CGSize {
        let font = textField.font ?? .systemFont(ofSize: 14)
        let lineH = ceil(font.lineHeight)
        let height = lineH + _contentInsets.top + _contentInsets.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: max(height, 32))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insets = _contentInsets
        let cr = bounds.inset(by: insets)
        let ch = cr.height
        guard ch > 0 else { return }

        let lefts = _sideViews.filter { $0.side == .left }
        var lo = cr.minX
        for (i, sv) in lefts.enumerated() {
            let cfg = sv.config
            let size = resolvedSize(for: sv, containerHeight: ch)
            lo += cfg.insets.left
            sv.view.frame = CGRect(
                x: lo,
                y: alignedY(cfg: cfg, height: size.height, in: cr),
                width: size.width,
                height: size.height
            )
            lo = sv.view.frame.maxX + cfg.insets.right
            if i < lefts.count - 1 { lo += leftSpacing }
        }
        let lt = lo - cr.minX

        let rights = _sideViews.filter { $0.side == .right }
        var ro = cr.maxX
        for (i, sv) in rights.reversed().enumerated() {
            let cfg = sv.config
            let size = resolvedSize(for: sv, containerHeight: ch)
            ro -= cfg.insets.right
            sv.view.frame = CGRect(
                x: ro - size.width,
                y: alignedY(cfg: cfg, height: size.height, in: cr),
                width: size.width,
                height: size.height
            )
            ro = sv.view.frame.minX - cfg.insets.left
            if i < rights.count - 1 { ro -= rightSpacing }
        }
        let rt = cr.maxX - ro

        let tx = cr.minX + lt + (lt > 0 ? leftTextSpacing : 0)
        let tw = cr.width - lt - rt
            - (lt > 0 ? leftTextSpacing : 0)
            - (rt > 0 ? rightTextSpacing : 0)

        textField.frame = CGRect(x: tx, y: cr.minY, width: max(tw, 0), height: ch)
    }

    private func resolvedSize(for sv: HTextFieldSideView, containerHeight: CGFloat) -> CGSize {
        let cfg = sv.config
        let intrinsic = sv.view.intrinsicContentSize
        let width: CGFloat
        if cfg.width > 0 {
            width = cfg.width
        } else if intrinsic.width > 0 && intrinsic.width != UIView.noIntrinsicMetric {
            width = intrinsic.width
        } else {
            width = 0
        }
        let availableH = max(containerHeight - cfg.insets.top - cfg.insets.bottom, 0)
        let height: CGFloat
        if cfg.height > 0 {
            height = min(cfg.height, availableH)
        } else {
            height = availableH
        }
        return CGSize(width: width, height: height)
    }

    private func alignedY(cfg: HSideViewConfig, height: CGFloat, in cr: CGRect) -> CGFloat {
        switch cfg.alignment {
        case .top:
            return cr.minY + cfg.insets.top
        case .bottom:
            return cr.maxY - height - cfg.insets.bottom
        case .center:
            let top = cr.minY + cfg.insets.top
            let usable = cr.height - cfg.insets.top - cfg.insets.bottom
            return top + (usable - height) * 0.5
        }
    }

    // MARK: - Event

    @objc private func textDidChange() {
        if textField.markedTextRange == nil {
            clampTextIfNeeded()
        }
        let value = textField.text ?? ""
        resetOTPIfNeeded()
        onTextChange?(value)
        handleOTPAutoSubmit(value)
    }
}

// MARK: - UITextFieldDelegate

extension HTextFieldView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        guard _editable else { return false }
        return onShouldBeginEditing?() ?? true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 拼音等 marked text 由系统合成，长度限制放到 editingChanged 再截。
        if textField.markedTextRange != nil {
            return true
        }

        if _forbidWhitespace, string.count == 1, string.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }

        let current = textField.text ?? ""
        guard isValidReplacementRange(range, in: current) else { return false }

        let incoming = sanitized(string)
        if _forbidWhitespace, incoming.isEmpty, !string.isEmpty {
            return false
        }

        let isOTPAutoFill = _otpEnabled
            && !incoming.isEmpty
            && range.location == 0
            && range.length == utf16Length(current)
            && incoming.count > 1

        if _forbidPaste, !isOTPAutoFill, incoming.count > 1 {
            return false
        }

        let unrestricted = (current as NSString).replacingCharacters(in: range, with: incoming)
        let proposed = clampedReplacement(current: current, range: range, incoming: incoming)
        let didMutate = incoming != string || proposed != unrestricted

        if isOTPAutoFill {
            if didMutate {
                applyText(proposed, cursorUTF16: utf16Length(proposed))
            }
            if !_autoSubmitOTP {
                onOTPFilled?(proposed)
            }
            return !didMutate
        }

        if didMutate {
            if proposed == current { return false }
            let inserted = insertedPortion(current: current, range: range, incoming: incoming)
            applyText(proposed, cursorUTF16: min(range.location, utf16Length(current)) + utf16Length(inserted))
            return false
        }

        return true
    }

    func textFieldDidEndEditing(_: UITextField) {
        let before = textField.text ?? ""
        var result = before
        if _forbidWhitespace {
            result = result.filter { !$0.isWhitespace && !$0.isNewline }
        }
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        if result != before {
            textField.text = result
            onTextChange?(result)
        }
        onDidEndEditing?(result)
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        textField.resignFirstResponder()
        onReturn?(textField.text ?? "")
        return true
    }
}

// MARK: - First responder

extension HTextFieldView {
    override var canBecomeFirstResponder: Bool { textField.canBecomeFirstResponder }
    @discardableResult
    override func becomeFirstResponder() -> Bool { textField.becomeFirstResponder() }
    @discardableResult
    override func resignFirstResponder() -> Bool { textField.resignFirstResponder() }
    override var isFirstResponder: Bool { textField.isFirstResponder }
}
