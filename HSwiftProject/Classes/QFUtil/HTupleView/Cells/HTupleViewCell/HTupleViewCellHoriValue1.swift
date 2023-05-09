//
//  HTupleViewCellHoriValue1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var KArrowSpace: CGFloat = 10

class HTupleViewCellHoriBase1 : HTupleBaseCell {
    ///imageView的上下左右边距
    var imageViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    ///两个label的间距
    var labelInterval: CGFloat = 5
    ///中间label的左右边距
    var centralInsets: UILREdgeInsets = UILREdgeInsets(left: 10, right: 10)
    ///detailView的上下左右边距
    var detailViewInsets: UIEdgeInsets = UIEdgeInsets.zero
}

class HTupleViewCellHoriBase2 : HTupleBaseCell {
    ///imageView的上下左右边距
    var imageViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    ///label的左右边距
    var labelInsets: UILREdgeInsets = UILREdgeInsets.zero
    ///detailLabel的左右边距
    var detailLabelInsets: UILREdgeInsets = UILREdgeInsets.zero
    ///accessoryLabel的左右边距
    var accessoryLabelInsets: UILREdgeInsets = UILREdgeInsets.zero
    ///中间label的左右边距
    var centralInsets: UILREdgeInsets = UILREdgeInsets(left: 10, right: 10)
    ///detailView的上下左右边距
    var detailViewInsets: UIEdgeInsets = UIEdgeInsets.zero
}

class HTupleViewCellHoriBase3 : HTupleBaseCell {
    ///imageView的上下左右边距
    var imageViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    ///label的上下边距
    var labelInsets: UITBEdgeInsets = UITBEdgeInsets.zero
    ///detailLabel的上下边距
    var detailLabelInsets: UITBEdgeInsets = UITBEdgeInsets.zero
    ///accessoryLabel的上下边距
    var accessoryLabelInsets: UITBEdgeInsets = UITBEdgeInsets.zero
    ///中间label的左右边距
    var centralInsets: UILREdgeInsets = UILREdgeInsets(left: 10, right: 10)
    ///detailView的上下左右边距
    var detailViewInsets: UIEdgeInsets = UIEdgeInsets.zero
}

///两个label左右相距排列
class HTupleViewCellHoriValue1 : HTupleViewCellHoriBase1 {
    
    private var _textCentralView: UIView?
    private var textCentralView: UIView {
        if _textCentralView == nil {
            _textCentralView = UIView()
            self.layoutView.addSubview(_textCentralView!)
        }
        return _textCentralView!
    }
    
