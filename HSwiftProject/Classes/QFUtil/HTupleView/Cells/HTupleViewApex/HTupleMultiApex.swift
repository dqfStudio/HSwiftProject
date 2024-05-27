//
//  HTupleMultiApex.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/27.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HMultiLabelApex: HTupleBaseApex {
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
}

class HMultiImageApex: HTupleBaseApex {
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
}

class HMultiButtonApex: HTupleBaseApex {
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
}
