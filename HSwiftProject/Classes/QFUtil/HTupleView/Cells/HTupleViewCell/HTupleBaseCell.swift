//
//  HTupleBaseCell.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTupleCellBlock = (_ idxPath: IndexPath) -> Void
typealias HTupleDidSelectCell = (_ target: HTupleBaseCell, _ indexPath: IndexPath) -> Void

class HTupleBaseCell : UICollectionViewCell {
    
    ///cell所在的tuple view
    weak var tuple: UICollectionView?
    
    ///选中item的block
    var didSelectCell: HTupleDidSelectCell?
    
    ///cell所在的indexPath
    var indexPath: IndexPath?
    
    ///cell点击block，用户用户点击事件
    var cellBlock: HTupleCellBlock?
    ///信号block
    var signalBlock: HTupleCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    private var _edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    ///cell的边距
    @objc var edgeInsets: UIEdgeInsets {
        get {
            return _edgeInsets
        }
        set {
            _edgeInsets = newValue
            //更新layoutView的frame
            let frame: CGRect = self.layoutViewFrame
            if self.layoutView.frame != frame {
                self.layoutView.frame = frame
            }
        }
    }
    
    private var _layoutView: UIView?
    ///用于加载在contentView上的布局视图
    var layoutView: UIView {
        if _layoutView == nil {
            _layoutView = UIView()
            self.addSubview(_layoutView!)
        }
        return _layoutView!
    }

    private var _separatorView: UIView?
    ///用于加载在contentView上的布局视图
    private var separatorView: UIView {
        if _separatorView == nil {
            _separatorView = UIView()
            _separatorView!.isHidden = true
            let color = UIColor(red: 233 / 255.0, green: 233 / 255.0, blue: 233 / 255.0, alpha: 1.0)
            _separatorView!.backgroundColor = color
        }
        return _separatorView!
    }
    
    private var _isShouldShowSeparator: Bool = false
    ///cell是否显示间隔线
    var isShouldShowSeparator: Bool {
        get {
            return _isShouldShowSeparator
        }
        set {
            if _isShouldShowSeparator != newValue {
               _isShouldShowSeparator = newValue
                if _isShouldShowSeparator {
                    if self.separatorView.superview == nil {
                        self.addSubview(self.separatorView)
                    }
                    self.bringSubviewToFront(self.separatorView)
                }
                self.separatorView.isHidden = !_isShouldShowSeparator
            }
            //重设frame
            if _isShouldShowSeparator {
                let frame: CGRect = self.getSeparatorFrame
                if self.separatorView.frame != frame {
                   self.separatorView.frame = frame
                }
            }
        }
    }

    private var _separatorInset: UILREdgeInsets = UILREdgeInsetsZero
    ///cell间隔线的边距
    var separatorInset: UILREdgeInsets {
        get {
            return _separatorInset
        }
        set {
            if _separatorInset != newValue {
                _separatorInset = newValue
                self.separatorView.frame = self.getSeparatorFrame
            }
        }
    }
    
    private var _separatorColor: UIColor?
    ///cell间隔线的颜色
    var separatorColor: UIColor? {
        get {
            return _separatorColor
        }
        set {
            if _separatorColor != newValue {
                _separatorColor = nil
                _separatorColor = newValue
                self.separatorView.backgroundColor = _separatorColor
            }
        }
    }
    
    private var getSeparatorFrame: CGRect {
        var frame: CGRect = CGRect(x: 0, y: self.height - 1, width: self.width, height: 1)
        frame.x += self.separatorInset.left
        frame.width -= self.separatorInset.left + self.separatorInset.right
        return frame
    }
    
    ///刷新当前cell
    func reloadData() {
        if self.indexPath != nil {
            self.tuple?.reloadItems(at: [self.indexPath!])
        }
    }

    ///layoutView的frame和bounds
    var layoutViewFrame: CGRect {
        var frame: CGRect = self.bounds
        frame.x += _edgeInsets.left
        frame.y += _edgeInsets.top
        frame.width -= _edgeInsets.left + _edgeInsets.right
        frame.height -= _edgeInsets.top + _edgeInsets.bottom
        return frame
    }

    var layoutViewBounds: CGRect {
        var frame: CGRect = self.layoutViewFrame
        frame.x = 0
        frame.y = 0
        return frame
    }
    
    func HLayoutTupleCell(_ v: UIView) {
        let frame: CGRect = self.layoutViewBounds
        if v.frame != frame {
            v.frame = frame
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///cell初始化是调用的方法
    func initUI() { }
    ///用于子类更新子视图布局
    @objc
    func relayoutSubviews() { }
    
}
