//
//  HCollViewApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
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

class HCollViewApex: HCollBaseApex {

    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.addSubview(label)
        return label
    }()
    lazy var accsryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.addSubview(label)
        return label
    }()


    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.addSubview(textView)
        return textView
    }()
    lazy var detailText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.addSubview(textView)
        return textView
    }()
    lazy var accsryText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.addSubview(textView)
        return textView
    }()


    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.addSubview(buttonView)
        return buttonView
    }()
    lazy var accsryButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.addSubview(buttonView)
        return buttonView
    }()


    ///imageView
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.addSubview(imageView)
        return imageView
    }()
    lazy var detailView: HWebImageView = {
        let imageView = HWebImageView()
        self.addSubview(imageView)
        return imageView
    }()
    lazy var accsryView: HWebImageView = {
        let imageView = HWebImageView()
        self.addSubview(imageView)
        return imageView
    }()


    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutCollApex(textField)
        self.addSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        HLayoutCollApex(textField)
        self.addSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        HLayoutCollApex(textField)
        self.addSubview(textField)
        return textField
    }()

}
