//
//  UIScreen+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static var safeArea: CGRect {
        var bounds = UIScreen.main.bounds
        bounds.origin.y = UIScreen.topBarHeight
        bounds.size.height -= bounds.origin.y + UIScreen.bottomBarHeight
        return bounds
    }
    
    static var bound: CGRect {
        return UIScreen.main.bounds
    }
        
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
        
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
        
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
        
    static var onePixel: CGFloat = {
        if UIScreen.main.responds(to: #selector(getter: nativeScale)) {
            return 1.0 / UIScreen.main.nativeScale
        }else {
            return 1.0 / UIScreen.main.scale
        }
    }()
    
    static var isIPhoneX: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
        if let bottom = UIApplication.getKeyWindow?.safeAreaInsets.bottom, bottom > 0 {
            return true
        }
        let bounds = UIScreen.main.bounds.size
        let native = UIScreen.main.nativeBounds.size
        return max(bounds.width, bounds.height) >= 812
            || max(native.width, native.height) >= 2436
    }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.getKeyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height
                ?? UIApplication.getKeyWindow?.safeAreaInsets.top
                ?? 0
        }
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static var naviBarHeight: CGFloat {
        return 44.0
    }
    
    static var topBarHeight: CGFloat {
        return UIScreen.statusBarHeight + UIScreen.naviBarHeight
    }
    
    static var bottomBarHeight: CGFloat {
        if let bottom = UIApplication.getKeyWindow?.safeAreaInsets.bottom {
            return bottom
        }
        return UIScreen.isIPhoneX ? 34.0 : 0.0
    }

}
