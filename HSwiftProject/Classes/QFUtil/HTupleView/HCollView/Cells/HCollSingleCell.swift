//
//  HCollSingleCell.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollLabelCell: HCollBaseCell {
    private var _label: UILabel?
    var label: UILabel {
        if let label = _label { return label }
        let label = HCollMakeLabel()
        contentView.addSubview(label)
        _label = label
        setNeedsLayout()
        return label
    }

    override func relayoutSubviews() {
        if let label = _label {
            fillContent(label)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetLabel(_label)
    }
}

class HCollTextViewCell: HCollBaseCell {
    private var _textView: HTextView?
    var textView: HTextView {
        if let textView = _textView { return textView }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        contentView.addSubview(textView)
        _textView = textView
        setNeedsLayout()
        return textView
    }

    override func relayoutSubviews() {
        if let textView = _textView {
            fillContent(textView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetTextView(_textView)
    }
}

class HCollButtonCell: HCollBaseCell {
    private var _buttonView: HImageTextView?
    var buttonView: HImageTextView {
        if let buttonView = _buttonView { return buttonView }
        let buttonView = HImageTextView()
        contentView.addSubview(buttonView)
        _buttonView = buttonView
        setNeedsLayout()
        return buttonView
    }

    override func relayoutSubviews() {
        if let buttonView = _buttonView {
            fillContent(buttonView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _buttonView?.resetForReuse()
    }
}

class HCollImageCell: HCollBaseCell {
    private var _webImageView: HImageTextView?
    var webImageView: HImageTextView {
        if let imageView = _webImageView { return imageView }
        let imageView = HImageTextView()
        contentView.addSubview(imageView)
        _webImageView = imageView
        setNeedsLayout()
        return imageView
    }

    override func relayoutSubviews() {
        if let imageView = _webImageView {
            fillContent(imageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _webImageView?.resetForReuse()
    }
}

class HCollTextFieldCell: HCollBaseCell {
    private var _textField: HTextFieldView?
    var textField: HTextFieldView {
        if let textField = _textField { return textField }
        let textField = HTextFieldView()
        contentView.addSubview(textField)
        _textField = textField
        setNeedsLayout()
        return textField
    }

    override func relayoutSubviews() {
        if let textField = _textField {
            fillContent(textField)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetTextField(_textField)
    }
}