    private var _accessoryView: HWebImageView?
    private var accessoryView: HWebImageView {
        if _accessoryView == nil {
            _accessoryView = HWebImageView()
            _accessoryView!.setImageWithName("icon_tuple_arrow_right")
            self.layoutView.addSubview(_accessoryView!)
        }
        return _accessoryView!
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
            self.textCentralView.addSubview(_label!)
        }
        return _label!
    }
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
            self.textCentralView.addSubview(_detailLabel!)
        }
        return _detailLabel!
    }
    
    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
            self.layoutView.addSubview(_detailView!)
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var showAccessoryArrow: Bool = false
    
    override func relayoutSubviews() {
        self.updateSubViews()
    }

    private func updateSubViews() {
        let frame: CGRect = self.layoutViewBounds
        var tmpFrame1: CGRect = frame
        var tmpFrame2: CGRect = CGRect.zero
        var tmpFrame3: CGRect = frame
        var tmpFrame4: CGRect = frame
        
        //计算imageView的坐标
        if _imageView != nil {
            tmpFrame1.width = tmpFrame1.height //默认宽高相等
            tmpFrame1.x += self.imageViewInsets.left
            tmpFrame1.y += self.imageViewInsets.top
            tmpFrame1.width -= self.imageViewInsets.left + self.imageViewInsets.right
            tmpFrame1.height -= self.imageViewInsets.top + self.imageViewInsets.bottom
            _imageView!.frame = tmpFrame1
            //计算tmpFrame4的x坐标
            tmpFrame4.x = _imageView!.maxX + self.centralInsets.left
        }
        
        //计算accessoryView的坐标
        if self.showAccessoryArrow { tmpFrame2 = CGRect(x: 0, y: 0, width: 7, height: 13) }
        tmpFrame2.x = frame.width - tmpFrame2.width
        tmpFrame2.y = frame.height / 2 - tmpFrame2.height / 2
        if self.showAccessoryArrow { self.accessoryView.frame = tmpFrame2 }
        
        //计算detailView的坐标
        if _detailView != nil {
            tmpFrame3.width = tmpFrame3.height //默认宽高相等
            tmpFrame3.x = tmpFrame2.minX - tmpFrame3.width
            if self.showAccessoryArrow { tmpFrame3.x -= KArrowSpace }
            
            tmpFrame2.x += self.detailViewInsets.left
            tmpFrame2.y += self.detailViewInsets.top
            tmpFrame2.width -= self.detailViewInsets.left + self.detailViewInsets.right
            tmpFrame2.height -= self.detailViewInsets.top + self.detailViewInsets.bottom
            _detailView!.frame = tmpFrame3
        }
        
        //计算textCentralView的宽度
        if _detailView != nil {
            tmpFrame4.width = _detailView!.minX - tmpFrame4.x - self.centralInsets.right
        }else if _accessoryView != nil {
            tmpFrame4.width = _accessoryView!.minX - tmpFrame4.x - KArrowSpace
        }else {
            tmpFrame4.width = frame.width - tmpFrame4.x
        }
        
        //计算textCentralView的坐标
        self.textCentralView.frame = tmpFrame4
        
        //计算label和detailLabel的坐标
        if self.label.text != nil && self.detailLabel.text != nil {
            var wordWidth: CGFloat = 20 //默认为20
            wordWidth = self.detailLabel.intrinsicContentSize.width / CGFloat(self.detailLabel.text!.length)
            if wordWidth < 20 { wordWidth += wordWidth }
            if self.label.intrinsicContentSize.width >= tmpFrame4.width - self.labelInterval - wordWidth {
                self.label.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
                self.detailLabel.frame = CGRect.zero
            }else {
                self.label.frame = CGRect(x: 0, y: 0, width: self.label.intrinsicContentSize.width, height: tmpFrame4.height)
                self.detailLabel.frame = CGRect(x: self.label.intrinsicContentSize.width + self.labelInterval,
                                                y: 0,
                                                width: tmpFrame4.width - self.label.intrinsicContentSize.width - self.labelInterval,
                                                height: tmpFrame4.height)
            }
        }else if self.detailLabel.text != nil {
            self.detailLabel.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
            self.label.frame = CGRect.zero
        }else {
            self.label.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
            self.detailLabel.frame = CGRect.zero
        }
    }
}

///两个label左右对立排列
class HTupleViewCellHoriValue2 : HTupleViewCellHoriBase1 {

    private var _textCentralView: UIView?
    private var textCentralView: UIView {
        if _textCentralView == nil {
            _textCentralView = UIView()
            self.layoutView.addSubview(_textCentralView!)
        }
        return _textCentralView!
    }

