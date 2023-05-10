//
//  HTupleViewApexHoriValue1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

///三个label横向显示
class HTupleViewApexHoriValue1 : HTupleBaseApex {
    
    // 用于Cell布局
    lazy var layoutStackView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        self.addSubview(stackView)
        return stackView
    }()
    
    // 用于text布局
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        layoutStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        layoutStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: HWebImageView = {
        let accessoryView = HWebImageView()
        accessoryView.setImageWithName("icon_tuple_arrow_right")
        return accessoryView
    }()
    
    ///detailLabel的宽度
    var detailWidth: CGFloat = 0
    
    ///accessoryLabel的宽度
    var accessoryWidth: CGFloat = 0
    
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
    
    // 设置layoutStackView通用间隔
    func setLayoutSpacing(_ spacing: CGFloat) {
        layoutStackView.spacing = spacing
    }
    
    // 在imageView后面添加自定义间隔
    func setLayoutFirstSpacing(_ spacing: CGFloat) {
        if let imageView = _imageView {
            layoutStackView.setCustomSpacing(spacing, after: imageView)
        }
    }
    
    // 在textStackView后面添加自定义间隔
    func setLayoutSecondSpacing(_ spacing: CGFloat) {
        layoutStackView.setCustomSpacing(spacing, after: textStackView)
    }
    
    // 在detailView后面添加自定义间隔
    func setLayoutThirdSpacing(_ spacing: CGFloat) {
        if let detailView = _detailView {
            layoutStackView.setCustomSpacing(spacing, after: detailView)
        }
    }
    
    // 设置textStackView通用间隔
    func setTextSpacing(_ spacing: CGFloat) {
        textStackView.spacing = spacing
    }
    
    // 在label后面添加自定义间隔
    func setFirstTextSpacing(_ spacing: CGFloat) {
        textStackView.setCustomSpacing(spacing, after: label)
    }
    
    // 在detailLabel后面添加自定义间隔
    func setSecondTextSpacing(_ spacing: CGFloat) {
        if let detailLabel = _detailLabel {
            textStackView.setCustomSpacing(spacing, after: detailLabel)
        }
    }
    
    override func relayoutSubviews() {
        self.updateSubViews()
    }
    
    private func updateSubViews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutStackView.frame = frame

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutStackView.addArrangedSubview(imageView)
        }
        
        // label
        textStackView.addArrangedSubview(label)
        
        if let detailLabel = _detailLabel {
            if detailWidth > 0 {
                detailLabel.widthAnchor.constraint(equalToConstant: detailWidth).isActive = true
            }
            textStackView.addArrangedSubview(detailLabel)
        }
        if let accessoryLabel = _accessoryLabel {
            if accessoryWidth > 0 {
                accessoryLabel.widthAnchor.constraint(equalToConstant: accessoryWidth).isActive = true
            }
            textStackView.addArrangedSubview(accessoryLabel)
        }
        
        // detailView
        if let detailView = _detailView {
            detailView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutStackView.addArrangedSubview(detailView)
        }

        // accessoryView
        if isShowAccessoryArrow {
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowStackView.addArrangedSubview(accessoryView)
        }
        
    }
}

///三个label纵向显示
class HTupleViewApexHoriValue2 : HTupleBaseApex {
    
    // 用于Cell布局
    lazy var layoutStackView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        self.addSubview(stackView)
        return stackView
    }()
    
    // 用于text布局
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        layoutStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        layoutStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: HWebImageView = {
        let accessoryView = HWebImageView()
        accessoryView.setImageWithName("icon_tuple_arrow_right")
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
    
    // 设置layoutStackView通用间隔
    func setLayoutSpacing(_ spacing: CGFloat) {
        layoutStackView.spacing = spacing
    }
    
    // 在imageView后面添加自定义间隔
    func setLayoutFirstSpacing(_ spacing: CGFloat) {
        if let imageView = _imageView {
            layoutStackView.setCustomSpacing(spacing, after: imageView)
        }
    }
    
    // 在textStackView后面添加自定义间隔
    func setLayoutSecondSpacing(_ spacing: CGFloat) {
        layoutStackView.setCustomSpacing(spacing, after: textStackView)
    }
    
    // 在detailView后面添加自定义间隔
    func setLayoutThirdSpacing(_ spacing: CGFloat) {
        if let detailView = _detailView {
            layoutStackView.setCustomSpacing(spacing, after: detailView)
        }
    }
    
    // 设置textStackView通用间隔
    func setTextSpacing(_ spacing: CGFloat) {
        textStackView.spacing = spacing
    }
    
    // 在label后面添加自定义间隔
    func setFirstTextSpacing(_ spacing: CGFloat) {
        textStackView.setCustomSpacing(spacing, after: label)
    }
    
    // 在detailLabel后面添加自定义间隔
    func setSecondTextSpacing(_ spacing: CGFloat) {
        if let detailLabel = _detailLabel {
            textStackView.setCustomSpacing(spacing, after: detailLabel)
        }
    }
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutStackView.frame = frame

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutStackView.addArrangedSubview(imageView)
        }
        
        // label
        textStackView.addArrangedSubview(label)
        
        if let detailLabel = _detailLabel {
            textStackView.addArrangedSubview(detailLabel)
        }
        if let accessoryLabel = _accessoryLabel {
            textStackView.addArrangedSubview(accessoryLabel)
        }
        
        // detailView
        if let detailView = _detailView {
            detailView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutStackView.addArrangedSubview(detailView)
        }

        // accessoryView
        if isShowAccessoryArrow {
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowStackView.addArrangedSubview(accessoryView)
        }

    }

}
