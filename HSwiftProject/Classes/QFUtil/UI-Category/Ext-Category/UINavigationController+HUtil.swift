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
        if let vc = self.viewControllers.first(where: { $0.isKind(of: klass) }) {
            self.popToViewController(vc, animated: animated)
            return true
        }
        return false
    }
    
    func replaceTopViewController(_ vc: UIViewController, animated: Bool) {
        var vcs = self.viewControllers
        if !vcs.isEmpty {
            vcs.removeLast()
            vcs.append(vc)
            self.setViewControllers(vcs, animated: animated)
        }
    }

}
