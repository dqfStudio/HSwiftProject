//
//  HTableViewCellVertValue1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 三个label在imageView后依次排列
class HTableViewCellVertValue1 : HTableBaseCell {

    ///labelLabel的高度
    var labelHeight: CGFloat = 0
    ///detailLabel的高度
    var detailHeight: CGFloat = 0
    ///accessoryLabel的高度
    var accessoryHeight: CGFloat = 0

    private var _imageView: HWebImageView?
    ///显示图片
    override var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }

    private var _label: UILabel?
     ///显示文字内容
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = UIFont.systemFont(ofSize: 14)
        }
        return _label!
    }

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
    
    private var _topView: HWebImageView?
    ///imageView顶部的背景图片
    var topView: HWebImageView {
        if _topView == nil {
            _topView = HWebImageView()
            self.imageView.addSubview(_topView!)
        }
        return _topView!
    }

    private var _topLabel: UILabel?
    ///imageView顶部显示的文字内容
    var topLabel: UILabel {
        if _topLabel == nil {
            _topLabel = UILabel()
            _topLabel!.font = UIFont.systemFont(ofSize: 14)
            self.topView.addSubview(_topLabel!)
        }
        return _topLabel!
    }

    ///imageView顶部的高度
    var topHeight: CGFloat = 0

    private var _bottomView: HWebImageView?
    ///imageView底部的背景图片
    var bottomView: HWebImageView {
        if _bottomView == nil {
            _bottomView = HWebImageView()
            self.imageView.addSubview(_bottomView!)
        }
        return _bottomView!
    }

    private var _bottomLabel: UILabel?
    ///imageView底部显示的文字内容
    var bottomLabel: UILabel {
        if _bottomLabel == nil {
            _bottomLabel = UILabel()
            _bottomLabel!.font = UIFont.systemFont(ofSize: 14)
            self.bottomView.addSubview(_bottomLabel!)
        }
        return _bottomLabel!
    }

    ///imageView底部的高度
    var bottomHeight: CGFloat = 0
    
    // 设置layoutView通用间隔
    func setLayoutSpacing(_ spacing: CGFloat) {
        layoutView.spacing = spacing
    }
    
    // 在imageView后面添加自定义间隔
    func setLayoutFirstSpacing(_ spacing: CGFloat) {
        layoutView.setCustomSpacing(spacing, after: imageView)
    }
    
    // 在label后面添加自定义间隔
    func setLayoutSecondSpacing(_ spacing: CGFloat) {
        if let label = _label {
            layoutView.setCustomSpacing(spacing, after: label)
        }
    }
    
    // 在detailLabel后面添加自定义间隔
    func setLayoutThirdSpacing(_ spacing: CGFloat) {
        if let detailLabel = _detailLabel {
            layoutView.setCustomSpacing(spacing, after: detailLabel)
        }
    }
    
    /// Method called during cell initialization
    override func initUI() {
        layoutView.axis = .vertical
    }
    
    override func relayoutSubviews() {

        let frame = self.bounds.inset(by: self.edgeInsets)

        // 重设frame
        layoutView.frame = frame

        // imageView
        layoutView.addArrangedSubview(imageView)
        
        //计算topLabel的坐标
        if self.topHeight > 0 {
            var tmpFrame = CGRect.zero
            tmpFrame.width = imageView.width
            tmpFrame.height = self.topHeight
            self.topView.frame = tmpFrame
            self.topLabel.frame = self.topView.bounds
        }

        //计算bottomLabel的坐标
        if self.bottomHeight > 0 {
            var tmpFrame = CGRect.zero
            tmpFrame.width = imageView.width
            tmpFrame.y = imageView.height - self.bottomHeight
            tmpFrame.height = self.bottomHeight
            self.bottomView.frame = tmpFrame
            self.bottomLabel.frame = self.bottomView.bounds
        }

        // label
        if let label = _label, labelHeight > 0 {
            label.widthAnchor.constraint(equalToConstant: labelHeight).isActive = true
            layoutView.addArrangedSubview(label)
        }
        if let detailLabel = _detailLabel, detailHeight > 0 {
            detailLabel.widthAnchor.constraint(equalToConstant: detailHeight).isActive = true
            layoutView.addArrangedSubview(detailLabel)
        }
        if let accessoryLabel = _accessoryLabel, accessoryHeight > 0 {
            accessoryLabel.widthAnchor.constraint(equalToConstant: accessoryHeight).isActive = true
            layoutView.addArrangedSubview(accessoryLabel)
        }
        
    }
    
}

