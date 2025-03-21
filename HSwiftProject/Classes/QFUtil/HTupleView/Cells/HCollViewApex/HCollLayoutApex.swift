//
//  HCollLayoutApex.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class HCollLayoutApex: HCollTmplApex {

    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(label)
        return label
    }()
    lazy var accsryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(label)
        return label
    }()


    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(textView)
        return textView
    }()
    lazy var detailText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(textView)
        return textView
    }()
    lazy var accsryText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addArrangedSubview(textView)
        return textView
    }()


    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addArrangedSubview(buttonView)
        return buttonView
    }()
    lazy var detailButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addArrangedSubview(buttonView)
        return buttonView
    }()
    lazy var accsryButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addArrangedSubview(buttonView)
        return buttonView
    }()


    ///imageView
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addArrangedSubview(imageView)
        return imageView
    }()
    lazy var detailView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addArrangedSubview(imageView)
        return imageView
    }()
    lazy var accsryView: HWebImageView = {
        let imageView = HWebImageView()
        self.layoutView.addArrangedSubview(imageView)
        return imageView
    }()


    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        self.layoutView.addArrangedSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        self.layoutView.addArrangedSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        self.layoutView.addArrangedSubview(textField)
        return textField
    }()

}
