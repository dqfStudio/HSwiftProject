//
//  CALayer+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
    @discardableResult
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) -> CALayer {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 || bounds.isEmpty {
            shadowPath = nil
        }else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        masksToBounds = false
        return self
    }
    @discardableResult
    func applyCornerRadius(_ radius: CGFloat) -> CALayer {
        cornerRadius = radius
        masksToBounds = true
        return self
    }
    @discardableResult
    func applyGivenCorner(_ corners: CACornerMask, radius: CGFloat) -> CALayer {
        cornerRadius = radius
        maskedCorners = corners
        masksToBounds = true
        return self
    }
    @discardableResult
    func applyBorder(width: CGFloat, color: UIColor) -> CALayer {
        borderWidth = width
        borderColor = color.cgColor
        return self
    }
}
