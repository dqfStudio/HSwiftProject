//
//  DPMBaseViewModel.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/** 刷新数据状态类型*/
@objc
enum DPMRefreshDataStatus: NSInteger {
    /**头部刷新更多数据*/
    case HeaderRefresh_HasMoreData = 1
    /**头部刷新没有更多数据*/
    case HeaderRefresh_HasNoMoreData
    /**底部刷新更多数据*/
    case FooterRefresh_HasMoreData
    /**底部刷新没有更多数据*/
    case FooterRefresh_HasNoMoreData
    /**刷新错误*/
    case RefreshError
    /**刷新UI*/
    case RefreshUI
}

@objcMembers
class DPMBaseViewModel: NSObject, DPMViewModelProtocol {
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    /// 自定义导航标题
    var naviTitleRelay = BehaviorRelay<String?>(value: "")
    
    private var _params:[String:Any] = [:]

    private(set) var params: [String:Any] {
        get { return _params }
        set {
            _params = newValue
        }
    }
    
    var refreshUISubject = PublishSubject<DPMRefreshDataStatus>()
    
    /// 参数传递
    convenience init(Params params: [String: Any]) {
        self.init()
        self.params = params
        self.dpm_initialize()
    }
    
    func dpm_initialize() {
        
    }
    
    func destroy() {
        disposeBag = DisposeBag()
    }
    
    deinit {
        destroy()
    }
}
