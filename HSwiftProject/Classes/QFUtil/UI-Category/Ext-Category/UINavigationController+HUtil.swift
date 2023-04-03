//
//  UINavigationController+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UINavigationController {

    func popToViewControllerOfClass(_ klass: AnyClass, animated: Bool) -> Bool {
        var success = false
        for vc in self.viewControllers {
            if vc.isKind(of: klass) {
                success = true
                self.popToViewController(vc, animated: animated)
                break
            }
        }
        return success
    }
    
    func replaceTopViewController(_ vc: UIViewController, animated: Bool) {
        let vcs = NSMutableArray(array: self.viewControllers)
        if vcs.count > 0 {
            vcs.removeLastObject()
            vcs.add(vc)
        }
        self.setViewControllers(vcs as! [UIViewController], animated: animated)
    }

}
