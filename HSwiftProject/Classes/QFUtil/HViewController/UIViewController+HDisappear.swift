//
//  UIViewController+HDisappear.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

@objc
enum HVCAppearType : Int {
    case undefine = 0
    case present  = 1
    case push     = 2
}

@objc
enum HVCDisappearType : Int {
    case undefine = 0
    case push     = 1
    case pop      = 2
    case dismiss  = 3
}

private var kHVCAppearTypeKey = "kHVCAppearTypeKey"

extension UIViewController {

    // VC presentation style
    var appearType: HVCAppearType {
        get {
            let value = self.getAssociatedValueForKey(&kHVCAppearTypeKey) as? NSNumber ?? NSNumber(value: 0)
            return HVCAppearType(rawValue: value.intValue)!
        }
        set {
            self.setAssociateValue(NSNumber(value: newValue.rawValue), key: &kHVCAppearTypeKey)
        }
    }

    @objc
    func vcWillDisappear(_ type: HVCDisappearType) { }

}


extension HViewController {
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.appearType = .present
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let viewControllers = self.navigationController?.viewControllers else {
            self.vcWillDisappear(.dismiss)
            return
        }
        for item in viewControllers {
            let vc = item as UIViewController
            vc.vcWillDisappear(.dismiss)
        }
    }
    
}

extension HNavigationController {
    
    @discardableResult
    open override func popViewController(animated: Bool) -> UIViewController? {
        guard let popVC = super.popViewController(animated: animated) else {
            return nil
        }
        if popVC.isKind(of: UIViewController.self) {
            popVC.vcWillDisappear(.pop)
        }
        return popVC
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let topVC = self.topViewController, topVC.isKind(of: UIViewController.self) {
            topVC.vcWillDisappear(.push)
        }
        if !viewControllers.isEmpty {
            viewController.appearType = .push
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}
