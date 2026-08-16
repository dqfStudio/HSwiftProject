//
//  UIViewController+HDisappear.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Enums

/// 视图控制器出现类型
@objc
enum HVCAppearType: Int {
    /// 未定义
    case undefine = 0
    /// 模态展示
    case present  = 1
    /// 导航推入
    case push     = 2
}

/// 视图控制器消失类型
@objc
enum HVCDisappearType: Int {
    /// 未定义
    case undefine = 0
    /// 导航推入（被新页面覆盖）
    case push     = 1
    /// 导航弹出
    case pop      = 2
    /// 模态消失
    case dismiss  = 3
}

// MARK: - Associated Objects

private var kHVCAppearTypeKey: Void?
private var kHVCDidNotifyPermanentDisappearKey: Void?

// MARK: - UIViewController Extension

extension UIViewController {

    // MARK: - Properties
    
    /// 视图控制器出现类型
    var appearType: HVCAppearType {
        get {
            let value = getAssociatedValueForKey(&kHVCAppearTypeKey) as? Int ?? 0
            return HVCAppearType(rawValue: value) ?? .undefine
        }
        set {
            setAssociateValue(newValue.rawValue, key: &kHVCAppearTypeKey)
        }
    }

    // MARK: - Methods
    
    /// 视图控制器即将消失
    @objc
    func vcWillDisappear(_ type: HVCDisappearType) { }
    
    /// pop / dismiss 只通知一次，避免 dismiss 覆盖栈里每个页面重复释放。
    func notifyVCWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            if getAssociatedValueForKey(&kHVCDidNotifyPermanentDisappearKey) as? Bool == true {
                return
            }
            setAssociateValue(true, key: &kHVCDidNotifyPermanentDisappearKey)
        }
        vcWillDisappear(type)
    }
    
    /// 返回事件处理：能 pop 则 pop，否则 dismiss。不再用 appearType 决策，避免 undefine 时误关整栈。
    @objc
    func naviBack(_ completion: (() -> Void)? = nil) {
        if let navi = navigationController,
           navi.viewControllers.count > 1,
           navi.topViewController === self {
            navi.popViewController(animated: true)
            invokeAfterTransition(on: navi.transitionCoordinator, completion: completion)
            return
        }
        
        let presenting = presentingViewController ?? navigationController?.presentingViewController
        guard presenting != nil else {
            completion?()
            return
        }
        let stack = navigationController?.viewControllers ?? [self]
        let dismissor: UIViewController = navigationController ?? self
        dismissor.dismiss(animated: true) {
            completion?()
            stack.forEach { $0.notifyVCWillDisappear(.dismiss) }
        }
    }
    
    func invokeAfterTransition(on coordinator: UIViewControllerTransitionCoordinator?, completion: (() -> Void)?) {
        guard let completion = completion else { return }
        if let coordinator = coordinator {
            let scheduled = coordinator.animate(alongsideTransition: nil) { context in
                if !context.isCancelled {
                    completion()
                }
            }
            if !scheduled {
                completion()
            }
        } else {
            completion()
        }
    }

}


