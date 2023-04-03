//
//  AppDelegate+WindowService.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    static var appDel: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    //初始化window
    func setupWindow() {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        let navController = HNavigationController(rootViewController: HMenuController())
//        window.rootViewController = navController
//        window.makeKeyAndVisible()
    }
    
    //获取当前顶部视图
    static var currentViewController: UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for tmpWindow in windows {
                if tmpWindow.windowLevel == UIWindow.Level.normal {
                    window = tmpWindow
                    break
                }
            }
        }
        var result = window?.rootViewController
        while result?.presentedViewController != nil {
            result = result?.presentedViewController
        }
        if let tabBarController = result as? UITabBarController {
            result = tabBarController.selectedViewController
        } else if let navigationController = result as? UINavigationController {
            result = navigationController.topViewController
        }
        return result
    }
    
    //获取(检查）指定视图
    static func checkViewController(_ className: AnyClass?) -> UIViewController? {
        guard let className = className else { return nil }
        for vc in UIApplication.navi!.viewControllers {
            if vc.isKind(of: className) {
                return vc
            }
        }
        return nil
    }
    
}
