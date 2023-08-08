//
//  UIView+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var TIPS_IMAGE_VIEW_TAG = 10000
private var TIPS_LABEL_TAG = 10001

private var topLineLayerKey = "topLineLayerKey"
private var bottomLineLayerKey = "bottomLineLayerKey"
var kViewEdgeInsetsKey = "kViewEdgeInsetsKey"

extension UIView {
    
    /**
    *  根据nib name返回UIView
    */
    static func view(withNibName nibName: String) -> UIView? {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
    }
    
    /**
    *  根据nib创建一个view，nib name为ClassName
    */
    static func viewFromNib() -> UIView? {
        return Bundle.main.loadNibNamed(NSStringFromClass(self.classForCoder()), owner: nil, options: nil)?.first as? UIView
    }
    
 
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    public var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    public var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    
    public var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.center.y) }
    }
    
    var centerY: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: self.center.y, y: newValue) }
    }
    
    var minX: CGFloat {
        return self.frame.minX
    }

    var minY: CGFloat {
        return self.frame.minY
    }

    var midX: CGFloat {
        return self.frame.midX
    }
    
    var midY: CGFloat {
        return self.frame.midY
    }

    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }

    /**
    *  根据传入的width来水平居中
    */
    func horizontalCenter(withWidth width: CGFloat) {
        self.x = (width - self.width) / 2
    }

    /**
    *  根据传入的height来竖直居中
    */
    func verticalCenter(withHeight height: CGFloat) {
        self.y = (height - self.height) / 2
    }
    
    func horizontalCenterInSuperView() {
        guard let superview = self.superview else { return }
        self.horizontalCenter(withWidth: superview.width)
    }
    
    func verticalCenterInSuperView() {
        guard let superview = self.superview else { return }
        self.verticalCenter(withHeight: superview.height)
    }
    
    func centerInSuperView() {
        guard let superview = self.superview else { return }
        self.horizontalCenter(withWidth: superview.width)
        self.verticalCenter(withHeight: superview.height)
    }
    
    // 根据UIEdgeInsets调整frame
    @objc var edgeInsets: UIEdgeInsets {
        get {
            let edgeInsetsString = self.getAssociatedValueForKey(&kViewEdgeInsetsKey) as? String ?? NSCoder.string(for: UIEdgeInsets.zero)
            return NSCoder.uiEdgeInsets(for: edgeInsetsString)
        }
        set {
            if edgeInsets != newValue {
                self.frame = self.frame.inset(by: newValue)
                self.setAssociateValue(NSCoder.string(for: newValue), key: &kViewEdgeInsetsKey)
            }
        }
    }
    
    /**
    *  添加双击事件
    */
    @discardableResult
    func addDoubleTapGesture(withBlock block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        self.addTapGesture(withNumberOfTapsRequired: 2, block: block)
    }

    @discardableResult
    private func addTapGesture(withNumberOfTapsRequired numberOfTapsRequired: Int, block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer(block: block)
        recognizer.numberOfTapsRequired = numberOfTapsRequired
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        return recognizer
    }
    
    /**
    *  添加单击事件，多次调用只会持有一个UITapGestureRecognizer对象，之前的会被清除
    */
    @discardableResult
    func addSingleTapGesture(withBlock block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        if let gestureRecognizers = self.gestureRecognizers {
            for gesture in gestureRecognizers where gesture is UITapGestureRecognizer {
                self.removeGestureRecognizer(gesture)
            }
        }
        return addTapGesture(withNumberOfTapsRequired: 1, block: block)
    }
    
    @discardableResult
    func addSingleTapGesture(withTarget target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        isUserInteractionEnabled = true
        if let gestureRecognizers = gestureRecognizers {
            for gesture in gestureRecognizers where gesture is UITapGestureRecognizer {
                removeGestureRecognizer(gesture)
            }
        }
        let recognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(recognizer)
        return recognizer
    }


    /**
    *  设置UIView的顶部和底部边线，一般用在设置界面
    */
    var topLineLayer: CALayer? {
        get { objc_getAssociatedObject(self, &topLineLayerKey) as? CALayer }
        set { objc_setAssociatedObject(self, &topLineLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var bottomLineLayer: CALayer? {
        get { objc_getAssociatedObject(self, &bottomLineLayerKey) as? CALayer }
        set { objc_setAssociatedObject(self, &bottomLineLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     *  添加一个SubLayer
     */
    @discardableResult
    func addSubLayer(withFrame frame: CGRect, color: UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        self.layer.addSublayer(layer)
        return layer
    }
    
    
    func setTopLine(withColor color: UIColor) {
        self.setTopLine(withColor: color, paddingLeft: 0, paddingRight: 0)
    }
    
    func setTopLine(withColor color: UIColor, width: CGFloat) {
        self.setTopLine(withColor: color, width: width, paddingLeft: 0, paddingRight: 0)
    }
    
    func setTopLine(withColor color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) {
        self.setTopLine(withColor: color, width: self.width, paddingLeft: paddingLeft, paddingRight: paddingRight)
    }

    func setTopLine(withColor color: UIColor, width: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat) {
        let frame: CGRect = CGRect(x: paddingLeft, y: 0, width: width - paddingLeft - paddingRight, height: 1)
        if self.topLineLayer == nil {
            self.topLineLayer = self.addSubLayer(withFrame: frame, color: color)
        }else {
            self.topLineLayer?.frame = frame
            self.topLineLayer?.backgroundColor = color.cgColor
        }
    }

    
    
    func setBottomLine(withColor color: UIColor) {
        self.setBottomLine(withColor: color, paddingLeft: 0, paddingRight: 0)
    }
    
    func setBottomLine(withColor color: UIColor, size: CGSize) {
        self.setBottomLine(withColor: color, size: size, paddingLeft: 0, paddingRight: 0)
    }
    
    func setBottomLine(withColor color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) {
        self.setBottomLine(withColor: color, size: self.size, paddingLeft: paddingLeft, paddingRight: paddingRight)
    }
    
    func setBottomLine(withColor color: UIColor, size: CGSize, paddingLeft: CGFloat, paddingRight: CGFloat) {
        let frame: CGRect = CGRect(x: paddingLeft, y: size.height - 1, width: size.width - paddingLeft - paddingRight, height: 1)
        if self.bottomLineLayer == nil {
            self.bottomLineLayer = self.addSubLayer(withFrame: frame, color: color)
        }else {
            self.bottomLineLayer?.frame = frame
            self.bottomLineLayer?.backgroundColor = color.cgColor
        }
    }

    func setTopAndBottomLine(withColor color: UIColor) {
        self.setTopLine(withColor: color)
        self.setBottomLine(withColor: color)
    }


    /**
    *  返回它所在的ViewController
    */
    var viewController: UIViewController? {
        var next = self.next
        var controller: UIViewController?
        while next?.isKind(of: UIViewController.self) == false {
            next = next?.next
            if next == nil {
                break
            }
        }
        if next?.isKind(of: UIViewController.self) == true {
            controller = next as? UIViewController
        }
        return controller
    }

    /**
    *  设置边框宽度和颜色
    */
    var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    var borderColor: UIColor? {
        get {
            if let borderColor = self.layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
            self.layer.masksToBounds = true
        }
    }

    /**
    *  设置圆角
    */
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    ///设置视图上边角幅度
    func setCornerRadiiOnTop(_ radius: CGFloat) {
        self.setGivenCorner([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
    }

    ///设置视图下边角幅度
    func setCornerRadiiOnBottom(_ radius: CGFloat) {
        self.setGivenCorner([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: radius)
    }
    
    ///设置指定角的角幅度
    func setGivenCorner(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        self.layer.masksToBounds = true
    }
    

    /**
    *  主要用于UITableView，UIScrollView，UICollectionView等列表类的View，
    *  在数据为空时，显示一个提示性的图像和文字
    */
    func setTipsView(withImageName imageName: String, text: String, textColor: UIColor) {
        var imageView: UIImageView? = self.viewWithTag(TIPS_IMAGE_VIEW_TAG) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(image: UIImage(named: imageName))
        }
        imageView?.center = CGPoint(x: self.width / 2, y: self.height / 2 - 40)
        imageView?.contentMode = .center
        imageView?.tag = TIPS_IMAGE_VIEW_TAG
        self.addSubview(imageView!)
        
        var label: UILabel? = self.viewWithTag(TIPS_IMAGE_VIEW_TAG) as? UILabel
        if label == nil {
            label = UILabel(frame: CGRect(x: 0, y: imageView!.maxY + 10, width: UIScreen.width, height: 20))
        }
        label?.font = UIFont.systemFont(ofSize: 16)
        label?.textColor = textColor
        label?.text = text
        label?.textAlignment = .center
        label?.tag = TIPS_LABEL_TAG
        self.addSubview(label!)
    }

    func removeTipsView() {
        self.viewWithTag(TIPS_IMAGE_VIEW_TAG)?.removeFromSuperview()
        self.viewWithTag(TIPS_LABEL_TAG)?.removeFromSuperview()
    }

    /**
    *  生成快照图像
    */
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            if let snap = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return snap
            }
        }
        return nil
    }

    func snapshotImage(withFrame frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, self.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            self.layer.render(in: context)
            context.translateBy(x: frame.origin.x, y: frame.origin.y)
            if let theImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return theImage
            }
        }
        return nil
    }
    
}
