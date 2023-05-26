//
//  HTupleViewCellHoriValue.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

///三个label横向从左向右抱紧显示
class HTupleViewCellHoriValue1 : HTupleBaseCell {
    
    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }
    
    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    ///label的宽度
    var labelWidth: CGFloat = 0.0
    
    ///detailLabel的宽度
    var detailWidth: CGFloat = 0.0
    
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
    
    // 用于detailView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
            _detailView!.contentMode = .scaleAspectFit
        }
        return _detailView!
    }
    
    // 用于arrow布局
    private lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    // arrow
    private lazy var accessoryView: UIImageView = {
        let accessoryView = UIImageView()
        accessoryView.image = UIImage(named: "icon_tuple_arrow_right")
        accessoryView.contentMode = .scaleAspectFill
        return accessoryView
    }()
    
    ///是否显示右边箭头
    var isShowAccessoryArrow: Bool = false
    
    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0
    
    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0
    
    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0
    
    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0
    
    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 5.0
    
    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {
            
            var imageFrame = frame
            imageFrame.width = frame.height
            imageFrame = imageFrame.inset(by: imageView.edgeInsets)
            
            imageView.widthAnchor.constraint(equalToConstant: imageFrame.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: imageFrame.height).isActive = true
            imageLayoutView.addArrangedSubview(imageView)
            
            layoutView.addArrangedSubview(imageLayoutView)
            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageLayoutView)
            }
        }
        
        // textLayoutView
        layoutView.addArrangedSubview(textLayoutView)
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }
        
        // label
        if labelWidth == 0 { labelWidth = label.intrinsicContentSize.width }
        label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        textLayoutView.addArrangedSubview(label)
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }
        
        if let accessoryLabel = _accessoryLabel {
            if detailWidth == 0 { detailWidth = detailLabel.intrinsicContentSize.width }
            detailLabel.widthAnchor.constraint(equalToConstant: detailWidth).isActive = true
            textLayoutView.addArrangedSubview(detailLabel)
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
            
            textLayoutView.addArrangedSubview(accessoryLabel)
        } else {
            if let detailLabel = _detailLabel {
                textLayoutView.addArrangedSubview(detailLabel)
            }
        }
        
        // detailView
        if let detailView = _detailView {

            var detailFrame = frame
            detailFrame.width = frame.height
            detailFrame = detailFrame.inset(by: detailView.edgeInsets)
            
            detailView.widthAnchor.constraint(equalToConstant: detailFrame.width).isActive = true
            detailView.heightAnchor.constraint(equalToConstant: detailFrame.height).isActive = true
            detailLayoutView.addArrangedSubview(detailView)
            
            layoutView.addArrangedSubview(detailLayoutView)
            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailLayoutView)
            }
        }

        // accessoryView
        if isShowAccessoryArrow {
            layoutView.addArrangedSubview(arrowLayoutView)
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowLayoutView.addArrangedSubview(accessoryView)
        }
        
    }
}

///三个label横向从右向左抱紧显示
class HTupleViewCellHoriValue2 : HTupleBaseCell {
    
    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: UIImageView = {
        let accessoryView = UIImageView()
        accessoryView.image = UIImage(named: "icon_tuple_arrow_right")
        accessoryView.contentMode = .scaleAspectFill
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
            _detailView!.contentMode = .scaleAspectFit
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var isShowAccessoryArrow: Bool = false
    
    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0
    
    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0
    
    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0
    
    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0
    
    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 5.0
    
    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(imageView)
            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageView)
            }
        }
        
        // textLayoutView
        layoutView.addArrangedSubview(textLayoutView)
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }
        
        // label
        textLayoutView.addArrangedSubview(label)
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }
        
        if let detailLabel = _detailLabel {
            if detailWidth > 0 {
                detailLabel.widthAnchor.constraint(equalToConstant: detailWidth).isActive = true
            }
            textLayoutView.addArrangedSubview(detailLabel)
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
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
            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailView)
            }
        }

        // accessoryView
        if isShowAccessoryArrow {
            layoutView.addArrangedSubview(arrowLayoutView)
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowLayoutView.addArrangedSubview(accessoryView)
        }
        
    }
}

///三个label纵向显示
class HTupleViewCellHoriValue3 : HTupleBaseCell {
    
    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    // 用于arrow布局
    lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    // arrow
    lazy private var accessoryView: UIImageView = {
        let accessoryView = UIImageView()
        accessoryView.image = UIImage(named: "icon_tuple_arrow_right")
        accessoryView.contentMode = .scaleAspectFill
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
            _detailView!.contentMode = .scaleAspectFit
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var isShowAccessoryArrow: Bool = false
    
    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0
    
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
    
    override func relayoutSubviews() {
        
        let frame = self.bounds.inset(by: self.edgeInsets)
        
        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {
            imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(imageView)
            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageView)
            }
        }
        
        // textLayoutView
        layoutView.addArrangedSubview(textLayoutView)
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }
        
        // label
        textLayoutView.addArrangedSubview(label)
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }
        
        if let detailLabel = _detailLabel {
            textLayoutView.addArrangedSubview(detailLabel)
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
        }
        if let accessoryLabel = _accessoryLabel {
            textLayoutView.addArrangedSubview(accessoryLabel)
        }
        
        // detailView
        if let detailView = _detailView {
            detailView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
            layoutView.addArrangedSubview(detailView)
            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailView)
            }
        }

        // accessoryView
        if isShowAccessoryArrow {
            layoutView.addArrangedSubview(arrowLayoutView)
            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
            arrowLayoutView.addArrangedSubview(accessoryView)
        }

    }

}