    private var _accessoryView: HWebImageView?
    private var accessoryView: HWebImageView {
        if _accessoryView == nil {
            _accessoryView = HWebImageView()
            _accessoryView!.setImageWithName("icon_tuple_arrow_right")
            self.layoutView.addSubview(_accessoryView!)
        }
        return _accessoryView!
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
            self.textCentralView.addSubview(_label!)
        }
        return _label!
    }
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
            self.textCentralView.addSubview(_detailLabel!)
        }
        return _detailLabel!
    }
    
    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
            self.layoutView.addSubview(_detailView!)
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var showAccessoryArrow: Bool = false
        
    override func relayoutSubviews() {
        self.updateSubViews()
    }

    private func updateSubViews() {
        let frame: CGRect = self.layoutViewBounds
        var tmpFrame1: CGRect = frame
        var tmpFrame2: CGRect = CGRect.zero
        var tmpFrame3: CGRect = frame
        var tmpFrame4: CGRect = frame
        
        //计算imageView的坐标
        if _imageView != nil {
            tmpFrame1.width = tmpFrame1.height //默认宽高相等
            tmpFrame1.x += self.imageViewInsets.left
            tmpFrame1.y += self.imageViewInsets.top
            tmpFrame1.width -= self.imageViewInsets.left + self.imageViewInsets.right
            tmpFrame1.height -= self.imageViewInsets.top + self.imageViewInsets.bottom
            _imageView!.frame = tmpFrame1
            //计算tmpFrame4的x坐标
            tmpFrame4.x = _imageView!.maxX + self.centralInsets.left
        }
        
        //计算accessoryView的坐标
        if self.showAccessoryArrow { tmpFrame2 = CGRect(x: 0, y: 0, width: 7, height: 13) }
        tmpFrame2.x = frame.width - tmpFrame2.width
        tmpFrame2.y = frame.height / 2 - tmpFrame2.height / 2
        if self.showAccessoryArrow { self.accessoryView.frame = tmpFrame2 }
        
        //计算detailView的坐标
        if _detailView != nil {
            tmpFrame3.width = tmpFrame3.height //默认宽高相等
            tmpFrame3.x = tmpFrame2.minX - tmpFrame3.width
            if self.showAccessoryArrow { tmpFrame3.x -= KArrowSpace }
            
            tmpFrame2.x += self.detailViewInsets.left
            tmpFrame2.y += self.detailViewInsets.top
            tmpFrame2.width -= self.detailViewInsets.left + self.detailViewInsets.right
            tmpFrame2.height -= self.detailViewInsets.top + self.detailViewInsets.bottom
            _detailView!.frame = tmpFrame3
        }
        
        //计算textCentralView的宽度
        if _detailView != nil {
            tmpFrame4.width = _detailView!.minX - tmpFrame4.x - self.centralInsets.right
        }else if _accessoryView != nil {
            tmpFrame4.width = _accessoryView!.minX - tmpFrame4.x - KArrowSpace
        }else {
            tmpFrame4.width = frame.width - tmpFrame4.x
        }
        
        //计算textCentralView的坐标
        self.textCentralView.frame = tmpFrame4
        
        //计算label和detailLabel的坐标
        if self.label.text != nil && self.detailLabel.text != nil {
            var wordWidth: CGFloat = 20 //默认为20
            wordWidth = self.detailLabel.intrinsicContentSize.width / CGFloat(self.detailLabel.text!.length)
            if wordWidth < 20 { wordWidth += wordWidth }
            if self.detailLabel.intrinsicContentSize.width >= tmpFrame4.width - self.labelInterval - wordWidth {
                self.detailLabel.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
                self.label.frame = CGRect.zero
            }else {
                self.label.frame = CGRect(x: 0, y: 0,
                                          width: tmpFrame4.width - self.detailLabel.intrinsicContentSize.width - self.labelInterval,
                                          height: tmpFrame4.height)
                self.detailLabel.frame = CGRect(x: tmpFrame4.width - self.detailLabel.intrinsicContentSize.width,
                                                y: 0,
                                                width: self.detailLabel.intrinsicContentSize.width,
                                                height: tmpFrame4.height)
            }
        }else if self.detailLabel.text != nil {
            self.detailLabel.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
            self.label.frame = CGRect.zero
        }else {
            self.label.frame = CGRect(x: 0, y: 0, width: tmpFrame4.width, height: tmpFrame4.height)
            self.detailLabel.frame = CGRect.zero
        }
    }
}

///三个label横向显示
class HTupleViewCellHoriValue3 : HTupleViewCellHoriBase2 {
    
    private var _textCentralView: UIView?
    private var textCentralView: UIView {
        if _textCentralView == nil {
            _textCentralView = UIView()
            self.layoutView.addSubview(_textCentralView!)
        }
        return _textCentralView!
    }
    
    private var _accessoryView: HWebImageView?
    private var accessoryView: HWebImageView {
        if _accessoryView == nil {
            _accessoryView = HWebImageView()
            _accessoryView!.setImageWithName("icon_tuple_arrow_right")
            self.layoutView.addSubview(_accessoryView!)
        }
        return _accessoryView!
    }
    
