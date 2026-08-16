//
//  UIView+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var topLineViewKey: Void?
private var bottomLineViewKey: Void?
private var singleTapGestureKey: Void?

private final class HEdgeLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {

    // MARK: - Nib

    static func fromNib(named name: String) -> UIView? {
        Bundle(for: self).loadNibNamed(name, owner: nil, options: nil)?.first as? UIView
    }

    /// nib 名用类名（不含模块前缀），从当前 class 所在 bundle 加载。
    class func fromNib() -> Self? {
        let name = String(describing: self)
        return Bundle(for: self).loadNibNamed(name, owner: nil, options: nil)?.first as? Self
    }

    // MARK: - Frame

    var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }

    var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }

    var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }

    var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }

    var origin: CGPoint {
        get { frame.origin }
        set { frame.origin = newValue }
    }

    var size: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }

    var centerX: CGFloat {
        get { center.x }
        set { center = CGPoint(x: newValue, y: center.y) }
    }

    var centerY: CGFloat {
        get { center.y }
        set { center = CGPoint(x: center.x, y: newValue) }
    }

    var minX: CGFloat { frame.minX }
    var minY: CGFloat { frame.minY }
    var midX: CGFloat { frame.midX }
    var midY: CGFloat { frame.midY }
    var maxX: CGFloat { frame.maxX }
    var maxY: CGFloat { frame.maxY }

    func centerHorizontally(in width: CGFloat) {
        x = (width - self.width) / 2
    }

    func centerVertically(in height: CGFloat) {
        y = (height - self.height) / 2
    }

    func centerHorizontallyInSuperview() {
        guard let superview else { return }
        centerX = superview.bounds.midX
    }

    func centerVerticallyInSuperview() {
        guard let superview else { return }
        centerY = superview.bounds.midY
    }

    func centerInSuperview() {
        guard let superview else { return }
        center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
    }

    func makeFrame(_ configure: () -> CGRect) {
        frame = configure()
    }

    // MARK: - Gesture

    @discardableResult
    func addDoubleTap(_ handler: @escaping (_ sender: AnyObject) -> Void) -> UITapGestureRecognizer {
        let recognizer = addTapGesture(numberOfTapsRequired: 2, handler: handler)
        if let single = objc_getAssociatedObject(self, &singleTapGestureKey) as? UITapGestureRecognizer {
            single.require(toFail: recognizer)
        }
        return recognizer
    }

    /// 多次调用只替换本方法加上的那一个单击，其它手势保留。
    @discardableResult
    func addSingleTap(_ handler: @escaping (_ sender: AnyObject) -> Void) -> UITapGestureRecognizer {
        replaceSingleTap(addTapGesture(numberOfTapsRequired: 1, handler: handler))
    }

    @discardableResult
    func addSingleTap(target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(recognizer)
        return replaceSingleTap(recognizer)
    }

    // MARK: - Separator line

    var topLineLayer: CALayer? { topLineView?.layer }
    var bottomLineLayer: CALayer? { bottomLineView?.layer }

    @discardableResult
    func addColorLayer(frame: CGRect, color: UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        self.layer.addSublayer(layer)
        return layer
    }

    func setTopLine(
        color: UIColor,
        lineHeight: CGFloat = 1,
        width: CGFloat? = nil,
        paddingLeft: CGFloat = 0,
        paddingRight: CGFloat = 0
    ) {
        let host = edgeLineHost
        let lineWidth = width ?? host.width
        installEdgeLine(
            &topLineView,
            in: host,
            color: color,
            frame: CGRect(
                x: paddingLeft,
                y: 0,
                width: max(lineWidth - paddingLeft - paddingRight, 0),
                height: lineHeight
            ),
            autoresizingMask: [.flexibleWidth]
        )
    }

    func setBottomLine(
        color: UIColor,
        lineHeight: CGFloat = 1,
        width: CGFloat? = nil,
        paddingLeft: CGFloat = 0,
        paddingRight: CGFloat = 0
    ) {
        let host = edgeLineHost
        let lineWidth = width ?? host.width
        installEdgeLine(
            &bottomLineView,
            in: host,
            color: color,
            frame: CGRect(
                x: paddingLeft,
                y: host.height - lineHeight,
                width: max(lineWidth - paddingLeft - paddingRight, 0),
                height: lineHeight
            ),
            autoresizingMask: [.flexibleWidth, .flexibleTopMargin]
        )
    }

    func setTopAndBottomLine(color: UIColor) {
        setTopLine(color: color)
        setBottomLine(color: color)
    }

    func removeTopLine() {
        topLineView?.removeFromSuperview()
        topLineView = nil
    }

    func removeBottomLine() {
        bottomLineView?.removeFromSuperview()
        bottomLineView = nil
    }

    // MARK: - Hierarchy

    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while let current = responder {
            if let controller = current as? UIViewController {
                return controller
            }
            responder = current.next
        }
        return nil
    }

    // MARK: - Appearance

    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    func roundTopCorners(_ radius: CGFloat) {
        roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
    }

    func roundBottomCorners(_ radius: CGFloat) {
        roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: radius)
    }

    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }

    // MARK: - Snapshot

    func snapshotImage() -> UIImage? {
        snapshotImage(in: bounds)
    }

    func snapshotImage(in frame: CGRect) -> UIImage? {
        guard frame.size.width > 0, frame.size.height > 0 else { return nil }
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = isOpaque
        format.scale = 0
        let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
        return renderer.image { context in
            context.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            layer.render(in: context.cgContext)
        }
    }
}

