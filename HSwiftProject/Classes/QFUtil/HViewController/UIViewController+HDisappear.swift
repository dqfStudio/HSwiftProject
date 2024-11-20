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
private var kHVCAppearTypeKey: Void?
//private var kNaviLeftItemKey:  Void?
//private var kNaviRightItemKey: Void?

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
    
//    @objc
//    func addNaviLeftItem(_ color: UIColor = UIColor.white) {
//        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hvc_back_icon"), style: .plain, target: self, action: #selector(naviBack))
//        leftBarButtonItem.tintColor = color
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
//    }
    
    /// Return event processing
    @objc
    func naviBack(_ completion: (() -> Void)? = nil) {
        if let navi = self.navigationController {
            if navi.isKind(of: HNavigationController.self), self.isKind(of: HBaseController.self) {
                switch (self.appearType) {
                case .undefine, .present:
                    // dismiss with present animation
                    self.dismiss(animated: true, completion: {
                        completion?()
                    })
                    return
                case .push:
                    // pop view controller with push animation
                    completion?()
                    navi.popViewController(animated: true)
                    return
                default:
                    break
                }
            } else {
                let viewcontrollers = navi.viewControllers
                let topViewController = navi.topViewController
                if viewcontrollers.count > 1 && topViewController == self {
                    // pop view controller with push animation
                    completion?()
                    navi.popViewController(animated: true)
                    return
                }
            }
        }
        // dismiss with present animation
        self.dismiss(animated: true, completion: {
            completion?()
        })
    }
    
    /*
    var leftBarButtonItem: UIBarButtonItem? {
        get { return self.getAssociatedValueForKey(&kNaviLeftItemKey) as? UIBarButtonItem }
        set {
            if let view = newValue?.customView, view.isKind(of: UIButton.self) {
                let button = view as! UIButton
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            }else {
                newValue?.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            }
            self.navigationItem.leftBarButtonItem = newValue
            self.setAssociateValue(newValue, key: &kNaviLeftItemKey)
        }
    }
    
    var rightBarButtonItem: UIBarButtonItem? {
        get { return self.getAssociatedValueForKey(&kNaviRightItemKey) as? UIBarButtonItem }
        set {
            if let view = newValue?.customView, view.isKind(of: UIButton.self) {
                let button = view as! UIButton
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
            }else {
                newValue?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
            }
            self.navigationItem.rightBarButtonItem = newValue
            self.setAssociateValue(newValue, key: &kNaviRightItemKey)
        }
    }
     */

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
        viewControllers.forEach { vc in
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
