//
//  HTupleViewCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleLabelCell: HTupleBaseCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(label)
        return label
    }()
}

class HTupleTextCell: HTupleBaseCell {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(textView)
        return textView
    }()
}

class HTupleButtonCell: HTupleBaseCell {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(buttonView)
        return buttonView
    }()
}

class HTupleImageCell: HTupleBaseCell {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(imageView)
        return imageView
    }()
}

class HTupleFieldCell: HTupleBaseCell {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(textField)
        return textField
    }()
}

class HTupleViewCell: HTupleBaseCell {
    
    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(label)
        return label
    }()
    lazy var accsryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(label)
        return label
    }()

    
    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(textView)
        return textView
    }()
    lazy var detailText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(textView)
        return textView
    }()
    lazy var accsryText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.contentView.addSubview(textView)
        return textView
    }()

    
    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.contentView.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.contentView.addSubview(buttonView)
        return buttonView
    }()
    lazy var accsryButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.contentView.addSubview(buttonView)
        return buttonView
    }()

    
    ///imageView
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.contentView.addSubview(imageView)
        return imageView
    }()
    lazy var detailView: HWebImageView = {
        let imageView = HWebImageView()
        self.contentView.addSubview(imageView)
        return imageView
    }()
    lazy var accsryView: HWebImageView = {
        let imageView = HWebImageView()
        self.contentView.addSubview(imageView)
        return imageView
    }()

    
    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        self.contentView.addSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        self.contentView.addSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        self.contentView.addSubview(textField)
        return textField
    }()
    
}
