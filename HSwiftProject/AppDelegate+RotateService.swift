//
//  AppDelegate+RotateService.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/24.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var KOrientationStyleKey = "KOrientationStyleKey"

enum UIDeviceOrientationStyle: Int {
    case all // 横竖屏
    case vertical //竖屏
    case horizontal //横屏
    case horizontalLeft //横屏左旋转
    case horizontalRight //横屏右旋转
}

extension AppDelegate {
    static var orientationStyle: UIDeviceOrientationStyle {
        get { return objc_getAssociatedObject(self, &KOrientationStyleKey) as! UIDeviceOrientationStyle }
        set { objc_setAssociatedObject(self, &KOrientationStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @available(iOS 12.0, *)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if AppDelegate.orientationStyle == .vertical {
//            return .portrait
//        } else if AppDelegate.orientationStyle == .horizontal {
//            return [.landscapeLeft, .landscapeRight]
//        } else if AppDelegate.orientationStyle == .horizontalLeft {
//            return .landscapeLeft
//        } else if AppDelegate.orientationStyle == .horizontalRight {
//            return .landscapeRight
//        } else {
//            return [.portrait, .landscapeLeft, .landscapeRight]
//        }
        return .portrait
    }
}
