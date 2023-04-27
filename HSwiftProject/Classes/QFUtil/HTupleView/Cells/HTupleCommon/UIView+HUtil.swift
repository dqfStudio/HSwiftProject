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

extension UIView {
    
    /**
    *  根据nib name返回UIView
    */
    static func view(withNibName nibName: String) -> UIView {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! UIView
    }
    
    /**
    *  根据nib创建一个view，nib name为ClassName
    */
    static func viewFromNib() -> UIView {
        return Bundle.main.loadNibNamed(NSStringFromClass(self.classForCoder()), owner: nil, options: nil)?.first as! UIView
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
        self.x = CGFloat(ceilf(Float((width - self.width) / 2)))
    }

    /**
    *  根据传入的height来竖直居中
    */
    func verticalCenter(withHeight height: CGFloat) {
        self.y = CGFloat(ceilf(Float((height - self.height) / 2)))
    }
    
    func horizontalCenterInSuperView() {
        if self.superview != nil {
            self.horizontalCenter(withWidth: self.superview!.width)
        }
    }
    
    func verticalCenterInSuperView() {
        if self.superview != nil {
            self.verticalCenter(withHeight: self.superview!.height)
        }
    }
    
    // 根据UIEdgeInsets调整frame
    func insetByEdgeInsets(_ edgeInsets: UIEdgeInsets) {
        self.frame = self.frame.inset(by: edgeInsets)
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
        self.isUserInteractionEnabled = true
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(block: block)
        recognizer.numberOfTapsRequired = numberOfTapsRequired
        self.addGestureRecognizer(recognizer)
        return recognizer
    }
    
    /**
    *  添加单击事件，多次调用只会持有一个UITapGestureRecognizer对象，之前的会被清除
    */
    @discardableResult
    func addSingleTapGesture(withBlock block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        if (self.gestureRecognizers != nil) {
            for item in self.gestureRecognizers! {
                let gesture: UIGestureRecognizer = item
                if gesture.isKind(of: UITapGestureRecognizer.self) {
                    self.removeGestureRecognizer(gesture)
                }
            }
        }
        return self.addTapGesture(withNumberOfTapsRequired: 1, block: block)
    }
    
    @discardableResult
    func addSingleTapGesture(withTarget target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        if (self.gestureRecognizers != nil) {
            for item in self.gestureRecognizers! {
                let gesture: UIGestureRecognizer = item
                if gesture.isKind(of: UITapGestureRecognizer.self) {
                    self.removeGestureRecognizer(gesture)
                }
            }
        }
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(recognizer)
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
        let layer: CALayer = CALayer()
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
    *  设置UIView的顶部和底部边线，一般用在设置界面，当界面采用AutoLayout时使用
    */
    @discardableResult
    func setTopLineView(withColor color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> UIView {
        var frame: CGRect = self.frame
        frame.origin = CGPoint(x: 0, y: 0)
        frame.x += paddingLeft
        frame.width -= paddingLeft + paddingRight
        frame.y = frame.height - 1
        frame.height = 1
        return self.addSubview(withColor: color, frame: frame)
    }

    @discardableResult
    func setBottomLineView(withColor color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> UIView {
        var frame: CGRect = self.frame
        frame.origin = CGPoint(x: 0, y: 0)
        frame.x += paddingLeft
        frame.width -= paddingLeft + paddingRight
        frame.y = frame.height - 1
        frame.height = 1
        return self.addSubview(withColor: color, frame: frame)
    }

    @discardableResult
    func addSubview(withColor color: UIColor, frame: CGRect) -> UIView {
        let line: UIView = UIView()
        line.frame = frame
        line.backgroundColor = color
        self.addSubview(line)
        return line
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
    func setBoarderWith(_ width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
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


    ///设置视图上边角幅度
    func setCornerRadiiOnTop(_ radii: CGFloat) {
        self.setGivenCorner([.topLeft, .topRight], radii: radii)
    }

    ///设置视图下边角幅度
    func setCornerRadiiOnBottom(_ radii: CGFloat) {
        self.setGivenCorner([.bottomLeft, .bottomRight], radii: radii)
    }
    
    ///设置指定角的角幅度
    func setGivenCorner(_ corners: UIRectCorner, radii: CGFloat) {
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds,
                                                       byRoundingCorners: corners,
                                                       cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    ///设置视图所有角幅度
    func setAllCornerRadii(_ radii: CGFloat) {
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds,
                                                       cornerRadius: radii)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    ///去掉视图所有角幅度
    func setNoneCorner() {
        self.layer.mask = nil
    }

    /**
    *  生成快照图像
    */
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snap
    }

    func snapshotImage(withFrame frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, self.isOpaque, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
        self.layer.render(in: context)
        context.translateBy(x: frame.origin.x, y: frame.origin.y)
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return theImage
    }
    
}
