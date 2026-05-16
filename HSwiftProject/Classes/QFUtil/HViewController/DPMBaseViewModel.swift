//
//  DPMBaseViewModel.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/// 基础视图模型类
///
/// 提供视图模型的通用功能，如导航栏标题管理和资源释放
class DPMBaseViewModel {
    
    // MARK: - Properties
    
    /// 导航栏标题的 Relay
    let naviTitleRelay = BehaviorRelay<String?>(value: nil)
    
    /// 用于管理 RxSwift 订阅
    var disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
    }
    
    // MARK: - Cleanup
    
    /// 销毁资源
    ///
    /// 释放所有订阅和资源，防止内存泄漏
    func destroy() {
        disposeBag = DisposeBag()
    }
    
}
