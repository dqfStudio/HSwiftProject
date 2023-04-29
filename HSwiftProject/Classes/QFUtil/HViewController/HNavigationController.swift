//
//  HNavigationController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HNavigationController : UINavigationController, UIGestureRecognizerDelegate {

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
        //设置相关属性
        self.pvc_initialize()
    }
    
    //设置相关属性
    private func pvc_initialize() {
        //  这句很核心
        let target = self.interactivePopGestureRecognizer!.delegate
        //  这句很核心
        let handler = NSSelectorFromString("handleNavigationTransition:")
        //  获取添加系统边缘触发手势的View
        let targetView: UIView = self.interactivePopGestureRecognizer!.view!
        
        //  创建pan手势 作用范围是全屏
        let fullScreenGes = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenGes.delegate = self
        targetView.addGestureRecognizer(fullScreenGes)
        
        // 关闭边缘触发手势 防止和原有边缘手势冲突
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        //modalPresentationStyle 设置默认样式为 UIModalPresentationFullScreen
        self.modalPresentationStyle = .fullScreen
        //关闭暗黑模式
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    /// UIGestureRecognizerDelegate
    ///  防止导航控制器只有一个rootViewcontroller时触发手势
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        // 根据具体控制器对象决定是否开启全屏右滑返回
        if let topVC = self.topViewController, self.blackList.contains(topVC) {
            return false
        }
        
        //如果这个push  pop 动画正在执行(私有属性)，不允许手势
        guard let isTransitioning = self.value(forKeyPath: "_isTransitioning") as? Bool, isTransitioning else {
            return false
        }
        
        // 解决右滑和UITableView左滑删除的冲突
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view)
        guard translation.x > 0 else {
            return false
        }
        
        //当前控制器为根控制器，不允许手势
        return self.children.count > 1
    }

}

// MARK: - 横纵屏
extension HNavigationController {
    //是否自动旋转,返回YES可以自动旋转
    override var shouldAutorotate: Bool {
        return self.topViewController!.shouldAutorotate
    }
    //返回支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController!.supportedInterfaceOrientations
    }
    //这个是返回优先方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController!.preferredInterfaceOrientationForPresentation
    }
}
