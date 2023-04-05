//
//  HNavigationBar.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HNavigationBar: UIView {
    
//    lazy var naviBar: UIView = {
//        return UIView()
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = .flexibleWidth
//        self.addSubview(self.leftNaviButton)
        self.addSubview(self.titleLabel)
//        self.addSubview(self.rightNaviButton)
        self.addSubview(self.lineView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    /// 各个视图
//    private var _topBar: UIView?
//    private var _topBarLine: UIView?
//
//    var topBar: UIView {
//        if _topBar == nil { _topBar = UIView() }
//        //topBar = [[UIButton alloc] init]
//        //[topBar setAdjustsImageWhenHighlighted:NO]
//        //没有系统导航栏的时候,status背景色是透明的,用自定义导航栏去伪造一个status背景区域
//        if self.prefersNavigationBarHidden {
//            _topBar!.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
//        }else {
//            _topBar!.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//            _topBar!.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//        }
//        _topBar!.autoresizingMask = .flexibleWidth
//        if _topBarLine == nil {
//            _topBarLine = UIView()
//            _topBar!.addSubview(_topBarLine!)
//        }
//        _topBarLine!.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: _topBar!.width, height: 1)
//        _topBarLine!.isHidden = self.prefersTopBarLineHidden
//        return _topBar!
//    }
//
//    var topBarHeight: CGFloat {
//        return (self.prefersStatusBarHidden ? 0:UIScreen.statusBarHeight) + (self.prefersNavigationBarHidden ? 0:UIScreen.naviBarHeight)
//    }
    
    lazy var lineView: UIView = {
//        let label = UILabel()
//        label!.frame = CGRect(x: 54, y: 0, width: UIScreen.width - 54 * 2, height: UIScreen.naviBarHeight)
//        label!.textAlignment = .center
//        label!.textColor = UIColor.black
//        label!.font = UIFont.systemFont(ofSize: 18)
//        self.addSubview(label!)
//        return label!
        let line = UIView()
//        barLine.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: UIScreen.width, height: 1)
//        barLine.isHidden = self.prefersTopBarLineHidden
        return line
    }()
    
//    private var _titleLabel: UILabel?
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 70, y: 0, width: UIScreen.width - 70 * 2, height: UIScreen.naviBarHeight)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
//        self.addSubview(label)
        return label
    }()

//    private var _leftNaviButton: HWebButtonView?
    lazy var leftButton: HWebButtonView = {
        let button = HWebButtonView()
        button.frame = CGRect(x: 10, y: 0, width: 60, height: UIScreen.naviBarHeight)
        button.backgroundColor = nil
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
//        button.pressed = { [weak self] (_ sender: Any?, _ data: Any?) -> Void in
//            self!.leftButtonPressed()
//        }
        button.imageView?.contentMode = .scaleAspectFit
        self.addSubview(button)
        return button
    }()
    
//    private var _rightNaviButton: HWebButtonView?
    lazy var rightButton: HWebButtonView = {
        let button = HWebButtonView()
        button.frame = CGRect(x: UIScreen.width - 60 - 10, y: 0, width: 60, height: UIScreen.naviBarHeight)
        button.backgroundColor = nil
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .right
//        button.pressed = { [weak self] (_ sender: Any?, _ data: Any?) -> Void in
//            self!.rightButtonPressed()
//        }
        self.addSubview(button)
        return button
    }()
    
//    func leftButtonPressed() {
////        self.back()
//    }
//
//    func rightButtonPressed() {
//
//    }
    
    

    //重新设置topbar的frame
//    private func resetTopbarFrame() {
//        statusBarPadding = 0
//        if self.prefersStatusBarHidden == false && self.prefersNavigationBarHidden == false {
//            statusBarPadding = UIScreen.statusBarHeight
//        }
//        //reset topBar
//        if(self.prefersNavigationBarHidden) {
//            self.topBar.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
//        }else {
//            self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//            self.topBar.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//        }
//        //reset topBar line
//        _topBarLine!.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: topBar.width, height: 1)
//        //reset title label
//        if _rightNaviButton != nil {
//            //reset right button
//            _rightNaviButton!.frame = CGRect(x: topBar.width - _rightNaviButton!.width - 10, y: _rightNaviButton!.y, width: _rightNaviButton!.width, height: _rightNaviButton!.height)
//            var minX: CGFloat = 0.0
//            let width: CGFloat = max(_leftNaviButton!.width, _rightNaviButton!.width)
//            if _leftNaviButton!.width == width {
//                minX = _leftNaviButton!.minX
//            }else {
//                minX = self.view.width - _rightNaviButton!.maxX
//            }
//            self.titleLabel.frame = CGRect(x: minX + width, y: 0, width: self.view.width - 2 * (minX + width), height: UIScreen.naviBarHeight)
//        }else {
//            let width: CGFloat = _leftNaviButton!.width
//            self.titleLabel.frame = CGRect(x: _leftNaviButton!.minX + width, y: 0, width: self.view.width - 2 * (_leftNaviButton!.minX + width), height: UIScreen.naviBarHeight)
//        }
//    }

    /// 设置视图
