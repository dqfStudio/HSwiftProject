//
//  HNavigationController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

//@interface HNavigationController () <UIGestureRecognizerDelegate>
//@property(nonatomic, strong) NSMutableArray *blackList
//@end

class HNavigationController : UINavigationController, UIGestureRecognizerDelegate {

    /// Lazy load
    private let blackList = NSMutableArray()

    /// Public
    func addFullScreenPopBlackListItem(_ viewController: UIViewController) {
        self.blackList.add(viewController)
    }

    func removeFromFullScreenPopBlackList(_ viewController: UIViewController) {
        for item in self.blackList {
            let vc: UIViewController = item as! UIViewController
            if vc.isKind(of: UIViewController.self) {
                self.blackList.remove(vc)
            }
        }
    }

    /// Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        for item in self.blackList {
            let vc: UIViewController = item as! UIViewController
            if vc == self.topViewController {
                return false
            }
        }
        
        //如果这个push  pop 动画正在执行(私有属性)，不允许手势
        if self.value(forKeyPath: "_isTransitioning") as! Bool == false {
            return false
        }
        
        // 解决右滑和UITableView左滑删除的冲突
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        
        //当前控制器为根控制器，不允许手势
        return self.children.count == 1 ? false : true
    }

    /// 旋转支持
    override var shouldAutorotate: Bool {
        return self.topViewController!.shouldAutorotate
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController!.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController!.preferredInterfaceOrientationForPresentation
    }

}

//extension UIViewController {
//    @available(iOS 5.0, *)
//    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (())? = nil) {
//
//    }
//    - (void)presentViewController:(UIViewController *)viewControllerToPresent param:(NSDictionary *)dict animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
//        if (dict) [viewControllerToPresent autoFill:dict map:nil exclusive:NO isDepSearch:YES]
//        [self presentViewController:viewControllerToPresent animated:flag completion:completion]
//    }
//}
//
//extension UINavigationController {
//    - (void)pushViewController:(UIViewController *)viewController param:(NSDictionary *)dict animated:(BOOL)animated {
//        if (dict) [viewController autoFill:dict map:nil exclusive:NO isDepSearch:YES]
//        [self pushViewController:viewController animated:animated]
//    }
//}
