//
//  HActiveNaviController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/5.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HActiveNaviController: HBaseNaviController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        setNavigationBarColor(.black)
    }
    
    func setNavigationBarColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        if color == .clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithOpaqueBackground()
        }
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.font(ofSize: 17, weight: .medium)
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.isTranslucent = color == .clear || color.cgColor.alpha < 1
        navigationBar.barTintColor = color
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            configureBackItemIfNeeded(viewController)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    /// 系统栏场景补一个可点的返回项。原先 `self?.naviBack()` 作用在导航控制器上，会 dismiss 整栈。
    private func configureBackItemIfNeeded(_ viewController: UIViewController) {
        let item = viewController.navigationItem.leftItem
        if item.image == nil, (item.title ?? "").isEmpty {
            item.image = UIImage(named: "hvc_back_icon")?.withRenderingMode(.alwaysTemplate)
            item.tintColor = navigationBar.tintColor
        }
        if item.pressed == nil {
            item.pressed = { [weak viewController] in
                viewController?.naviBack()
            }
        }
    }
}
