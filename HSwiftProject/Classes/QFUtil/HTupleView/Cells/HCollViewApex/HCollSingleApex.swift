//
//  HCollSingleApex.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollLabelApex: HCollBaseApex {
    private var _label: UILabel?
    var label: UILabel {
        if let label = _label { return label }
        let label = HCollMakeLabel()
        addSubview(label)
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

class HCollTextViewApex: HCollBaseApex {
    private var _textView: HTextView?
    var textView: HTextView {
        if let textView = _textView { return textView }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        addSubview(textView)
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

class HCollButtonApex: HCollBaseApex {
    private var _buttonView: HImageTextView?
    var buttonView: HImageTextView {
        if let buttonView = _buttonView { return buttonView }
        let buttonView = HImageTextView()
        addSubview(buttonView)
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

class HCollImageApex: HCollBaseApex {
    private var _webImageView: HImageTextView?
    var webImageView: HImageTextView {
        if let imageView = _webImageView { return imageView }
        let imageView = HImageTextView()
        addSubview(imageView)
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

class HCollAnimatedImageApex: HCollBaseApex {
    private var _imageView: HAnimatedImageView?
    var imageView: HAnimatedImageView {
        if let imageView = _imageView { return imageView }
        let imageView = HAnimatedImageView()
        addSubview(imageView)
        _imageView = imageView
        setNeedsLayout()
        return imageView
    }

    override func relayoutSubviews() {
        if let imageView = _imageView {
            fillContent(imageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _imageView?.image = nil
    }
}

class HCollTextFieldApex: HCollBaseApex {
    private var _textField: HTextField?
    var textField: HTextField {
        if let textField = _textField { return textField }
        let textField = HTextField()
        addSubview(textField)
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
