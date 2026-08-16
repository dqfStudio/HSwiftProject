//
//  HCollRowCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 横向行的共用骨架：[左图] [文本区] [右图] [箭头]
class HCollRowChrome: HCollStackCell {

    var labelWidth: CGFloat = 0
    var detailWidth: CGFloat = 0
    var accessoryWidth: CGFloat = 0

    var layoutSpacing: CGFloat = 10
    var spacingAfterImage: CGFloat = 0
    var spacingAfterText: CGFloat = 0
    var spacingAfterDetailImage: CGFloat = 0
    var textSpacing: CGFloat = 5
    var spacingAfterLabel: CGFloat = 0
    var spacingAfterDetailLabel: CGFloat = 0

    var showsAccessoryArrow: Bool = false
    var accessoryArrowImage: UIImage? = UIImage(named: "icon_tuple_arrow_right")

    private var usesImage = false
    private var usesDetailLabel = false
    private var usesAccessoryLabel = false
    private var usesDetailImage = false

    let textLayoutView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    let textSpacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        return view
    }()

    private let accessoryArrowView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var _imageView: HWebImageView?
    var imageView: HWebImageView {
        if !usesImage {
            usesImage = true
            setNeedsLayout()
        }
        if let imageView = _imageView { return imageView }
        let imageView = HWebImageView()
        _imageView = imageView
        return imageView
    }

    private var _label: UILabel?
    var label: UILabel {
        if let label = _label { return label }
        let label = HCollMakeLabel()
        _label = label
        return label
    }

    private var _detailLabel: UILabel?
    var detailLabel: UILabel {
        if !usesDetailLabel {
            usesDetailLabel = true
            setNeedsLayout()
        }
        if let label = _detailLabel { return label }
        let label = HCollMakeLabel()
        _detailLabel = label
        return label
    }

    private var _accessoryLabel: UILabel?
    var accessoryLabel: UILabel {
        if !usesAccessoryLabel {
            usesAccessoryLabel = true
            setNeedsLayout()
        }
        if let label = _accessoryLabel { return label }
        let label = HCollMakeLabel()
        _accessoryLabel = label
        return label
    }

    private var _detailImageView: HWebImageView?
    var detailImageView: HWebImageView {
        if !usesDetailImage {
            usesDetailImage = true
            setNeedsLayout()
        }
        if let imageView = _detailImageView { return imageView }
        let imageView = HWebImageView()
        _detailImageView = imageView
        return imageView
    }

    var createdLabel: UILabel? { _label }
    var createdDetailLabel: UILabel? { usesDetailLabel ? _detailLabel : nil }
    var createdAccessoryLabel: UILabel? { usesAccessoryLabel ? _accessoryLabel : nil }

    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var detailImageWidthConstraint: NSLayoutConstraint?
    private var detailImageHeightConstraint: NSLayoutConstraint?
    private var arrowWidthConstraint: NSLayoutConstraint?
    private var arrowHeightConstraint: NSLayoutConstraint?
    private var labelWidthConstraint: NSLayoutConstraint?
    private var detailWidthConstraint: NSLayoutConstraint?
    private var accessoryWidthConstraint: NSLayoutConstraint?

    override func initUI() {
        super.initUI()
        layoutView.alignment = .center
    }

    override func relayoutSubviews() {
        layoutView.axis = .horizontal
        layoutView.spacing = layoutSpacing
        textLayoutView.spacing = textSpacing

        if showsAccessoryArrow {
            accessoryArrowView.image = accessoryArrowImage
        }

        syncArranged([
            usesImage ? _imageView : nil,
            textLayoutView,
            usesDetailImage ? _detailImageView : nil,
            showsAccessoryArrow ? accessoryArrowView : nil
        ], in: layoutView)

        configureTextArea()

        if usesImage, let imageView = _imageView {
            setFixedSize(resolvedImageSize(for: imageView), on: imageView, width: &imageWidthConstraint, height: &imageHeightConstraint)
        }
        if usesDetailImage, let detailImage = _detailImageView {
            setFixedSize(resolvedImageSize(for: detailImage), on: detailImage, width: &detailImageWidthConstraint, height: &detailImageHeightConstraint)
        }
        if showsAccessoryArrow {
            setFixedSize(CGSize(width: 7, height: 13), on: accessoryArrowView, width: &arrowWidthConstraint, height: &arrowHeightConstraint)
        }

        if let label = _label {
            setLength(labelWidth, axis: .horizontal, on: label, constraint: &labelWidthConstraint)
        }
        if usesDetailLabel, let detailLabel = _detailLabel {
            setLength(detailWidth, axis: .horizontal, on: detailLabel, constraint: &detailWidthConstraint)
        }
        if usesAccessoryLabel, let accessoryLabel = _accessoryLabel {
            setLength(accessoryWidth, axis: .horizontal, on: accessoryLabel, constraint: &accessoryWidthConstraint)
        }

        setSpacing(spacingAfterImage, after: usesImage ? _imageView : nil)
        setSpacing(spacingAfterText, after: textLayoutView)
        setSpacing(spacingAfterDetailImage, after: usesDetailImage ? _detailImageView : nil)
        setSpacing(spacingAfterLabel, after: _label, in: textLayoutView)
        setSpacing(spacingAfterDetailLabel, after: usesDetailLabel ? _detailLabel : nil, in: textLayoutView)
    }

    func configureTextArea() {}

    func hugHorizontally(_ views: [UIView?]) {
        views.compactMap { $0 }.forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetLabel(_label)
        HCollResetLabel(_detailLabel)
        HCollResetLabel(_accessoryLabel)
        _imageView?.resetForReuse()
        _detailImageView?.resetForReuse()
        showsAccessoryArrow = false
        usesImage = false
        usesDetailLabel = false
        usesAccessoryLabel = false
        usesDetailImage = false
        labelWidth = 0
        detailWidth = 0
        accessoryWidth = 0
        layoutSpacing = 10
        spacingAfterImage = 0
        spacingAfterText = 0
        spacingAfterDetailImage = 0
        textSpacing = 5
        spacingAfterLabel = 0
        spacingAfterDetailLabel = 0
    }
}

