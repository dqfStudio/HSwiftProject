//
//  HCollMultiApex.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollLabelApex: HCollBaseApex {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(label)
        return label
    }()
}

class HCollTextApex: HCollBaseApex {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(textView)
        return textView
    }()
}

class HCollButtonApex: HCollBaseApex {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(buttonView)
        return buttonView
    }()
}

class HCollImageApex: HCollBaseApex {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)
        return imageView
    }()
}

class HCollAnimatedImageApex: HCollBaseApex {
    lazy var imageView: HAnimatedImageView = {
        let imageView = HAnimatedImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)
        return imageView
    }()
}

class HCollFieldApex: HCollBaseApex {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutCollApex(textField)
        textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(textField)
        return textField
    }()
}
