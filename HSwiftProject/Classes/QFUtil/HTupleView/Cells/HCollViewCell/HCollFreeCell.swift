//
//  HCollFreeCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 自由组合：访问哪个控件就创建哪个，调用方自己设 frame。
class HCollFreeCell: HCollBaseCell {

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
        [_label, _detailLabel, _accessoryLabel].forEach {
            HCollResetLabel($0)
            $0?.isHidden = true
        }
        [_textView, _detailText, _accessoryText].forEach {
            HCollResetTextView($0)
            $0?.isHidden = true
        }
        [_textField, _detailField, _accessoryField].forEach {
            HCollResetTextField($0)
            $0?.isHidden = true
        }
        [_buttonView, _detailButton, _accessoryButton].forEach {
            $0?.resetForReuse()
            $0?.isHidden = true
        }
        [_imageView, _detailImageView, _accessoryImageView].forEach {
            $0?.resetForReuse()
            $0?.isHidden = true
        }
    }

    private func makeLabel(_ storage: inout UILabel?) -> UILabel {
        if let label = storage {
            label.isHidden = false
            return label
        }
        let label = HCollMakeLabel()
        contentView.addSubview(label)
        storage = label
        return label
    }

    private func makeTextView(_ storage: inout HTextView?) -> HTextView {
        if let textView = storage {
            textView.isHidden = false
            return textView
        }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        contentView.addSubview(textView)
        storage = textView
        return textView
    }

    private func makeButton(_ storage: inout HWebButtonView?) -> HWebButtonView {
        if let button = storage {
            button.isHidden = false
            return button
        }
        let button = HWebButtonView()
        contentView.addSubview(button)
        storage = button
        return button
    }

    private func makeImage(_ storage: inout HWebImageView?) -> HWebImageView {
        if let imageView = storage {
            imageView.isHidden = false
            return imageView
        }
        let imageView = HWebImageView()
        contentView.addSubview(imageView)
        storage = imageView
        return imageView
    }

    private func makeField(_ storage: inout HTextField?) -> HTextField {
        if let field = storage {
            field.isHidden = false
            return field
        }
        let field = HTextField()
        contentView.addSubview(field)
        storage = field
        return field
    }
}
