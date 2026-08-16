//
//  HCollTileCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 竖向卡片共用：图上可叠顶栏 / 底栏。
class HCollTileChrome: HCollStackCell {

    var labelHeight: CGFloat = 0
    var detailHeight: CGFloat = 0
    var accessoryHeight: CGFloat = 0
    var topHeight: CGFloat = 0
    var bottomHeight: CGFloat = 0

    var layoutSpacing: CGFloat = 10
    var spacingAfterImage: CGFloat = 0
    var spacingAfterLabel: CGFloat = 0
    var spacingAfterDetailLabel: CGFloat = 0
    var spacingAfterCaption: CGFloat = 0

    private var usesLabel = false
    private var usesDetailLabel = false
    private var usesAccessoryLabel = false

    private var _imageView: HImageTextView?
    var imageView: HImageTextView {
        if let imageView = _imageView { return imageView }
        let imageView = HImageTextView()
        imageView.clipsToBounds = true
        _imageView = imageView
        setNeedsLayout()
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

    private var _topView: HImageTextView?
    var topView: HImageTextView {
        if let view = _topView { return view }
        let view = HImageTextView()
        imageView.addSubview(view)
        _topView = view
        return view
    }

    private var _topLabel: UILabel?
    var topLabel: UILabel {
        if let label = _topLabel { return label }
        let label = HCollMakeLabel()
        topView.addSubview(label)
        _topLabel = label
        return label
    }

    private var _bottomView: HImageTextView?
    var bottomView: HImageTextView {
        if let view = _bottomView { return view }
        let view = HImageTextView()
        imageView.addSubview(view)
        _bottomView = view
        return view
    }

    private var _bottomLabel: UILabel?
    var bottomLabel: UILabel {
        if let label = _bottomLabel { return label }
        let label = HCollMakeLabel()
        bottomView.addSubview(label)
        _bottomLabel = label
        return label
    }

    var createdLabel: UILabel? { usesLabel ? _label : nil }
    var createdDetailLabel: UILabel? { usesDetailLabel ? _detailLabel : nil }
    var createdAccessoryLabel: UILabel? { usesAccessoryLabel ? _accessoryLabel : nil }
    var createdImageView: HImageTextView? { _imageView }

    private var labelHeightConstraint: NSLayoutConstraint?
    private var detailHeightConstraint: NSLayoutConstraint?
    private var accessoryHeightConstraint: NSLayoutConstraint?
    private var topOverlayConstraints: [NSLayoutConstraint] = []
    private var bottomOverlayConstraints: [NSLayoutConstraint] = []
    private var topHeightConstraint: NSLayoutConstraint?
    private var bottomHeightConstraint: NSLayoutConstraint?
    private var didPinTopLabel = false
    private var didPinBottomLabel = false

    override func initUI() {
        super.initUI()
        layoutView.axis = .vertical
        layoutView.alignment = .fill
    }

    override func relayoutSubviews() {
        layoutView.axis = .vertical
        layoutView.spacing = layoutSpacing
        arrangeTiles()

        if usesLabel, let label = _label {
            setLength(labelHeight, axis: .vertical, on: label, constraint: &labelHeightConstraint)
        }
        if usesDetailLabel, let detailLabel = _detailLabel {
            setLength(detailHeight, axis: .vertical, on: detailLabel, constraint: &detailHeightConstraint)
        }
        if usesAccessoryLabel, let accessoryLabel = _accessoryLabel {
            setLength(accessoryHeight, axis: .vertical, on: accessoryLabel, constraint: &accessoryHeightConstraint)
        }

        applySpacings()
        layoutOverlays()
    }

    func arrangeTiles() {}

    func applySpacings() {
        setSpacing(spacingAfterImage, after: _imageView)
        setSpacing(spacingAfterLabel, after: usesLabel ? _label : nil)
        setSpacing(spacingAfterDetailLabel, after: usesDetailLabel ? _detailLabel : nil)
        setSpacing(spacingAfterCaption, after: usesAccessoryLabel ? _accessoryLabel : nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetLabel(_label)
        HCollResetLabel(_detailLabel)
        HCollResetLabel(_accessoryLabel)
        HCollResetLabel(_topLabel)
        HCollResetLabel(_bottomLabel)
        _imageView?.resetForReuse()
        _topView?.resetForReuse()
        _bottomView?.resetForReuse()
        labelHeight = 0
        detailHeight = 0
        accessoryHeight = 0
        topHeight = 0
        bottomHeight = 0
        layoutSpacing = 10
        spacingAfterImage = 0
        spacingAfterLabel = 0
        spacingAfterDetailLabel = 0
        spacingAfterCaption = 0
        usesLabel = false
        usesDetailLabel = false
        usesAccessoryLabel = false
        _topView?.isHidden = true
        _bottomView?.isHidden = true
    }

    private func layoutOverlays() {
        guard let imageView = _imageView else { return }
        pinOverlay(_topView, label: _topLabel, height: topHeight, to: imageView, atTop: true, constraints: &topOverlayConstraints, heightConstraint: &topHeightConstraint, didPinLabel: &didPinTopLabel)
        pinOverlay(_bottomView, label: _bottomLabel, height: bottomHeight, to: imageView, atTop: false, constraints: &bottomOverlayConstraints, heightConstraint: &bottomHeightConstraint, didPinLabel: &didPinBottomLabel)
    }

    private func pinOverlay(
        _ container: UIView?,
        label: UILabel?,
        height: CGFloat,
        to imageView: UIView,
        atTop: Bool,
        constraints: inout [NSLayoutConstraint],
        heightConstraint: inout NSLayoutConstraint?,
        didPinLabel: inout Bool
    ) {
        guard let container else { return }
        if height <= 0 {
            container.isHidden = true
            return
        }
        container.isHidden = false
        if container.superview !== imageView {
            imageView.addSubview(container)
        }
        imageView.bringSubviewToFront(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        if constraints.isEmpty {
            let heightAnchor = container.heightAnchor.constraint(equalToConstant: height)
            heightConstraint = heightAnchor
            constraints = [
                container.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                atTop
                    ? container.topAnchor.constraint(equalTo: imageView.topAnchor)
                    : container.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                heightAnchor
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            heightConstraint?.constant = height
        }

        if let label {
            if label.superview !== container {
                container.addSubview(label)
            }
            label.translatesAutoresizingMaskIntoConstraints = false
            if !didPinLabel {
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    label.topAnchor.constraint(equalTo: container.topAnchor),
                    label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                ])
                didPinLabel = true
            }
        }
    }
}

/// 上图下文。
class HCollTileCell: HCollTileChrome {

    override func arrangeTiles() {
        _ = imageView
        syncArranged([createdImageView, createdLabel, createdDetailLabel, createdAccessoryLabel], in: layoutView)
    }
}

/// 图上方还有一行标题，图下为说明。
class HCollCaptionTileCell: HCollTileChrome {

    override func arrangeTiles() {
        _ = imageView
        syncArranged([createdAccessoryLabel, createdImageView, createdLabel, createdDetailLabel], in: layoutView)
    }
}
