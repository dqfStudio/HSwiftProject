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
        self.layoutView.addArrangedSubview(label)
        return label
    }()
}

class HTupleTextApex: HTupleBaseApex {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(textView)
        return textView
    }()
}

class HTupleButtonApex: HTupleBaseApex {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addArrangedSubview(buttonView)
        return buttonView
    }()
}

class HTupleImageApex: HTupleBaseApex {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addArrangedSubview(imageView)
        return imageView
    }()
}

class HTupleAnimatedImageApex: HTupleBaseApex {
    lazy var imageView: HAnimatedImageView = {
        let imageView = HAnimatedImageView()
        self.layoutView.addArrangedSubview(imageView)
        return imageView
    }()
}

class HTupleFieldApex: HTupleBaseApex {
    lazy var textField: HTextField = {
        let textField = HTextField(frame: self.layoutView.bounds)
        self.layoutView.addArrangedSubview(textField)
        return textField
    }()
}

class HTupleViewApex: HTupleBaseApex {

    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var accsryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()


    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var detailText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var accsryText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()


    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var accsryButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()


    ///imageView
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    lazy var detailView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    lazy var accsryView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()


    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()

}
