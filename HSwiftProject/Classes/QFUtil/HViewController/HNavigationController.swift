//
//  HNavigationController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HNavigationController: HBaseNaviController {
    
    // MARK: - Factory Methods
    
    /// 创建全屏模态导航控制器
    /// - Parameter rootVC: 根视图控制器
    /// - Returns: 配置好的导航控制器
    class func fullScreenModalNavi(rootVC: UIViewController) -> HNavigationController {
        let navi = HNavigationController(rootViewController: rootVC)
        navi.modalPresentationStyle = .fullScreen
        return navi
    }
}

// MARK: - Lifecycle
extension HNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEdgePanGesture()
    }
    
}
