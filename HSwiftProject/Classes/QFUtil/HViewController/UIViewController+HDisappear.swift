//
//  UIViewController+HDisappear.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// Define the HVCAppearType enumeration to represent the appearance of a view controller
@objc
enum HVCAppearType : Int {
    case undefine = 0
    case present  = 1
    case push     = 2
}

// Define the HVCDisappearType enumeration to represent the disappearance of a view controller
@objc
enum HVCDisappearType : Int {
    case undefine = 0
    case push     = 1
    case pop      = 2
    case dismiss  = 3
}

// Define the private variable kHVCAppearTypeKey
private var kHVCAppearTypeKey = "kHVCAppearTypeKey"

extension UIViewController {

    // Get the appearance of the view controller
    var appearType: HVCAppearType {
        get {
            let value = self.getAssociatedValueForKey(&kHVCAppearTypeKey) as? NSNumber ?? NSNumber(value: 0)
            return HVCAppearType(rawValue: value.intValue) ?? .undefine
        }
        set {
            // Set the appearance of the view controller
            self.setAssociateValue(NSNumber(value: newValue.rawValue), key: &kHVCAppearTypeKey)
        }
    }

    // The view controller is about to disappear
    @objc
    func vcWillDisappear(_ type: HVCDisappearType) { }

}


extension HViewController {
    
    // Override the present method
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        // Set the appearance of the view controller to present
        viewControllerToPresent.appearType = .present
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    // Override the dismiss method
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        // Get all the view controllers in the navigation controller
        guard let viewControllers = self.navigationController?.viewControllers else {
            // If there is no navigation controller, the disappearance of the view controller is dismiss
            self.vcWillDisappear(.dismiss)
            return
        }
        // Traverse all the view controllers in the navigation controller and set the disappearance of the view controller to dismiss
        for item in viewControllers {
            let vc = item as UIViewController
            vc.vcWillDisappear(.dismiss)
        }
    }
    
}

extension HNavigationController {
    
    // Override the popViewController method
    @discardableResult
    open override func popViewController(animated: Bool) -> UIViewController? {
        guard let popVC = super.popViewController(animated: animated) else {
            return nil
        }
        if popVC.isKind(of: UIViewController.self) {
            // If the view controller is a subclass of UIViewController, set the disappearance of the view controller to pop
            popVC.vcWillDisappear(.pop)
        }
        return popVC
    }
    
    // Override the pushViewController method
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let topVC = self.topViewController, topVC.isKind(of: UIViewController.self) {
            // If the top view controller of the navigation controller is a subclass of UIViewController, set the disappearance of the view controller to push
            topVC.vcWillDisappear(.push)
        }
        if !viewControllers.isEmpty {
            // If the stack of the navigation controller is not empty, set the appearance of the view controller to push
            viewController.appearType = .push
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}
