//
//  HNaviToastView.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HNaviToastView: UIView {
    
    private var removeFromSuperViewOnHide: Bool = false
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16.0)
        titleLabel.textColor = UIColor(hex: 0x5e5e5e)
        return titleLabel
    }()
    
    lazy private var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    var iconImage: UIImage? {
        get {
            return self.iconImageView.image
        }
        set {
            self.iconImageView.image = newValue
            self.iconImageView.isHidden = (newValue == nil)
            self.refreshUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        self.addGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.iconImageView)
        self.refreshUI()
    }
    
    private func refreshUI() {
        if !self.iconImageView.isHidden {
            self.iconImageView.frame = CGRect(x: self.x + 10,
                                              y: self.height - 16 - 14,
                                              width: 16,
                                              height: 16)
            self.titleLabel.frame = CGRect(x: self.iconImageView.maxX + 6,
                                           y: self.iconImageView.centerY - 20 / 2,
                                           width: self.width - (self.iconImageView.maxX + 6),
                                           height: 20)
        }else {
            self.titleLabel.frame = CGRect(x: 10,
                                           y: (self.height - 16 - 14) - 20 / 2,
                                           width: self.width - 20,
                                           height: 20)
        }
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipped))
        swipeGesture.direction = .up
        self.addGestureRecognizer(swipeGesture)
    }
    
    @objc
    private func tapped() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.hide(true)
    }
    
    @objc
    private func swipped() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.hide(true)
    }
    
    //显示
    func show(_ animated: Bool) {
        var frame = self.frame
        frame.origin.y += frame.size.height
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.frame = frame
            }
        }else {
            self.frame = frame
        }
    }
    
    //隐藏
    func hide(_ animated: Bool) {
        var frame = self.frame
        frame.origin.y -= frame.size.height
        if animated {
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = frame
            }) { (isFinish) in
                self.isUserInteractionEnabled = true
                if self.removeFromSuperViewOnHide {
                    self.removeFromSuperview()
                }
            }
        }else {
            self.frame = frame
        }
    }
    
    @objc
    private func hideDelayed(_ animated: NSNumber) {
        self.hide(animated.boolValue)
    }
    
    //隐藏
    func hide(_ animated: Bool, afterDelay interval: TimeInterval) {
        self.perform(#selector(hideDelayed(_:)), with: NSNumber(value: animated), afterDelay: interval)
    }
    
    //返回当前view上的所有MGToastView子视图
    static func allToastForView(_ view: UIView) -> [HNaviToastView] {
        let toastViews = NSMutableArray()
        let subViews = view.subviews
        subViews.forEach { aView in
            if aView.isKind(of: HNaviToastView.self) {
                toastViews.add(aView)
            }
        }
        return toastViews as! [HNaviToastView]
    }
    
    //隐藏view视图上所有的MGToastView子视图
    static func hideAllToastForView(_ view: UIView, animated: Bool) {
        let toastViews = self.allToastForView(view) as [HNaviToastView]
        for toastView in toastViews {
            toastView.removeFromSuperViewOnHide = true
            toastView.hide(animated)
        }
    }
    
    //快速获取通用toast
    static func customToastAddedTo(_ view: UIView, animated: Bool) -> HNaviToastView {
        let toastView = self.showToastAddedTo(view, animated: animated)
        toastView.titleLabel.textColor = UIColor(hex: 0x5e5e5e)
        toastView.backgroundColor = .white
        toastView.iconImageView.image = UIImage(named: "mgf_icon_toast_success")
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowOffset = CGSize(width: 0, height: 2)
        toastView.layer.shadowRadius = 4.0
        toastView.layer.shadowOpacity = 0.1
        return toastView
    }
    private static func showToastAddedTo(_ view: UIView, animated: Bool) -> HNaviToastView {
        let width = view.bounds.size.width
        let toastView = HNaviToastView(frame: CGRect(x: 0, y: -UIScreen.topBarHeight, width: width, height: UIScreen.topBarHeight))
        toastView.removeFromSuperViewOnHide = true
        view.addSubview(toastView)
        toastView.show(animated)
        return toastView
    }
    static func showCustomToast(_ string: String, afterDelay delay: TimeInterval, icon: UIImage) -> HNaviToastView? {
        if let window = UIApplication.shared.keyWindow {
            HNaviToastView.hideAllToastForView(window, animated: false)
            let toastView = HNaviToastView.customToastAddedTo(window, animated: true)
            toastView.titleLabel.text = string
            toastView.iconImage = icon
            toastView.hide(true, afterDelay: delay)
            return toastView
        }
        return nil
    }
    
    //快速获取错误toast
    static func errorToastAddedTo(_ view: UIView, animated: Bool) -> HNaviToastView {
        let toastView = self.showToastAddedTo(view, animated: animated)
        toastView.titleLabel.textColor = UIColor(hex: 0xfb2f2f)
        toastView.backgroundColor = UIColor(hex: 0xfeecec)
        toastView.iconImageView.image = UIImage(named: "mgf_icon_toast_error")
        return toastView
    }
    
    static func showErrorToast(_ string: String, afterDelay delay: TimeInterval, icon: UIImage) -> HNaviToastView? {
        if let window = UIApplication.shared.keyWindow {
            HNaviToastView.hideAllToastForView(window, animated: false)
            let toastView = HNaviToastView.errorToastAddedTo(window, animated: true)
            toastView.titleLabel.text = string
            toastView.iconImage = icon
            toastView.hide(true, afterDelay: delay)
            return toastView
        }
        return nil
    }
    
}
