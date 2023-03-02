//
//  UIImageView+HFilletLayer.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift

public enum UIImageViewFilletStyle: Int {
    case center = 0
    case leftOrTop = 1
    case rightOrBottom = 2
}

private var KUIImageViewFilletKey = "KUIImageViewFilletKey"
private var KUIImageViewFilletStyleKey = "KUIImageViewFilletStyleKey"

extension UIImageView {
    
    var fillet: Bool {//是否圆角展示图片
        get {
            return objc_getAssociatedObject(self, &KUIImageViewFilletKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &KUIImageViewFilletKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if fillet {
                self.addFilletLayer()
            }
        }
    }
    
    var filletStyle: UIImageViewFilletStyle {//默认居中显示
        get {
            return objc_getAssociatedObject(self, &KUIImageViewFilletStyleKey) as? UIImageViewFilletStyle ?? .center
        }
        set(newValue) {
            if (self.filletStyle != newValue) {
                if (self.fillet && self.image != nil) {
                    self.addFilletLayer()
                }
            }
            objc_setAssociatedObject(self, &KUIImageViewFilletStyleKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
    }
    
//    @objc override class func swizzle() {
//            Swizzle(UIImageView.self) {
//                #selector(setter: image) <-> #selector(pvc_image)
//            }
//        }
//
//    @objc private func pvc_image(_ image: UIImage?) {
//        self.pvc_image(image)
//        if self.fillet && image != nil {
//            self.addFilletLayer()
//        }
//    }
    
    public var h_image: UIImage? {
        get {
            return self.image
        }
        set {
            self.image = newValue
            if self.fillet && newValue != nil {
                self.addFilletLayer()
            }
        }
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if super.frame != newValue {
                super.frame = newValue
                if self.fillet && image != nil {
                    self.addFilletLayer()
                }
            }
        }
    }
    
    public func addFilletLayer() {
        if self.image != nil {
            let width: CGFloat = self.frame.width
            let height: CGFloat = self.frame.height
            
            if width == height {
                self.layer.cornerRadius = width / 2
                self.layer.masksToBounds = true
            }else {
                var value: CGFloat = width
                if height < width {
                    value = height
                }
                
                let originX: CGFloat = width / 2 - value / 2
                let originY: CGFloat = height / 2 - value / 2
                if originX > 0 {
                    
                    switch self.filletStyle {
                    case .center:
                        self.layer.frame = CGRect(x: width / 2 - value / 2, y: height / 2 - value / 2, width: value, height: value)
                    case .leftOrTop:
                        self.layer.frame = CGRect(x: 0, y: height / 2 - value / 2, width: value, height: value)
                    case .rightOrBottom:
                        self.layer.frame = CGRect(x: width - value, y: height / 2 - value / 2, width: value, height: value)
                    }
                    
                }else if (originY > 0) {
                    
                    switch (self.filletStyle) {
                    case .center:
                        self.layer.frame = CGRect(x: width / 2 - value / 2, y: height / 2 - value / 2, width: value, height: value)
                    case .leftOrTop:
                        self.layer.frame = CGRect(x: width / 2 - value / 2, y: 0, width: value, height: value)
                    case .rightOrBottom:
                        self.layer.frame = CGRect(x: width / 2 - value / 2, y: height - value, width: value, height: value)
                    }
                }
                self.layer.cornerRadius = value / 2
                self.layer.masksToBounds = true
            }
        }
    }
}
