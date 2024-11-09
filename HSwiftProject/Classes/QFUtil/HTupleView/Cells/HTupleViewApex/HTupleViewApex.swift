//
//  HTupleViewApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleLabelApex: HTupleBaseApex {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(label)
        return label
    }()
}

class HTupleTextApex: HTupleBaseApex {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(textView)
        return textView
    }()
}

class HTupleButtonApex: HTupleBaseApex {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(buttonView)
        return buttonView
    }()
}

class HTupleImageApex: HTupleBaseApex {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)
        return imageView
    }()
}

class HTupleAnimatedImageApex: HTupleBaseApex {
    lazy var imageView: HAnimatedImageView = {
        let imageView = HAnimatedImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)
        return imageView
    }()
}

class HTupleFieldApex: HTupleBaseApex {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(textField)
        return textField
    }()
}

class HTupleViewApex: HTupleBaseApex {

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
        HLayoutTupleApex(textField)
        self.addSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.addSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.addSubview(textField)
        return textField
    }()

}
