//
//  HButton.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HButtonDirection: Int {
    case horizontal = 0 // Horizontal design
    case vertical = 1 // Vertical design
}

enum HButtonImageDirection: Int {
    case left = 0 // Left design
    case right = 1 // Right design
}

class HButton: UIControl {
    
    /// 布局方向，横向或纵向布局
    var direction: HButtonDirection = .horizontal
    
    /// image布局方向，左向或右向布局
    var imageDirection: HButtonImageDirection = .left
    
    /// imageView和titleLabel之间的间隔
    var spacing: CGFloat = 5.0
    
    /// 左边布局View
    private lazy var leftView: UIView = {
        return UIView()
    }()
    
    /// 右边布局View
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    private var _imageView: UIImageView?
    var imageView: UIImageView {
        get {
            if _imageView == nil {
                _imageView = UIImageView()
            }
            return _imageView!
        }
        set {
            _imageView = newValue
        }
    }
    
    private var _titleLabel: UILabel?
    var titleLabel: UILabel {
        get {
            if _titleLabel == nil {
                _titleLabel = UILabel()
            }
            return _titleLabel!
        }
        set {
            _titleLabel = newValue
        }
    }
    
    /// 用于imageView和titleLabel布局
    private lazy var layoutView: UIStackView = {
        let layoutView = UIStackView(frame: self.bounds)
        layoutView.axis = .horizontal
        layoutView.distribution = .fill
        layoutView.alignment = .center
        self.addSubview(layoutView)
        return layoutView
    }()
    
    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }
            var _frame = frame
            _frame.origin = .zero
            layoutView.frame = _frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        /// 左边布局View
        layoutView.addArrangedSubview(leftView)
        
        if direction == .horizontal {
            
            var textWidth1 = 0.0
            var textWidth2 = 0.0
            var textSpace = spacing
            
            if imageDirection == .left {
              
                if let imageView = _imageView {
                    imageView.contentMode = (_titleLabel != nil) ? .right : .center
                    layoutView.addArrangedSubview(imageView)
                    
                    textWidth1 = imageView.intrinsicContentSize.width
                    textWidth1 = ceil(textWidth1)//向上取整
                }
                
                if let titleLabel = _titleLabel {
                    titleLabel.textAlignment = (_imageView != nil) ? .left : .center
                    layoutView.addArrangedSubview(titleLabel)
                    
                    textWidth2 = titleLabel.intrinsicContentSize.width
                    textWidth2 = ceil(textWidth2)//向上取整
                }
                
                /// 设置imageView和titleLabel之间的间隔
                if let imageView = _imageView, _titleLabel != nil {
                    layoutView.setCustomSpacing(textSpace, after: imageView)
                } else {
                    textSpace = 0.0
                }
                
            } else {
                
                if let titleLabel = _titleLabel {
                    titleLabel.textAlignment = (_imageView != nil) ? .right : .center
                    layoutView.addArrangedSubview(titleLabel)
                    
                    textWidth1 = titleLabel.intrinsicContentSize.width
                    textWidth1 = ceil(textWidth1)//向上取整
                }
                
                if let imageView = _imageView {
                    imageView.contentMode = (_titleLabel != nil) ? .left : .center
                    layoutView.addArrangedSubview(imageView)
                    
                    textWidth2 = imageView.intrinsicContentSize.width
                    textWidth2 = ceil(textWidth2)//向上取整
                }
                
                /// 设置imageView和titleLabel之间的间隔
                if let titleLabel = _titleLabel, _imageView != nil {
                    layoutView.setCustomSpacing(textSpace, after: titleLabel)
                } else {
                    textSpace = 0.0
                }
                
            }
            
            /// 左右两边的间隔
            let space = (self.width - textWidth1 - textWidth2 - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .horizontal
            
        } else {
            
            var textHeight1 = 0.0
            var textHeight2 = 0.0
            var textSpace = spacing

            if let imageView = _imageView {
                layoutView.addArrangedSubview(imageView)
                
                textHeight1 = imageView.intrinsicContentSize.height
                textHeight1 = ceil(textHeight1)//向上取整
            }
            
            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = .center
                layoutView.addArrangedSubview(titleLabel)
                
                textHeight2 = titleLabel.intrinsicContentSize.height
                textHeight2 = ceil(textHeight2)//向上取整
            }
            
            /// 设置imageView和titleLabel之间的间隔
            if let imageView = _imageView, _titleLabel != nil {
                layoutView.setCustomSpacing(textSpace, after: imageView)
            } else {
                textSpace = 0.0
            }
            
            /// 左右两边的间隔
            let space = (self.height - textHeight1 - textHeight2 - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .vertical
            
        }
        
        /// 右边布局View
        layoutView.addArrangedSubview(rightView)
        
    }
    
}
