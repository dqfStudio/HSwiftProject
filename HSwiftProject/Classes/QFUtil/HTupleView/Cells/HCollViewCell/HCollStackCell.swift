//
//  HCollStackCell.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollStackCell: HCollBaseCell {

    let layoutView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    private var _separatorView: HCellApexSeparator?
    var separatorView: HCellApexSeparator {
        if let separator = _separatorView {
            return separator
        }
        let separator = HCellApexSeparator(frame: .zero)
        separator.isHidden = true
        contentView.addSubview(separator)
        _separatorView = separator
        return separator
    }

    private var _activity: UIActivityIndicatorView?
    var activity: UIActivityIndicatorView {
        if let activity = _activity {
            return activity
        }
        let indicator = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(indicator)
        _activity = indicator
        return indicator
    }

    override var layoutViewFrame: CGRect {
        layoutView.frame
    }

    override var layoutViewBounds: CGRect {
        layoutView.bounds
    }

    override func initUI() {
        contentView.addSubview(layoutView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutView.layoutIfNeeded()
    }

    override func prepareLayout() {
        layoutView.frame = contentBounds.inset(by: contentInsets)
        layoutSeparatorIfNeeded()
        centerActivityIfNeeded()
    }

    override func fillContent(_ view: UIView) {
        if view.frame != layoutView.bounds {
            view.frame = layoutView.bounds
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _activity?.stopAnimating()
        _separatorView?.isShow = false
    }

    /// 按 `views` 的顺序同步 `stack` 的 arrangedSubviews，nil 会被跳过。
    func syncArranged(_ views: [UIView?], in stack: UIStackView) {
        let desired = views.compactMap { $0 }
        for view in stack.arrangedSubviews where !desired.contains(view) {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for (index, view) in desired.enumerated() {
            if view.superview != nil && view.superview !== stack {
                view.removeFromSuperview()
            }
            if let current = stack.arrangedSubviews.firstIndex(of: view) {
                if current != index {
                    stack.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    stack.insertArrangedSubview(view, at: index)
                }
            } else {
                stack.insertArrangedSubview(view, at: min(index, stack.arrangedSubviews.count))
            }
        }
    }

    func setLength(_ constant: CGFloat, axis: NSLayoutConstraint.Axis, on view: UIView, constraint: inout NSLayoutConstraint?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if constant <= 0 {
            constraint?.isActive = false
            return
        }
        if let constraint {
            constraint.constant = constant
            if !constraint.isActive {
                constraint.isActive = true
            }
            return
        }
        let created = (axis == .horizontal ? view.widthAnchor : view.heightAnchor).constraint(equalToConstant: constant)
        created.isActive = true
        constraint = created
    }

    func setFixedSize(_ size: CGSize, on view: UIView, width: inout NSLayoutConstraint?, height: inout NSLayoutConstraint?) {
        setLength(size.width, axis: .horizontal, on: view, constraint: &width)
        setLength(size.height, axis: .vertical, on: view, constraint: &height)
    }

    func setSpacing(_ spacing: CGFloat, after view: UIView?, in stack: UIStackView? = nil) {
        guard let view, view.superview != nil else { return }
        (stack ?? layoutView).setCustomSpacing(
            spacing > 0 ? spacing : UIStackView.spacingUseDefault,
            after: view
        )
    }

    func resolvedImageSize(for imageView: HImageTextView) -> CGSize {
        if imageView.imageSize != .zero {
            return imageView.imageSize
        }
        let rowHeight = max(layoutView.bounds.size.height, 1)
        let inset = imageView.edgeInsets
        return CGSize(
            width: max(rowHeight - inset.left - inset.right, 1),
            height: max(rowHeight - inset.top - inset.bottom, 1)
        )
    }

    private func layoutSeparatorIfNeeded() {
        guard let separator = _separatorView else { return }
        let height = 1.0 / max(contentScaleFactor, 1)
        separator.frame = CGRect(
            x: contentInsets.left,
            y: contentBounds.size.height - height,
            width: max(contentBounds.size.width - contentInsets.left - contentInsets.right, 0),
            height: height
        )
    }

    private func centerActivityIfNeeded() {
        guard let activity = _activity else { return }
        activity.center = CGPoint(x: contentBounds.midX, y: contentBounds.midY)
    }
}
