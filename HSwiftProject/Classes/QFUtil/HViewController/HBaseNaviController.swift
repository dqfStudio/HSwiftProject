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

    // 实现类似系统自带的边缘触发手势返回的效果
    func handleNaviTransition() {
        // Turn off the edge trigger gesture to prevent conflicts with the original edge gesture
        self.interactivePopGestureRecognizer?.isEnabled = false
        // 添加边缘手势识别器UIScreenEdgePanGestureRecognizer
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture))
        edgePanGesture.edges = .left //设置手势响应的边缘
        self.view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc
    func handleEdgePanGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .changed else {
            return
        }
        guard let topVC = self.topViewController, !self.blackList.contains(topVC) else {
            return
        }
        guard let isTransitioning = self.value(forKeyPath: "_isTransitioning") as? Bool, isTransitioning else {
            return
        }
        let location = gesture.location(in: gesture.view)
        guard location.x > 0 else {
            return
        }
        if self.children.count > 1 {
            self.naviBack()
        }
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
