//
//  HTupleBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTupleApexBlock = (_ idxPath: IndexPath) -> Void

class HTupleBaseApex : UICollectionReusableView {
    
    ///cell所在的tuple view
    weak var tuple: UICollectionView?
    ///cell是否为section header
    var isHeader: Bool = false
    ///cell所在的indexPath
    var indexPath: IndexPath?
    
    ///cell点击block，用户用户点击事件
    var cellBlock: HTupleApexBlock?
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
    
    private var _shouldShowSeparator: Bool = false
    ///cell是否显示间隔线
    var shouldShowSeparator: Bool {
        get {
            return _shouldShowSeparator
        }
        set {
            if _shouldShowSeparator != newValue {
               _shouldShowSeparator = newValue
                if _shouldShowSeparator {
                    if self.separatorView.superview == nil {
                        self.addSubview(self.separatorView)
                    }
                    self.bringSubviewToFront(self.separatorView)
                }
                self.separatorView.isHidden = !_shouldShowSeparator
            }
            //重设frame
            if _shouldShowSeparator {
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

    ///layoutView的frame和bounds
    var layoutViewFrame: CGRect {
        return self.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        var frame = self.layoutViewFrame
        frame.origin = CGPoint.zero
        return frame
    }
    
    private var _activity: UIActivityIndicatorView?
    var activity: UIActivityIndicatorView {
        if _activity == nil {
            if #available(iOS 13.0, *) {
                _activity = UIActivityIndicatorView(style: .medium)
            } else {
                // Fallback on earlier versions
            }
            _activity!.x = (self.width - _activity!.width) / 2
            _activity!.y = (self.height - _activity!.height) / 2
            self.addSubview(_activity!)
        }
        return _activity!
    }

    func HLayoutTupleApex(_ v: UIView) {
        let frame: CGRect = self.layoutViewBounds
        if v.frame != frame {
            v.frame = frame
        }
        _activity?.x = (self.width - (_activity?.width ?? 0)) / 2
        _activity?.y = (self.height - (_activity?.height ?? 0)) / 2
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
