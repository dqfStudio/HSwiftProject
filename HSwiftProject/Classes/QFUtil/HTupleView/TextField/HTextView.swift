//
//  HTextView.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/7.
//  Copyright © 2023 wind. All rights reserved.
//
//  UITextView 子类：补齐 placeholder，并按 UIKit 的 UTF-16 range / 字形簇计数
//  处理截断，避免打断拼音等 marked text。
//
//  本类会将 delegate 设为自身以落实输入限制。若外部再赋值 delegate，
//  限制逻辑会失效；placeholder 仍通过 textDidChange 通知更新。
//
//  placeholder 的 UILabel / 通知是懒加载的，cell 展示用途不会多挂子视图。
//
//  使用示例：
//  ```
//  let tv = HTextView()
//  tv.placeholder = "请输入内容"
//  tv.placeholderColor = .placeholderText
//  tv.maxInput = 200
//  tv.returnKeyType = .done
//  tv.returnBlock = { tv in tv.resignFirstResponder() }
//  tv.didChangeBlock = { tv in print(tv.text ?? "") }
//  ```
//

import UIKit

typealias HTextViewShouldBeginEditingBlock = (HTextView) -> Void
typealias HTextViewShouldEndEditingBlock = (HTextView) -> Void
typealias HTextViewDidChangeBlock = (HTextView) -> Void
typealias HTextViewDidChangeSelectionBlock = (HTextView) -> Void
typealias HTextViewDidEndEditingBlock = (HTextView) -> Void
typealias HTextViewReturnBlock = (HTextView) -> Void

/// 带 placeholder 与输入限制的 `UITextView`。
///
/// 与 `HTextFieldView` 不同：本类仍是 `UITextView` 子类，可直接作为 cell 展示 / 多行输入使用，
/// 不要再包一层容器。
class HTextView: UITextView, UITextViewDelegate {

    // MARK: - Placeholder

    /// 空内容时显示的占位文案。`UITextView` 无系统 placeholder，内部用 UILabel 模拟。
    /// 首次赋值才会创建 label 并注册通知。
    var placeholder: String? {
        didSet {
            if (placeholder ?? "").isEmpty, placeholderLabel == nil { return }
            ensurePlaceholderLabel().text = placeholder
            updatePlaceholderVisibility()
            setNeedsLayout()
        }
    }

    /// 占位颜色。默认 `.placeholderText`，跟随系统浅色 / 深色。
    var placeholderColor: UIColor = .placeholderText {
        didSet { placeholderLabel?.textColor = placeholderColor }
    }

    /// 占位字体。为 nil 时跟随 `font`。
    var placeholderFont: UIFont? {
        didSet { placeholderLabel?.font = resolvedPlaceholderFont }
    }

    // MARK: - Input

    /// 最大输入限制（按 `String.count` 字形簇）。小于等于 0 表示不限制。
    var maxInput: Int = 0 {
        didSet {
            guard maxInput != oldValue else { return }
            clampIfNeeded()
        }
    }

    /// 禁止粘贴。只拦截 paste，不影响拷贝 / 全选。
    var forbidPaste: Bool = false

    /// 禁止空白与换行。单字符输入直接拒绝；粘贴则剥离空白后再写入，而不是整段丢掉。
    var forbidWhitespaceAndNewline: Bool = false

    /// 是否允许进入编辑。赋值时同步 `isEditable`。
    /// 直接改 `isEditable` 不会回写本属性；`shouldBeginEditing` 仍以本属性为准。
    var editEnabled: Bool = true {
        didSet {
            guard editEnabled != oldValue else { return }
            isEditable = editEnabled
        }
    }

    /// 是否拦截 Return（不插入换行，触发 `returnBlock`）。
    /// `nil` 时：仅当设置了 `returnBlock` 且 `returnKeyType` 不是 `.default` 才拦截。
    var interceptReturnKey: Bool?

    // MARK: - Callbacks