    ///左边detailLabel的宽度
    var detailWidth: CGFloat = 0
    ///右边accessoryLabel的宽度
    var accessoryWidth: CGFloat = 0
    
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
            self.textCentralView.addSubview(_label!)
        }
        return _label!
    }
    
    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
            self.textCentralView.addSubview(_detailLabel!)
        }
        return _detailLabel!
    }
    
    private var _accessoryLabel: UILabel?
    ///显示文字内容附加信息
    var accessoryLabel: UILabel {
        if _accessoryLabel == nil {
            _accessoryLabel = UILabel()
            _accessoryLabel!.font = UIFont.systemFont(ofSize: 14)
            self.textCentralView.addSubview(_accessoryLabel!)
        }
        return _accessoryLabel!
    }
    
    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
            self.layoutView.addSubview(_detailView!)
        }
        return _detailView!
    }
    ///是否显示右边箭头
    var showAccessoryArrow: Bool = false
    
    override func relayoutSubviews() {
        self.updateSubViews()
    }
    
    private func updateSubViews() {
        let frame: CGRect = self.layoutViewBounds
        var tmpFrame1: CGRect = frame
        var tmpFrame2: CGRect = CGRect.zero
        var tmpFrame3: CGRect = frame
        var tmpFrame4: CGRect = frame
        
        //计算imageView的坐标
        if _imageView != nil {
            tmpFrame1.width = tmpFrame1.height //默认宽高相等
            tmpFrame1.x += self.imageViewInsets.left
            tmpFrame1.y += self.imageViewInsets.top
            tmpFrame1.width -= self.imageViewInsets.left + self.imageViewInsets.right
            tmpFrame1.height -= self.imageViewInsets.top + self.imageViewInsets.bottom
            _imageView!.frame = tmpFrame1
            //计算tmpFrame4的x坐标
            tmpFrame4.x = _imageView!.maxX + self.centralInsets.left
        }
        
        //计算accessoryView的坐标
        if self.showAccessoryArrow { tmpFrame2 = CGRect(x: 0, y: 0, width: 7, height: 13) }
        tmpFrame2.x = frame.width - tmpFrame2.width
        tmpFrame2.y = frame.height / 2 - tmpFrame2.height / 2
        if self.showAccessoryArrow { self.accessoryView.frame = tmpFrame2 }
        
        //计算detailView的坐标
        if _detailView != nil {
            tmpFrame3.width = tmpFrame3.height //默认宽高相等
            tmpFrame3.x = tmpFrame2.minX - tmpFrame3.width
            if self.showAccessoryArrow { tmpFrame3.x -= KArrowSpace }
            
            tmpFrame2.x += self.detailViewInsets.left
            tmpFrame2.y += self.detailViewInsets.top
            tmpFrame2.width -= self.detailViewInsets.left + self.detailViewInsets.right
            tmpFrame2.height -= self.detailViewInsets.top + self.detailViewInsets.bottom
            _detailView!.frame = tmpFrame3
        }
        
        //计算textCentralView的宽度
        if _detailView != nil {
            tmpFrame4.width = _detailView!.minX - tmpFrame4.x - self.centralInsets.right
        }else if _accessoryView != nil {
            tmpFrame4.width = _accessoryView!.minX - tmpFrame4.x - KArrowSpace
        }else {
            tmpFrame4.width = frame.width - tmpFrame4.x
        }
        
        //计算textCentralView的坐标
        self.textCentralView.frame = tmpFrame4
        
        //保存textCentralView的值
        let tmpFrame5: CGRect = self.textCentralView.bounds
        
        //计算accessoryLabel的坐标
        if self.accessoryWidth > 0 {
            var tmpFrame6: CGRect = tmpFrame5
            tmpFrame6.size.width = self.accessoryWidth
            tmpFrame6.origin.x += self.accessoryLabelInsets.left
            tmpFrame6.size.width -= self.accessoryLabelInsets.left + self.accessoryLabelInsets.right
            self.accessoryLabel.frame = tmpFrame6
        }
        
        //计算detailLabel的坐标
        if self.detailWidth > 0 {
            var tmpFrame7: CGRect = tmpFrame5
            tmpFrame7.origin.x = tmpFrame5.width - self.detailWidth
            tmpFrame7.size.width = self.detailWidth
            tmpFrame7.origin.x += self.detailLabelInsets.left
            tmpFrame7.size.width -= self.detailLabelInsets.left + self.detailLabelInsets.right
            self.detailLabel.frame = tmpFrame7
        }
        
        //计算label的坐标
        var tmpFrame8: CGRect = tmpFrame5
        tmpFrame8.x = self.accessoryWidth
        tmpFrame8.width = tmpFrame5.width - self.detailWidth - self.accessoryWidth
        tmpFrame8.x += self.labelInsets.left
        tmpFrame8.width -= self.labelInsets.left + self.labelInsets.right
        self.label.frame = tmpFrame8
    }
}

///三个label纵向显示
class HTupleViewCellHoriValue4 : HTupleViewCellHoriBase3 {
    
