//
//  HBaseNaviController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/5.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HBaseNaviController: UINavigationController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    /// 全屏返回手势黑名单
    private var fullScreenPopBlackList = [UIViewController]()

    // MARK: - Public Methods
    
    /// 添加到全屏返回手势黑名单
    func addFullScreenPopBlackListItem(_ viewController: UIViewController) {
        fullScreenPopBlackList.append(viewController)
    }

    /// 从全屏返回手势黑名单移除
    func removeFromFullScreenPopBlackList(_ viewController: UIViewController) {
        fullScreenPopBlackList.removeAll(where: { $0 === viewController })
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /// 初始化设置
    private func initialize() {
        // 关闭暗黑模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }

    // MARK: - Gesture Handling
    
    /// 处理导航过渡
    func setupEdgePanGesture() {
        // 关闭系统边缘触发手势，防止与自定义边缘手势冲突
        interactivePopGestureRecognizer?.isEnabled = false
        
        // 添加边缘手势识别器
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    /// 处理边缘滑动手势
    @objc
    private func handleEdgePanGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .changed else { return }
        guard let topVC = topViewController, !fullScreenPopBlackList.contains(topVC) else { return }
        guard children.count > 1 else { return }
        
        let location = gesture.location(in: gesture.view)
        guard location.x > 0 else { return }
        
        naviBack()
    }

}

// MARK: - Orientation Handling
extension HBaseNaviController {
    /// 是否自动旋转
    override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? false
    }
    
    /// 支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    /// 首选方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