private extension UIView {

    var edgeLineHost: UIView {
        (self as? UICollectionViewCell)?.contentView
            ?? (self as? UITableViewCell)?.contentView
            ?? (self as? UITableViewHeaderFooterView)?.contentView
            ?? self
    }

    var topLineView: HEdgeLineView? {
        get { objc_getAssociatedObject(self, &topLineViewKey) as? HEdgeLineView }
        set { objc_setAssociatedObject(self, &topLineViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var bottomLineView: HEdgeLineView? {
        get { objc_getAssociatedObject(self, &bottomLineViewKey) as? HEdgeLineView }
        set { objc_setAssociatedObject(self, &bottomLineViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func addTapGesture(numberOfTapsRequired: Int, handler: @escaping (_ sender: AnyObject) -> Void) -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer(block: handler)
        recognizer.numberOfTapsRequired = numberOfTapsRequired
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        return recognizer
    }

    @discardableResult
    func replaceSingleTap(_ recognizer: UITapGestureRecognizer) -> UITapGestureRecognizer {
        if let old = objc_getAssociatedObject(self, &singleTapGestureKey) as? UITapGestureRecognizer {
            removeGestureRecognizer(old)
        }
        objc_setAssociatedObject(self, &singleTapGestureKey, recognizer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        gestureRecognizers?
            .compactMap { $0 as? UITapGestureRecognizer }
            .filter { $0.numberOfTapsRequired == 2 }
            .forEach { recognizer.require(toFail: $0) }
        return recognizer
    }

    func installEdgeLine(
        _ storage: inout HEdgeLineView?,
        in host: UIView,
        color: UIColor,
        frame: CGRect,
        autoresizingMask: UIView.AutoresizingMask
    ) {
        let line = storage ?? HEdgeLineView(frame: frame)
        line.backgroundColor = color
        line.frame = frame
        line.autoresizingMask = autoresizingMask
        if line.superview !== host {
            host.addSubview(line)
        }
        storage = line
    }
}

extension UILabel {

    func textWidth(constrainedToHeight height: CGFloat) -> CGFloat {
        text?.widthWithFont(font, constrainedToHeight: height) ?? 0
    }

    func textHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        text?.heightWithFont(font, constrainedToWidth: width) ?? 0
    }

    func attributedTextWidth(constrainedToHeight height: CGFloat) -> CGFloat {
        attributedText?.width(with: height) ?? 0
    }

    func attributedTextHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        attributedText?.height(with: width) ?? 0
    }
}

extension UITextView {

    func textWidth(constrainedToHeight height: CGFloat) -> CGFloat {
        text.widthWithFont(resolvedFont, constrainedToHeight: height)
    }

    func textHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        text.heightWithFont(resolvedFont, constrainedToWidth: width)
    }

    func attributedTextWidth(constrainedToHeight height: CGFloat) -> CGFloat {
        attributedText?.width(with: height) ?? 0
    }

    func attributedTextHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        attributedText?.height(with: width) ?? 0
    }

    private var resolvedFont: UIFont {
        font ?? .systemFont(ofSize: UIFont.systemFontSize)
    }
}