    private var _accessoryView: HWebImageView?
    private var accessoryView: HWebImageView {
        if _accessoryView == nil {
            _accessoryView = HWebImageView()
            _accessoryView!.setImageWithName("icon_tuple_arrow_right")
            self.layoutView.addSubview(_accessoryView!)
        }
        return _accessoryView!
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
    
    private var _detailView: HWebImageView?
    ///文字右边，箭头左边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
            self.layoutView.addSubview(_detailView!)
        }
        return _detailView!
    }
    
    ///是否显示右边箭头
    var showAccessoryArrow: Bool = false
    
    override func relayoutSubviews() {
        self.updateSubViews()
    }

    private func updateSubViews() {
        let frame: CGRect = self.layoutViewBounds
        var tmpFrame1: CGRect = frame
        var tmpFrame2: CGRect = CGRect.zero
        var tmpFrame3: CGRect = frame
        var tmpFrame4: CGRect = frame
        
        //计算imageView的坐标
        if _imageView != nil {
            tmpFrame1.width = tmpFrame1.height //默认宽高相等
            tmpFrame1.x += self.imageViewInsets.left
            tmpFrame1.y += self.imageViewInsets.top
            tmpFrame1.width -= self.imageViewInsets.left + self.imageViewInsets.right
            tmpFrame1.height -= self.imageViewInsets.top + self.imageViewInsets.bottom
            _imageView!.frame = tmpFrame1
            //计算tmpFrame4的x坐标
            tmpFrame4.x = _imageView!.maxX + self.centralInsets.left
        }
        
        //计算accessoryView的坐标
        if self.showAccessoryArrow { tmpFrame2 = CGRect(x: 0, y: 0, width: 7, height: 13) }
        tmpFrame2.x = frame.width - tmpFrame2.width
        tmpFrame2.y = frame.height / 2 - tmpFrame2.height / 2
        if self.showAccessoryArrow { self.accessoryView.frame = tmpFrame2 }
        
        //计算detailView的坐标
        if _detailView != nil {
            tmpFrame3.width = tmpFrame3.height //默认宽高相等
            tmpFrame3.x = tmpFrame2.minX - tmpFrame3.width
            if self.showAccessoryArrow { tmpFrame3.x -= KArrowSpace }

            tmpFrame3.x += self.detailViewInsets.left
            tmpFrame3.y += self.detailViewInsets.top
            tmpFrame3.width -= self.detailViewInsets.left + self.detailViewInsets.right
            tmpFrame3.height -= self.detailViewInsets.top + self.detailViewInsets.bottom
            _detailView!.frame = tmpFrame3
        }
        
        //计算label的宽度
        if _detailView != nil {
            tmpFrame4.width = _detailView!.minX - tmpFrame4.x - self.centralInsets.right
        }else if _accessoryView != nil {
            tmpFrame4.width = _accessoryView!.minX - tmpFrame4.x - KArrowSpace
        }else {
            tmpFrame4.width = frame.width - tmpFrame4.x
        }
        
        //计算label的高度
        if _detailLabel != nil && _accessoryLabel != nil {
            tmpFrame4.height = frame.height / 3
        }else if _detailLabel != nil || _accessoryLabel != nil {
            tmpFrame4.height = frame.height / 2
        }else {
            tmpFrame4.height = frame.height
        }
        
        //保存tmpFrame4的值
        let tmpFrame5: CGRect = tmpFrame4
        
        //计算label的坐标
        tmpFrame4.y += self.labelInsets.top
        tmpFrame4.height -= self.labelInsets.top + self.labelInsets.bottom
        self.label.frame = tmpFrame4
        
        //计算detailLabel的坐标
        if _detailLabel != nil {
            var tmpFrame6: CGRect = tmpFrame5
            tmpFrame6.y += tmpFrame5.height
            tmpFrame6.y += self.detailLabelInsets.top
            tmpFrame6.height -= self.detailLabelInsets.top + self.detailLabelInsets.bottom
            _detailLabel!.frame = tmpFrame6
        }
        
        //计算accessoryLabel的坐标
        if _accessoryLabel != nil {
            var tmpFrame7: CGRect = tmpFrame5
            tmpFrame7.y += tmpFrame5.height
            if _detailLabel != nil { tmpFrame7.y += tmpFrame7.height }
            
            tmpFrame7.y += self.accessoryLabelInsets.top
            tmpFrame7.height -= self.accessoryLabelInsets.top + self.accessoryLabelInsets.bottom
            _accessoryLabel!.frame = tmpFrame7
        }
    }
}
