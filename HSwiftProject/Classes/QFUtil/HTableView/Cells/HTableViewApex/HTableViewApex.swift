//
//  HTableViewApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTableLabelApex : HTableBaseApex {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.label)
    }
}

class HTableTextApex : HTableBaseApex {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.textView)
    }
}

class HTableButtonApex : HTableBaseApex {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.buttonView)
    }
}

class HTableImageApex : HTableBaseApex {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.imageView)
    }
}

class HTableTextFieldApex : HTableBaseApex {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTableApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.textField)
    }
}

class HTableTextImageApex : HTableBaseApex {
    lazy var textContainer: HTextImageView = {
        let textContainer = HTextImageView()
        self.layoutView.addSubview(textContainer)
        return textContainer
    }()
    
    override func relayoutSubviews() {
        HLayoutTableApex(self.textContainer)
    }
}

class HTableViewApex : HTableBaseApex {

    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()


    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var detailTextView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var accessoryTextView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
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
        HLayoutTableApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var detailTextField: HTextField = {
        let textField = HTextField()
        HLayoutTableApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var accessoryTextField: HTextField = {
        let textField = HTextField()
        HLayoutTableApex(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()

}