/// 两个label在imageView后依次排列，一个在imageView之上
class HTableViewCellVertValue2 : HTableBaseCell {

    ///labelLabel的高度
    var labelHeight: CGFloat = 0
    ///detailLabel的高度
    var detailHeight: CGFloat = 0
    ///accessoryLabel的高度
    var accessoryHeight: CGFloat = 0

    private var _imageView: HWebImageView?
    ///显示图片
    override var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }

    private var _label: UILabel?
     ///显示文字内容
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = UIFont.systemFont(ofSize: 14)
        }
        return _label!
    }

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
    
    private var _topView: HWebImageView?
    ///imageView顶部的背景图片
    var topView: HWebImageView {
        if _topView == nil {
            _topView = HWebImageView()
            self.imageView.addSubview(_topView!)
        }
        return _topView!
    }

    private var _topLabel: UILabel?
    ///imageView顶部显示的文字内容
    var topLabel: UILabel {
        if _topLabel == nil {
            _topLabel = UILabel()
            _topLabel!.font = UIFont.systemFont(ofSize: 14)
            self.topView.addSubview(_topLabel!)
        }
        return _topLabel!
    }

    ///imageView顶部的高度
    var topHeight: CGFloat = 0

    private var _bottomView: HWebImageView?
    ///imageView底部的背景图片
    var bottomView: HWebImageView {
        if _bottomView == nil {
            _bottomView = HWebImageView()
            self.imageView.addSubview(_bottomView!)
        }
        return _bottomView!
    }

    private var _bottomLabel: UILabel?
    ///imageView底部显示的文字内容
    var bottomLabel: UILabel {
        if _bottomLabel == nil {
            _bottomLabel = UILabel()
            _bottomLabel!.font = UIFont.systemFont(ofSize: 14)
            self.bottomView.addSubview(_bottomLabel!)
        }
        return _bottomLabel!
    }

    ///imageView底部的高度
    var bottomHeight: CGFloat = 0
    
    // 设置layoutView通用间隔
    func setLayoutSpacing(_ spacing: CGFloat) {
        layoutView.spacing = spacing
    }
    
    // 在accessoryLabel后面添加自定义间隔
    func setLayoutFirstSpacing(_ spacing: CGFloat) {
        if let accessoryLabel = _accessoryLabel {
            layoutView.setCustomSpacing(spacing, after: accessoryLabel)
        }
    }
    
    // 在imageView后面添加自定义间隔
    func setLayoutSecondSpacing(_ spacing: CGFloat) {
        layoutView.setCustomSpacing(spacing, after: imageView)
    }
    
    // 在label后面添加自定义间隔
    func setLayoutThirdSpacing(_ spacing: CGFloat) {
        if let label = _label {
            layoutView.setCustomSpacing(spacing, after: label)
        }
    }
    
    /// Method called during cell initialization
    override func initUI() {
        layoutView.axis = .vertical
    }
    
    override func relayoutSubviews() {

        let frame = self.bounds.inset(by: self.edgeInsets)

        // 重设frame
        layoutView.frame = frame
        
        if let accessoryLabel = _accessoryLabel, accessoryHeight > 0 {
            accessoryLabel.widthAnchor.constraint(equalToConstant: accessoryHeight).isActive = true
            layoutView.addArrangedSubview(accessoryLabel)
        }

        // imageView
        layoutView.addArrangedSubview(imageView)
        
        //计算topLabel的坐标
        if self.topHeight > 0 {
            var tmpFrame = CGRect.zero
            tmpFrame.width = imageView.width
            tmpFrame.height = self.topHeight
            self.topView.frame = tmpFrame
            self.topLabel.frame = self.topView.bounds
        }

        //计算bottomLabel的坐标
        if self.bottomHeight > 0 {
            var tmpFrame = CGRect.zero
            tmpFrame.width = imageView.width
            tmpFrame.y = imageView.height - self.bottomHeight
            tmpFrame.height = self.bottomHeight
            self.bottomView.frame = tmpFrame
            self.bottomLabel.frame = self.bottomView.bounds
        }

        // label
        if let label = _label, labelHeight > 0 {
            label.widthAnchor.constraint(equalToConstant: labelHeight).isActive = true
            layoutView.addArrangedSubview(label)
        }
        if let detailLabel = _detailLabel, detailHeight > 0 {
            detailLabel.widthAnchor.constraint(equalToConstant: detailHeight).isActive = true
            layoutView.addArrangedSubview(detailLabel)
        }
        
    }
    
}
