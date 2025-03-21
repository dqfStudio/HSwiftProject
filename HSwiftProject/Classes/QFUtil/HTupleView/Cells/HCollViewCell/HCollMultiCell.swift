//
//  HCollMultiCell.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollLabelCell: HCollBaseCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(label)
        return label
    }()
}

class HCollTextCell: HCollBaseCell {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(textView)
        return textView
    }()
}

class HCollButtonCell: HCollBaseCell {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(buttonView)
        return buttonView
    }()
}

class HCollImageCell: HCollBaseCell {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(imageView)
        return imageView
    }()
}

class HCollFieldCell: HCollBaseCell {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutCollCell(textField)
        textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(textField)
        return textField
    }()
}
