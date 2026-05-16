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
    
    /// 返回事件处理
    @objc
    func naviBack(_ completion: (() -> Void)? = nil) {
        // 优先判断是否存在导航控制器
        guard let navi = navigationController else {
            dismiss(animated: true, completion: completion)
            return
        }
        
        // 判断是否为自定义导航+自定义控制器
        let isCustomNavAndVC = navi is HBaseNaviController && self is HBaseController
        
        if isCustomNavAndVC {
            // 按 appearType 分支处理
            switch appearType {
            case .push:
                navi.popViewController(animated: true)
                completion?()
            case .undefine, .present:
                fallthrough
            default:
                dismiss(animated: true, completion: completion)
            }
        } else {
            // 非自定义导航/控制器：判断是否可 pop
            let canPop = navi.viewControllers.count > 1 && navi.topViewController === self
            if canPop {
                navi.popViewController(animated: true)
                completion?()
            } else {
                dismiss(animated: true, completion: completion)
            }
        }
    }

}

// MARK: - HViewController Extension

extension HViewController {
    
    /// 重写 present 方法
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        // 设置视图控制器的出现类型为 present
        viewControllerToPresent.appearType = .present
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    /// 重写 dismiss 方法
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) { [weak self] in
            completion?()
            // 处理消失事件
            self?.handleDismissEvent()
        }
    }
    
    /// 处理 dismiss 事件
    private func handleDismissEvent() {
        if let viewControllers = navigationController?.viewControllers {
            // 遍历导航控制器中的所有视图控制器，设置它们的消失类型为 dismiss
            viewControllers.forEach { $0.vcWillDisappear(.dismiss) }
        } else {
            // 如果没有导航控制器，当前视图控制器的消失类型为 dismiss
            vcWillDisappear(.dismiss)
        }
    }
    
}

// MARK: - HNavigationController Extension

extension HNavigationController {
    
    /// 重写 popViewController 方法
    @discardableResult
    open override func popViewController(animated: Bool) -> UIViewController? {
        guard let popVC = super.popViewController(animated: animated) else {
            return nil
        }
        
        // 设置弹出视图控制器的消失类型为 pop
        popVC.vcWillDisappear(.pop)
        return popVC
    }
    
    /// 重写 pushViewController 方法
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 设置顶部视图控制器的消失类型为 push
        topViewController?.vcWillDisappear(.push)
        
        // 如果导航栈不为空，设置新视图控制器的出现类型为 push
        if !viewControllers.isEmpty {
            viewController.appearType = .push
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