//    override var title: String? {
//        get {
//            return super.title
//        }
//        set {
//            super.title = newValue
//            if self.isViewLoaded {
//                self.titleLabel.text = newValue
//            }
//        }
//    }

//    func setLeftNaviImage(_ image: UIImage?) {
//        self.leftNaviButton.setTitle("", for: .normal)
//        self.leftNaviButton.setTitle("", for: .highlighted)
//        self.leftNaviButton.setImage(image, for: .normal)
//        self.leftNaviButton.setImage(image, for: .highlighted)
//    }
//    func setLeftNaviImageURL(_ imageURL: String) {
//        self.leftNaviButton.setTitle("", for: .normal)
//        self.leftNaviButton.setTitle("", for: .highlighted)
//        self.leftNaviButton.setImage(nil, for: .normal)
//        self.leftNaviButton.setImage(nil, for: .highlighted)
//        self.leftNaviButton.setImageUrlString(imageURL)
//    }
//    func setNaviLeftImage(_ normal: UIImage, highlight: UIImage? = normal) {
//        self.leftButton.setTitle("", for: .normal)
//        self.leftButton.setTitle("", for: .highlighted)
//        self.leftButton.setImage(normal, for: .normal)
//        self.leftButton.setImage(highlight, for: .highlighted)
//    }
//    func setRightNaviImage(_ image: UIImage?) {
//        self.rightNaviButton.setTitle("", for: .normal)
//        self.rightNaviButton.setTitle("", for: .highlighted)
//        self.rightNaviButton.setImage(image, for: .normal)
//        self.rightNaviButton.setImage(image, for: .highlighted)
//    }
//    func setRightNaviImageURL(_ imageURL: String) {
//        self.rightNaviButton.setTitle("", for: .normal)
//        self.rightNaviButton.setTitle("", for: .highlighted)
//        self.rightNaviButton.setImage(nil, for: .normal)
//        self.rightNaviButton.setImage(nil, for: .highlighted)
//        self.rightNaviButton.setImageUrlString(imageURL)
//    }
//    func setNaviRightImage(_ normal: UIImage?, highlight: UIImage? = normal) {
//        self.rightButton.setTitle("", for: .normal)
//        self.rightButton.setTitle("", for: .highlighted)
//        self.rightButton.setImage(normal, for: .normal)
//        self.rightButton.setImage(highlight, for: .highlighted)
//    }
//    func setLeftNaviTitle(_ title: String) {
//        self.leftButton.setTitle(title, for: .normal)
//        self.leftButton.setTitle(title, for: .highlighted)
//        self.leftButton.setImage(nil, for: .normal)
//        self.leftButton.setImage(nil, for: .highlighted)
//    }
//    func setLeftNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
//        self.leftNaviButton.setTitle(title, for: .normal)
//        self.leftNaviButton.setTitle(title, for: .highlighted)
//        self.leftNaviButton.setTitleColor(titleColor, for: .normal)
//        self.leftNaviButton.setTitleColor(highlightcolor, for: .highlighted)
//        self.leftNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.leftNaviButton.frame = CGRect(x: HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
//        self.leftNaviButton.setImage(nil, for: .normal)
//        self.leftNaviButton.setImage(nil, for: .highlighted)
//    }
//    func setRightNaviTitle(_ title: String) {
//        self.rightNaviButton.setTitle(title, for: .normal)
//        self.rightNaviButton.setTitle(title, for: .highlighted)
//        self.rightNaviButton.setImage(nil, for: .normal)
//        self.rightNaviButton.setImage(nil, for: .highlighted)
//    }
//    func setRightNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
//        self.rightNaviButton.setTitle(title, for: .normal)
//        self.rightNaviButton.setTitle(title, for: .highlighted)
//        self.rightNaviButton.setTitleColor(titleColor, for: .normal)
//        self.rightNaviButton.setTitleColor(highlightcolor, for: .highlighted)
//        self.rightNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.rightNaviButton.frame = CGRect(x: self.topBar.width - HNavTitleButtonWidth - HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
//        self.rightNaviButton.setImage(nil, for: .normal)
//        self.rightNaviButton.setImage(nil, for: .highlighted)
//    }
    
}
