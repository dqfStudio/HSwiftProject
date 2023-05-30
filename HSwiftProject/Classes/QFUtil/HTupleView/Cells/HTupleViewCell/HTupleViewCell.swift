//
//  HTupleViewCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleLabelCell : HTupleBaseCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.label)
    }
}

class HTupleTextCell : HTupleBaseCell {
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.textView)
    }
}

class HTupleButtonCell : HTupleBaseCell {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.buttonView)
    }
}

class HTupleImageCell : HTupleBaseCell {
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.imageView)
    }
}

class HTupleTextFieldCell : HTupleBaseCell {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.textField)
    }
}

class HTupleTextStackCell : HTupleBaseCell {
    lazy var textStackView: HTextStackView = {
        let textStackView = HTextStackView()
        self.layoutView.addSubview(textStackView)
        return textStackView
    }()
    
    override func relayoutSubviews() {
        let frame = self.layoutViewBounds
        if !self.textStackView.frame.equalTo(frame) {
            self.textStackView.frame = frame
            self.textStackView.reloadData()
        }
    }
}

class HTupleViewCell : HTupleBaseCell {
    
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
        let detailTextView = HTextView()
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(detailTextView)
        return detailTextView
    }()
    lazy var accessoryTextView: HTextView = {
        let accessoryTextView = HTextView()
        accessoryTextView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(accessoryTextView)
        return accessoryTextView
    }()

    
    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButtonView: HWebButtonView = {
        let detailButtonView = HWebButtonView()
        self.layoutView.addSubview(detailButtonView)
        return detailButtonView
    }()
    lazy var accessoryButtonView: HWebButtonView = {
        let accessoryButtonView = HWebButtonView()
        self.layoutView.addSubview(accessoryButtonView)
        return accessoryButtonView
    }()

    
    ///imageView
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addSubview(imageView)
        return imageView
    }()
    lazy var detailImageView: HWebImageView = {
        let detailImageView = HWebImageView()
        self.layoutView.addSubview(detailImageView)
        return detailImageView
    }()
    lazy var accessoryImageView: HWebImageView = {
        let accessoryImageView = HWebImageView()
        self.layoutView.addSubview(accessoryImageView)
        return accessoryImageView
    }()

    
    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTupleCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var detailTextField: HTextField = {
        let detailTextField = HTextField()
        HLayoutTupleCell(detailTextField)
        self.layoutView.addSubview(detailTextField)
        return detailTextField
    }()
    lazy var accessoryTextField: HTextField = {
        let accessoryTextField = HTextField()
        HLayoutTupleCell(accessoryTextField)
        self.layoutView.addSubview(accessoryTextField)
        return accessoryTextField
    }()

}
