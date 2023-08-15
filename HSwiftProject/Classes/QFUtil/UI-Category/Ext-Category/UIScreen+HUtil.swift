//
//  UIScreen+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIScreen {
    
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
    
    static var isIPhoneX: Bool = {
        var iPhoneXSeries: Bool = false
        if UIDevice.current.userInterfaceIdiom == .phone {
            if #available(iOS 11.0, *) {
                if !iPhoneXSeries, UIScreen.statusBarHeight >= 44 {
                    iPhoneXSeries = true
                }
            }
        }
        return iPhoneXSeries
    }()
    
    static var statusBarHeight: CGFloat {
        var height: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0.0
        } else {
            height = UIApplication.shared.statusBarFrame.size.height
        }
        return height
    }
    
    static var naviBarHeight: CGFloat {
        return 44.0
    }
    
    static var topBarHeight: CGFloat {
        return UIScreen.statusBarHeight + UIScreen.naviBarHeight
    }
    
    static var bottomBarHeight: CGFloat {
        return UIScreen.isIPhoneX ? 34.0 : 0.0
    }

}