    /// Return 被拦截时调用（不插入换行）。是否拦截见 `interceptReturnKey`。
    var returnBlock: HTextViewReturnBlock?
    /// 文本变化。程序化截断与随后可能补发的 `textViewDidChange` 会去重。
    var didChangeBlock: HTextViewDidChangeBlock?
    var didChangeSelectionBlock: HTextViewDidChangeSelectionBlock?
    /// 结束编辑。若开启 `forbidWhitespaceAndNewline`，回调前会先剥离空白。
    var didEndEditingBlock: HTextViewDidEndEditingBlock?
    /// 即将开始编辑的通知，返回值无效；真正能否编辑看 `editEnabled`。
    var shouldBeginEditingBlock: HTextViewShouldBeginEditingBlock?
    /// 即将结束编辑的通知，无法阻止结束。
    var shouldEndEditingBlock: HTextViewShouldEndEditingBlock?

    // MARK: - Private

    private var placeholderLabel: UILabel?
    private var didObserveTextChanges = false

    /// 避免 `text` / `attributedText` 互相赋值时递归截断。
    private var isUpdatingText = false
    /// `applyText` 之后系统可能补发 `textViewDidChange`，短窗口内忽略重复回调。
    private var lastApplyMediaTime: CFTimeInterval = 0

    private var resolvedPlaceholderFont: UIFont {
        placeholderFont ?? font ?? .systemFont(ofSize: 14)
    }

    private var shouldInterceptReturn: Bool {
        if let interceptReturnKey { return interceptReturnKey }
        guard returnBlock != nil else { return false }
        switch returnKeyType {
        case .default:
            return false
        default:
            return true
        }
    }

