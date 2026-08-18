//
//  HBaseViewModel.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// 基础视图模型
///
/// 提供导航标题和订阅生命周期。子类若重写 `destroy()` 必须调用 `super.destroy()`。
class HBaseViewModel {
    
    /// 导航栏标题
    let naviTitleRelay = BehaviorRelay<String?>(value: nil)
    
    /// VM 内部订阅。外部只应通过 `destroy()` 重置，不要直接赋值。
    private(set) var disposeBag = DisposeBag()
    
    init() {}
    
    /// 释放订阅。页面 pop / dismiss 时应调用，可重复调用。
    func destroy() {
        disposeBag = DisposeBag()
    }
}