/// 文案从左抱紧，中间没有弹性空位。
class HCollPackedRowCell: HCollRowChrome {

    override func configureTextArea() {
        textLayoutView.axis = .horizontal
        textLayoutView.alignment = .fill
        textLayoutView.distribution = .fill
        textLayoutView.setContentHuggingPriority(.required, for: .horizontal)
        textLayoutView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        _ = label
        syncArranged([createdLabel, createdDetailLabel, createdAccessoryLabel], in: textLayoutView)
        hugHorizontally([createdLabel, createdDetailLabel, createdAccessoryLabel])
    }
}

/// 标题在左，详情/附加靠右。
class HCollValueRowCell: HCollRowChrome {

    override func configureTextArea() {
        textLayoutView.axis = .horizontal
        textLayoutView.alignment = .fill
        textLayoutView.distribution = .fill
        textLayoutView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        textLayoutView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        _ = label
        syncArranged([createdLabel, textSpacer, createdDetailLabel, createdAccessoryLabel], in: textLayoutView)
        hugHorizontally([createdLabel, createdDetailLabel, createdAccessoryLabel])
        textSpacer.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        textSpacer.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
    }
}

/// 中间标题 / 副标题 / 附加竖着叠。
class HCollSubtitleRowCell: HCollRowChrome {

    override func initUI() {
        super.initUI()
        textSpacing = 0
    }

    override func configureTextArea() {
        textLayoutView.axis = .vertical
        textLayoutView.alignment = .fill
        textLayoutView.distribution = .fill
        textLayoutView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textLayoutView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        _ = label
        syncArranged([createdLabel, createdDetailLabel, createdAccessoryLabel], in: textLayoutView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textSpacing = 0
    }
}