    // MARK: - Init

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        delegate = self
        backgroundColor = .clear
        font = .systemFont(ofSize: 14)
        isEditable = editEnabled
    }

    // MARK: - Storage

    override var text: String! {
        didSet { onTextStorageChanged() }
    }

    override var attributedText: NSAttributedString! {
        didSet { onTextStorageChanged() }
    }

    override var font: UIFont? {
        didSet {
            guard placeholderLabel != nil else { return }
            if placeholderFont == nil {
                placeholderLabel?.font = resolvedPlaceholderFont
            }
            setNeedsLayout()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            guard placeholderLabel != nil else { return }
            placeholderLabel?.textAlignment = textAlignment
            setNeedsLayout()
        }
    }

    override var textContainerInset: UIEdgeInsets {
        didSet {
            guard placeholderLabel != nil else { return }
            setNeedsLayout()
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlaceholder()
    }

    override var accessibilityLabel: String? {
        get {
            if let superLabel = super.accessibilityLabel, !superLabel.isEmpty {
                return superLabel
            }
            if !hasVisibleText, let placeholder, !placeholder.isEmpty {
                return placeholder
            }
            return super.accessibilityLabel
        }
        set { super.accessibilityLabel = newValue }
    }

    // MARK: - Paste

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if forbidPaste, action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    override func paste(_ sender: Any?) {
        guard !forbidPaste else { return }
        super.paste(sender)
    }

    // MARK: - UITextViewDelegate

    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        guard editEnabled else { return false }
        shouldBeginEditingBlock?(self)
        return true
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        shouldEndEditingBlock?(self)
        return true
    }

    func textView(_: UITextView, shouldChangeTextIn range: NSRange, replacementText replacement: String) -> Bool {
        // 拼音等 marked text 由系统合成，长度限制放到 didChange 再截。
        if markedTextRange != nil {
            return true
        }

        if replacement == "\n", shouldInterceptReturn {
            returnBlock?(self)
            return false
        }

        let current = text ?? ""
        guard isValidReplacementRange(range, in: current) else { return false }

        if forbidWhitespaceAndNewline, replacement.count == 1,
           replacement.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }

        let incoming = sanitized(replacement)
        if forbidWhitespaceAndNewline, incoming.isEmpty, !replacement.isEmpty {
            return false
        }

        let unrestricted = (current as NSString).replacingCharacters(in: range, with: incoming)
        let proposed = clampedReplacement(current: current, range: range, incoming: incoming)
        let didMutate = incoming != replacement || proposed != unrestricted

        if didMutate {
            if proposed == current { return false }
            let inserted = insertedPortion(current: current, range: range, incoming: incoming)
            let cursor = min(range.location, utf16Length(current)) + utf16Length(inserted)
            applyText(proposed, cursorUTF16: cursor, notify: true)
            return false
        }

        return true
    }

    func textViewDidChange(_: UITextView) {
        guard !isUpdatingText else { return }
        if markedTextRange == nil {
            let current = text ?? ""
            let limited = clamped(current)
            if limited != current {
                applyText(limited, cursorUTF16: utf16Length(limited), notify: true)
                return
            }
        }
        updatePlaceholderVisibility()
        // applyText 刚改过文本时系统可能再调一次，50ms 内视为同一次变更。
        if CACurrentMediaTime() - lastApplyMediaTime < 0.05 {
            return
        }
        didChangeBlock?(self)
    }

    func textViewDidChangeSelection(_: UITextView) {
        didChangeSelectionBlock?(self)
    }

    func textViewDidEndEditing(_: UITextView) {
        let before = text ?? ""
        var result = before
        // 只在显式禁止空白时剥离；不再无条件 trim 首尾，以免改掉用户有意留下的空格。
        if forbidWhitespaceAndNewline {
            result = result.filter { !$0.isWhitespace && !$0.isNewline }
        }
        if result != before {
            applyText(result, notify: true)
        }
        updatePlaceholderVisibility()
        didEndEditingBlock?(self)
    }

    // MARK: - Placeholder helpers

    /// 首次用到 placeholder 时才创建，避免 cell 展示场景多挂一个 label。
    private func ensurePlaceholderLabel() -> UILabel {
        if let placeholderLabel { return placeholderLabel }
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = placeholderColor
        label.font = resolvedPlaceholderFont
        label.textAlignment = textAlignment
        label.isUserInteractionEnabled = false
        label.isAccessibilityElement = false
        label.isHidden = true
        addSubview(label)
        placeholderLabel = label
        observeTextChangesIfNeeded()
        return label
    }

    private func observeTextChangesIfNeeded() {
        guard !didObserveTextChanges else { return }
        didObserveTextChanges = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextDidChangeNotification),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func handleTextDidChangeNotification() {
        updatePlaceholderVisibility()
    }

    private var hasVisibleText: Bool {
        if markedTextRange != nil { return true }
        return !(text ?? "").isEmpty
    }

    private func updatePlaceholderVisibility() {
        guard let placeholderLabel else { return }
        let show = !hasVisibleText && !(placeholder ?? "").isEmpty
        let becameVisible = placeholderLabel.isHidden && show
        placeholderLabel.isHidden = !show
        if show {
            placeholderLabel.font = resolvedPlaceholderFont
            placeholderLabel.textAlignment = textAlignment
        }
        if becameVisible {
            setNeedsLayout()
        }
    }

    private func layoutPlaceholder() {
        guard let placeholderLabel, !placeholderLabel.isHidden else { return }
        // `bounds` 的 origin 等于 contentOffset，滚动时空占位仍贴在可见文本原点。
        let padding = textContainer.lineFragmentPadding
        var rect = bounds.inset(by: textContainerInset)
        rect.origin.x += padding
        rect.size.width = max(rect.width - 2 * padding, 0)
        placeholderLabel.font = resolvedPlaceholderFont
        let fitting = placeholderLabel.sizeThatFits(
            CGSize(width: rect.width, height: .greatestFiniteMagnitude)
        )
        rect.size.height = min(ceil(fitting.height), max(rect.height, 0))
        placeholderLabel.frame = rect
        // UITextView 布局时会重排内部容器，不提到最前可能被盖住。
        bringSubviewToFront(placeholderLabel)
    }

    // MARK: - Text mutation

    private func onTextStorageChanged() {
        if isUpdatingText {
            updatePlaceholderVisibility()
            return
        }
        clampIfNeeded()
        updatePlaceholderVisibility()
    }

    private func applyText(_ newText: String, cursorUTF16: Int? = nil, notify: Bool) {
        if (text ?? "") != newText {
            isUpdatingText = true
            text = newText
            isUpdatingText = false
        }
        // 程序化改 text 通常不走 textViewDidChange；若系统仍补发，靠 lastApplyMediaTime 去重。
        lastApplyMediaTime = CACurrentMediaTime()
        if let cursorUTF16 {
            moveCursor(to: cursorUTF16)
        }
        updatePlaceholderVisibility()
        if notify {
            didChangeBlock?(self)
        }
    }

    private func clampIfNeeded() {
        guard markedTextRange == nil, maxInput > 0 else { return }
        let current = text ?? ""
        guard current.count > maxInput else { return }

        let prefix = String(current.prefix(maxInput))
        let utf16 = utf16Length(prefix)

        isUpdatingText = true
        // 有 attributedText 时按 UTF-16 截属性串，避免退化成纯文本丢样式。
        if let attr = attributedText, attr.length > utf16 {
            let ns = NSMutableAttributedString(attributedString: attr)
            ns.deleteCharacters(in: NSRange(location: utf16, length: attr.length - utf16))
            attributedText = ns
        } else {
            text = prefix
        }
        isUpdatingText = false
    }

    private func clamped(_ value: String) -> String {
        guard maxInput > 0, value.count > maxInput else { return value }
        return String(value.prefix(maxInput))
    }

    private func sanitized(_ string: String) -> String {
        guard forbidWhitespaceAndNewline else { return string }
        return string.filter { !$0.isWhitespace && !$0.isNewline }
    }

    /// UITextView 的 NSRange 按 UTF-16；`String.count` 按字形簇。截断时两套计数都要用。
    private func utf16Length(_ string: String) -> Int {
        (string as NSString).length
    }

    private func isValidReplacementRange(_ range: NSRange, in string: String) -> Bool {
        range.location != NSNotFound && NSMaxRange(range) <= utf16Length(string)
    }

    /// 按字形簇截断替换结果：保留 range 前缀，再尽量填入 incoming / 后缀。
    private func clampedReplacement(current: String, range: NSRange, incoming: String) -> String {
        let ns = current as NSString
        let loc = min(range.location, ns.length)
        let end = min(range.location + range.length, ns.length)
        let prefix = ns.substring(to: loc)
        let suffix = ns.substring(from: end)
        guard maxInput > 0 else { return prefix + incoming + suffix }

        var result = prefix
        let incomingBudget = maxInput - result.count
        if incomingBudget > 0 {
            result += String(incoming.prefix(incomingBudget))
        }
        let suffixBudget = maxInput - result.count
        if suffixBudget > 0 {
            result += String(suffix.prefix(suffixBudget))
        }
        return result
    }

    /// 截断后实际写入的插入段，用来把光标放到插入末尾（UTF-16）。
    private func insertedPortion(current: String, range: NSRange, incoming: String) -> String {
        let prefix = (current as NSString).substring(to: min(range.location, utf16Length(current)))
        if maxInput <= 0 { return incoming }
        return String(incoming.prefix(max(0, maxInput - prefix.count)))
    }

    private func moveCursor(to utf16Offset: Int) {
        let offset = max(0, min(utf16Offset, utf16Length(text ?? "")))
        // 赋值后系统可能立刻改 selectedRange，下一轮 runloop 再设才稳定。
        DispatchQueue.main.async { [weak self] in
            self?.selectedRange = NSRange(location: offset, length: 0)
        }
    }
}
