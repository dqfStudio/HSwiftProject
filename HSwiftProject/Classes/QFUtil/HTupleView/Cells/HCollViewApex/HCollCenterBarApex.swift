//
//  HCollCenterBarApex.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/4.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

/// 中间图文居中条：两侧弹性 spacer 等宽，整块居中。
class HCollCenterBarApex: HCollStackApex {

    var spacingAfterImage: CGFloat = 0
    var spacingAfterLabel: CGFloat = 0
    var spacingAfterDetailLabel: CGFloat = 0
    var spacingAfterAccessoryLabel: CGFloat = 0

    private let leadingSpacer = UIView()
    private let trailingSpacer = UIView()
    private var spacerWidthConstraint: NSLayoutConstraint?

    private var usesImage = false
    private var usesLabel = false
    private var usesDetailLabel = false
    private var usesAccessoryLabel = false
    private var usesDetailImage = false

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
        if !usesLabel {
            usesLabel = true
            setNeedsLayout()
        }
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

    override func initUI() {
        super.initUI()
        layoutView.alignment = .center
        leadingSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        trailingSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leadingSpacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        trailingSpacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    override func relayoutSubviews() {
        syncArranged([
            leadingSpacer,
            usesImage ? _imageView : nil,
            usesLabel ? _label : nil,
            usesDetailLabel ? _detailLabel : nil,
            usesAccessoryLabel ? _accessoryLabel : nil,
            usesDetailImage ? _detailImageView : nil,
            trailingSpacer
        ], in: layoutView)

        if spacerWidthConstraint == nil {
            let constraint = leadingSpacer.widthAnchor.constraint(equalTo: trailingSpacer.widthAnchor)
            constraint.priority = .required
            constraint.isActive = true
            spacerWidthConstraint = constraint
        }

        setSpacing(spacingAfterImage, after: usesImage ? _imageView : nil)
        setSpacing(spacingAfterLabel, after: usesLabel ? _label : nil)
        setSpacing(spacingAfterDetailLabel, after: usesDetailLabel ? _detailLabel : nil)
        setSpacing(spacingAfterAccessoryLabel, after: usesAccessoryLabel ? _accessoryLabel : nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetLabel(_label)
        HCollResetLabel(_detailLabel)
        HCollResetLabel(_accessoryLabel)
        _imageView?.resetForReuse()
        _detailImageView?.resetForReuse()
        spacingAfterImage = 0
        spacingAfterLabel = 0
        spacingAfterDetailLabel = 0
        spacingAfterAccessoryLabel = 0
        usesImage = false
        usesLabel = false
        usesDetailLabel = false
        usesAccessoryLabel = false
        usesDetailImage = false
    }
}
