//
//  HTupleViewApexVertValue1.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleViewApexVertBase1 : HTupleBaseApex {
    ///imageView的上下边距
    var imageViewInsets: UITBEdgeInsets = UITBEdgeInsetsZero
    ///label的上下边距
    var labelInsets: UITBEdgeInsets = UITBEdgeInsetsZero
    ///detailLabel的上下边距
    var detailLabelInsets: UITBEdgeInsets = UITBEdgeInsetsZero
    ///accessoryLabel的上下边距
    var accessoryLabelInsets: UITBEdgeInsets = UITBEdgeInsetsZero
}

class HTupleViewApexVertValue1 : HTupleViewApexVertBase1 {
    
    ///labelLabel的高度
    var  labelHeight: CGFloat = 0
    ///detailLabel的高度
    var detailHeight: CGFloat = 0
    ///accessoryLabel的高度
    var accessoryHeight: CGFloat = 0
    
    override func relayoutSubviews() {
        self.updateSubViews()
    }

    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
            self.layoutView.addSubview(_imageView!)
        }
        return _imageView!
    }
    
    private var _label: UILabel?
     ///显示文字内容
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_label!)
        }
        return _label!
    }
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_detailLabel!)
        }
        return _detailLabel!
    }
    
    private var _accessoryLabel: UILabel?
    ///显示文字内容附加信息
    var accessoryLabel: UILabel {
        if _accessoryLabel == nil {
            _accessoryLabel = UILabel()
            _accessoryLabel!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_accessoryLabel!)
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

    private func updateSubViews() {

        let frame: CGRect = self.layoutViewBounds
        
        //计算accessoryLabel的坐标
        if _accessoryLabel != nil {
            var tmpFrame: CGRect = frame
            tmpFrame.height = self.accessoryHeight
            tmpFrame.y += self.accessoryLabelInsets.top
            tmpFrame.height -= self.accessoryLabelInsets.top + self.accessoryLabelInsets.bottom
            _accessoryLabel!.frame = tmpFrame
        }
        
        //计算imageView的坐标
        if _imageView != nil {
            var tmpFrame: CGRect = frame
            tmpFrame.height -= self.labelHeight + self.detailHeight + self.accessoryHeight
            tmpFrame.y += self.accessoryHeight
            
            tmpFrame.y += self.imageViewInsets.top
            tmpFrame.height -= self.imageViewInsets.top + self.imageViewInsets.bottom
            _imageView!.frame = tmpFrame
            
            //计算topLabel的坐标
            if self.topHeight > 0 {
                var tmpFrame: CGRect = frame
                tmpFrame.height = self.topHeight
                self.topView.frame = tmpFrame
                self.topLabel.frame = self.topView.bounds
            }
            
            //计算bottomLabel的坐标
            if self.bottomHeight > 0 {
                var tmpFrame: CGRect = frame
                tmpFrame.y = _imageView!.size.height - self.bottomHeight
                tmpFrame.height = self.bottomHeight
                self.bottomView.frame = tmpFrame
                self.bottomLabel.frame = self.bottomView.bounds
            }
        }
        
        //计算label的坐标
        if _label != nil {
            var tmpFrame: CGRect = frame
            tmpFrame.height = self.labelHeight
            
            tmpFrame.y = frame.height - self.labelHeight - self.detailHeight
            tmpFrame.y += self.labelInsets.top
            tmpFrame.height -= self.labelInsets.top + self.labelInsets.bottom
            _label!.frame = tmpFrame
        }
        
        //计算detailLabel的坐标
        if _detailLabel != nil {
            var tmpFrame: CGRect = frame
            tmpFrame.height = self.detailHeight
            
            tmpFrame.y = frame.size.height - self.detailHeight
            tmpFrame.y += self.detailLabelInsets.top
            tmpFrame.height -= self.detailLabelInsets.top + self.detailLabelInsets.bottom
            _detailLabel!.frame = tmpFrame
        }
    }
}
