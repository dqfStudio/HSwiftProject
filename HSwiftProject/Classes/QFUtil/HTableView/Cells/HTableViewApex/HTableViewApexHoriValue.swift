//
//  HTableViewApexHoriValue1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

///三个label横向显示
class HTableViewApexHoriValue1 : HTableBaseApex {
    
    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        layoutView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        layoutView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: UIImageView = {
        let accessoryView = UIImageView()
        accessoryView.image = UIImage(named: "icon_tuple_arrow_right")
        accessoryView.contentMode = .scaleAspectFit
        return accessoryView
    }()
    
    ///detailLabel的宽度
    var detailWidth: CGFloat = 0.0
    
    ///accessoryLabel的宽度
    var accessoryWidth: CGFloat = 0.0
    
    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }
    
    ///显示文字内容
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
        }
        return _detailLabel!
    }
    
    private var _accessoryLabel: UILabel?
    ///显示文字内容附加信息
    var accessoryLabel: UILabel {
        if _accessoryLabel == nil {
            _accessoryLabel = UILabel()
            _accessoryLabel!.font = UIFont.systemFont(ofSize: 14)
        }
        return _accessoryLabel!
    }
    
    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var isShowAccessoryArrow: Bool = false
    
    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 0.0 {
        didSet {
            layoutView.spacing = layoutSpacing
        }
    }
    
    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0
    
    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0
    
    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0
    
    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 0.0
    
    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0
    
    /// Method called during cell initialization
    override func initUI() {
        layoutView.spacing = 10
    }
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutView.frame = frame

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(imageView)
            layoutView.setCustomSpacing(layoutFirstSpacing, after: imageView)
        }
        
        // textLayoutView
        layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        textLayoutView.spacing = textSpacing
        
        // label
        textLayoutView.addArrangedSubview(label)
        textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        
        if let detailLabel = _detailLabel {
            if detailWidth > 0 {
                detailLabel.widthAnchor.constraint(equalToConstant: detailWidth).isActive = true
            }
            textLayoutView.addArrangedSubview(detailLabel)
            textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
        }
        if let accessoryLabel = _accessoryLabel {
            if accessoryWidth > 0 {
                accessoryLabel.widthAnchor.constraint(equalToConstant: accessoryWidth).isActive = true
            }
            textLayoutView.addArrangedSubview(accessoryLabel)
        }
        
        // detailView
        if let detailView = _detailView {
            detailView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(detailView)
            layoutView.setCustomSpacing(layoutThirdSpacing, after: detailView)
        }

        // accessoryView
        if isShowAccessoryArrow {
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowLayoutView.addArrangedSubview(accessoryView)
        }
        
    }
}

///三个label纵向显示
class HTableViewApexHoriValue2 : HTableBaseApex {
    
    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        layoutView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        layoutView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: UIImageView = {
        let accessoryView = UIImageView()
        accessoryView.image = UIImage(named: "icon_tuple_arrow_right")
        accessoryView.contentMode = .scaleAspectFit
        return accessoryView
    }()
    
    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }
    
    ///显示文字内容
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
        }
        return _detailLabel!
    }
    
    private var _accessoryLabel: UILabel?
    ///显示文字内容附加信息
    var accessoryLabel: UILabel {
        if _accessoryLabel == nil {
            _accessoryLabel = UILabel()
            _accessoryLabel!.font = UIFont.systemFont(ofSize: 14)
        }
        return _accessoryLabel!
    }
    
    private var _detailView: HWebImageView?
    ///文字右边，箭头左边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var isShowAccessoryArrow: Bool = false
    
    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 0.0 {
        didSet {
            layoutView.spacing = layoutSpacing
        }
    }
    
    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0
    
    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0
    
    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0
    
    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 0.0
    
    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0
    
    /// Method called during cell initialization
    override func initUI() {
        layoutView.spacing = 10
    }
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutView.frame = frame

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(imageView)
            layoutView.setCustomSpacing(layoutFirstSpacing, after: imageView)
        }
        
        // textLayoutView
        layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        textLayoutView.spacing = textSpacing
        
        // label
        textLayoutView.addArrangedSubview(label)
        textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        
        if let detailLabel = _detailLabel {
            textLayoutView.addArrangedSubview(detailLabel)
            textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
        }
        if let accessoryLabel = _accessoryLabel {
            textLayoutView.addArrangedSubview(accessoryLabel)
        }
        
        // detailView
        if let detailView = _detailView {
            detailView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(detailView)
            layoutView.setCustomSpacing(layoutThirdSpacing, after: detailView)
        }

        // accessoryView
        if isShowAccessoryArrow {
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowLayoutView.addArrangedSubview(accessoryView)
        }

    }

}
