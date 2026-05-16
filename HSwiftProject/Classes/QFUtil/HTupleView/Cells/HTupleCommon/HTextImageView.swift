//
//  HTextImageView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/26.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTextImageView: UIStackView {
    
    /// 左边布局View
    private lazy var leftView: UIView = {
        return UIView()
    }()
    
    /// 右边布局View
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    /// 中间label、detailLabel和accsryLabel布局View
    private lazy var textLayoutView: UIStackView = {
        return UIStackView()
    }()
    
    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    /// imageView
    private var _imageView: HWebImageView?
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }
    
    /// label
    private var _label: UILabel?
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = .systemFont(ofSize: 14.0)
        }
        return _label!
    }
    
    /// detailLabel
    private var _detailLabel: UILabel?
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _detailLabel!
    }
    
    /// accsryLabel
    private var _accsryLabel: UILabel?
    var accsryLabel: UILabel {
        if _accsryLabel == nil {
            _accsryLabel = UILabel()
            _accsryLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _accsryLabel!
    }
    
    // 用于imageView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    /// imageView
    private var _detailView: HWebImageView?
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }
    
    // 在imageView后面添加自定义间隔
    var imageSpacing: CGFloat = 0.0
    
    // 在label后面添加自定义间隔
    var labelSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var detailSpacing: CGFloat = 0.0
    
    // 在accsryLabel后面添加自定义间隔
    var accsrySpacing: CGFloat = 0.0
    
    private var didSetup = false

    override func layoutSubviews() {
        super.layoutSubviews()
        if !didSetup {
            setup()
            didSetup = true
        }
        relayout()
    }

    private func setup() {
        self.addArrangedSubview(leftView)
        self.addArrangedSubview(textLayoutView)
        self.addArrangedSubview(rightView)

        if let imageView = _imageView {
            imageLayoutView.addArrangedSubview(imageView)
            textLayoutView.addArrangedSubview(imageLayoutView)
        }
        if let label = _label {
            textLayoutView.addArrangedSubview(label)
        }
        if let detailLabel = _detailLabel {
            textLayoutView.addArrangedSubview(detailLabel)
        }
        if let accsryLabel = _accsryLabel {
            textLayoutView.addArrangedSubview(accsryLabel)
        }
        if let detailView = _detailView {
            detailLayoutView.addArrangedSubview(detailView)
            textLayoutView.addArrangedSubview(detailLayoutView)
        }
    }

    private func relayout() {
        textLayoutView.setCustomSpacing(imageSpacing, after: imageLayoutView)
        if let _ = _label {
            textLayoutView.setCustomSpacing(labelSpacing, after: label)
        }
        if let _ = _detailLabel {
            textLayoutView.setCustomSpacing(detailSpacing, after: detailLabel)
        }
        if let _ = _accsryLabel {
            textLayoutView.setCustomSpacing(accsrySpacing, after: accsryLabel)
        }

        var textWidth = 0.0
        if let label = _label {
            textWidth += label.intrinsicContentSize.width
        }
        if let detailLabel = _detailLabel {
            textWidth += detailLabel.intrinsicContentSize.width
        }
        if let accsryLabel = _accsryLabel {
            textWidth += accsryLabel.intrinsicContentSize.width
        }
        if let imageView = _imageView {
            textWidth += imageView.intrinsicContentSize.width
        }
        if let detailView = _detailView {
            textWidth += detailView.intrinsicContentSize.width
        }
        textWidth += imageSpacing + labelSpacing + detailSpacing + accsrySpacing
        textWidth = ceil(textWidth)

        let space = (self.width - textWidth) / 2
        if space >= 0 { self.spacing = space }
    }
    
}
