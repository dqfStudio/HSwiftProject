//
//  HTupleViewApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleLabelApex : HTupleBaseApex {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.label)
    }
}

class HTupleTextApex : HTupleBaseApex {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.textView)
    }
}

class HTupleButtonApex : HTupleBaseApex {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.buttonView)
    }
}

class HTupleImageApex : HTupleBaseApex {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.imageView)
    }
}

class HTupleAnimatedImageApex : HTupleBaseApex {
    lazy var imageView: HAnimatedImageView = {
        let imageView = HAnimatedImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.imageView)
    }
}

class HTupleTextFieldApex : HTupleBaseApex {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleApex(self.textField)
    }
}

class HTupleViewApex : HTupleBaseApex {

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
    lazy var accessoryLabel: UILabel = {
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
    lazy var detailTextView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var accessoryTextView: HTextView = {
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
    lazy var detailButtonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var accessoryButtonView: HWebButtonView = {
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
    lazy var detailImageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    lazy var accessoryImageView: HWebImageView = {
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
    lazy var detailTextField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var accessoryTextField: HTextField = {
        let textField = HTextField()
        HLayoutTupleApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()

}
