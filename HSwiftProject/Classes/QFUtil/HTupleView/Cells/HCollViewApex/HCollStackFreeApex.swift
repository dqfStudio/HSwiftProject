//
//  HCollStackFreeApex.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// 自由组合：访问顺序即 Stack 排列顺序。
class HCollStackFreeApex: HCollStackApex {

    private var _label: UILabel?
    var label: UILabel { makeLabel(&_label) }
    private var _detailLabel: UILabel?
    var detailLabel: UILabel { makeLabel(&_detailLabel) }
    private var _accessoryLabel: UILabel?
    var accessoryLabel: UILabel { makeLabel(&_accessoryLabel) }

    private var _textView: HTextView?
    var textView: HTextView { makeTextView(&_textView) }
    private var _detailText: HTextView?
    var detailText: HTextView { makeTextView(&_detailText) }
    private var _accessoryText: HTextView?
    var accessoryText: HTextView { makeTextView(&_accessoryText) }

    private var _buttonView: HWebButtonView?
    var buttonView: HWebButtonView { makeButton(&_buttonView) }
    private var _detailButton: HWebButtonView?
    var detailButton: HWebButtonView { makeButton(&_detailButton) }
    private var _accessoryButton: HWebButtonView?
    var accessoryButton: HWebButtonView { makeButton(&_accessoryButton) }

    private var _imageView: HWebImageView?
    var imageView: HWebImageView { makeImage(&_imageView) }
    private var _detailImageView: HWebImageView?
    var detailImageView: HWebImageView { makeImage(&_detailImageView) }
    private var _accessoryImageView: HWebImageView?
    var accessoryImageView: HWebImageView { makeImage(&_accessoryImageView) }

    private var _textField: HTextField?
    var textField: HTextField { makeField(&_textField) }
    private var _detailField: HTextField?
    var detailField: HTextField { makeField(&_detailField) }
    private var _accessoryField: HTextField?
    var accessoryField: HTextField { makeField(&_accessoryField) }

    override func prepareForReuse() {
        super.prepareForReuse()
        [_label, _detailLabel, _accessoryLabel].forEach { HCollResetLabel($0) }
        [_textView, _detailText, _accessoryText].forEach { HCollResetTextView($0) }
        [_textField, _detailField, _accessoryField].forEach { HCollResetTextField($0) }
        [_buttonView, _detailButton, _accessoryButton].forEach { $0?.resetForReuse() }
        [_imageView, _detailImageView, _accessoryImageView].forEach { $0?.resetForReuse() }
        detachArranged()
    }

    private func detachArranged() {
        for view in layoutView.arrangedSubviews {
            layoutView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    private func attach(_ view: UIView) {
        if view.superview !== layoutView {
            layoutView.addArrangedSubview(view)
        }
        setNeedsLayout()
    }

    private func makeLabel(_ storage: inout UILabel?) -> UILabel {
        if let label = storage {
            attach(label)
            return label
        }
        let label = HCollMakeLabel()
        storage = label
        attach(label)
        return label
    }

    private func makeTextView(_ storage: inout HTextView?) -> HTextView {
        if let textView = storage {
            attach(textView)
            return textView
        }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        storage = textView
        attach(textView)
        return textView
    }

    private func makeButton(_ storage: inout HWebButtonView?) -> HWebButtonView {
        if let button = storage {
            attach(button)
            return button
        }
        let button = HWebButtonView()
        storage = button
        attach(button)
        return button
    }

    private func makeImage(_ storage: inout HWebImageView?) -> HWebImageView {
        if let imageView = storage {
            attach(imageView)
            return imageView
        }
        let imageView = HWebImageView()
        storage = imageView
        attach(imageView)
        return imageView
    }

    private func makeField(_ storage: inout HTextField?) -> HTextField {
        if let field = storage {
            attach(field)
            return field
        }
        let field = HTextField()
        storage = field
        attach(field)
        return field
    }
}
