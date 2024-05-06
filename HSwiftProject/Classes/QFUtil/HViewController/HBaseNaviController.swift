//
//  HBaseNaviController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/5.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HBaseNaviController: UINavigationController, UIGestureRecognizerDelegate {

    /// Lazy load
    private var blackList = [UIViewController]()

    /// Public
    func addFullScreenPopBlackListItem(_ viewController: UIViewController) {
        blackList.append(viewController)
    }

    func removeFromFullScreenPopBlackList(_ viewController: UIViewController) {
        blackList.removeAll(where: { $0 === viewController })
    }

    /// Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set related properties
        self.pvc_initialize()
    }
    
    // Set related properties
    private func pvc_initialize() {
        // Set the default style to UIModalPresentationFullScreen
        //self.modalPresentationStyle = .fullScreen
        // Turn off dark mode
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    // 全屏手势返回功能
    // 实现类似系统自带的边缘触发手势返回的效果
    func handleNaviTransition() {
        //  This line is very core
        guard let target = self.interactivePopGestureRecognizer?.delegate else { return }
        //  This line is very core
        let handler = NSSelectorFromString("handleNavigationTransition:")
        //  Get the view that adds the system edge trigger gesture
        guard let targetView = self.interactivePopGestureRecognizer?.view else { return }
        
        //  Create a pan gesture with full screen effect
        let fullScreenGes = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenGes.delegate = self
        targetView.addGestureRecognizer(fullScreenGes)
        
        // Turn off the edge trigger gesture to prevent conflicts with the original edge gesture
        self.interactivePopGestureRecognizer?.isEnabled = false
    }

    /// UIGestureRecognizerDelegate
    /// Prevent gesture triggering when the navigation controller has only one root view controller
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        // Decide whether to enable full-screen right slide back based on the specific controller object
        if let topVC = self.topViewController, self.blackList.contains(topVC) {
            return false
        }
        
        // If this push pop animation is being executed (private property), gestures are not allowed
        guard let isTransitioning = self.value(forKeyPath: "_isTransitioning") as? Bool, isTransitioning else {
            return false
        }
        
        // Solve the conflict between right slide and UITableView left slide deletion
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view)
        guard translation.x > 0 else {
            return false
        }
        
        // Gestures are not allowed when the current controller is the root controller
        return self.children.count > 1
    }

}

// MARK: - Landscape and portrait
extension HBaseNaviController {
    // Whether to rotate automatically, returning YES can rotate automatically
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    // Return the supported direction
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    // This is the preferred direction
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
