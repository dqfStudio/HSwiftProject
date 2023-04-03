//
//  HNetworkManager.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/19.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit
import Alamofire

typealias HNetworkStatus = (_ KNetworkStatus: Int) -> Void

@objc
enum KNetworkStatus: Int {
    case  Unknow    = -1  // 未知
    case  Not       = 0   // 无网络
    case  Wwan      = 1   // 2g，3g，4g
    case  Wifi      = 2   // wifi
}

class HNetworkManager: NSObject {
    
    static let shareManager: HNetworkManager = {
        return HNetworkManager()
    }()
    
    ///当前网络状态
    var networkStatus: KNetworkStatus = KNetworkStatus.Unknow
    
    ///网络请求
    func sendGetWith(url: String,
                     parameters:[String: Any]?,
                        success:@escaping HRequestSuccessBlock,
                        failure:@escaping HRequestFailureBlock) {
        HNetworkDAO().sendPostWith(url: url, parameters: parameters, success: success, failure: failure)
    }
    
    func sendPostWith(url: String,
                      parameters:[String: Any]?,
                         success:@escaping HRequestSuccessBlock,
                         failure:@escaping HRequestFailureBlock) {
        HNetworkDAO().sendPostWith(url: url, parameters: parameters, success: success, failure: failure)
    }
    
    ///默认三次重试的网络请求
    func retryGetWithUrl(url: String,
                         parameters:[String: Any]?,
                            success:@escaping HRequestSuccessBlock,
                            failure:@escaping HRequestFailureBlock) {
        HNetworkDAO().retryGetWithUrl(url: url, parameters: parameters, success: success, failure: failure)
    }
    
    func retryPostWithUrl(url: String,
                          parameters:[String: Any]?,
                             success:@escaping HRequestSuccessBlock,
                             failure:@escaping HRequestFailureBlock) {
        HNetworkDAO().retryPostWithUrl(url: url, parameters: parameters, success: success, failure: failure)
    }
}

// 网络状态监听
extension HNetworkManager {
    
    func monitoringNetwork (networkStatus:@escaping HNetworkStatus) {
        let reachability = NetworkReachabilityManager()
        reachability?.startListening()
        reachability?.listener = { [weak self] status in
            guard let weakSelf = self else { return }
            if reachability?.isReachable ?? false {
                switch status {
                case .notReachable:
                    weakSelf.networkStatus = KNetworkStatus.Not
                case .unknown:
                    weakSelf.networkStatus = KNetworkStatus.Unknow
                case .reachable(.wwan):
                    weakSelf.networkStatus = KNetworkStatus.Wwan
                case .reachable(.ethernetOrWiFi):
                    weakSelf.networkStatus = KNetworkStatus.Wifi
                }
            }else {
               weakSelf.networkStatus = KNetworkStatus.Not
            }
            networkStatus(weakSelf.networkStatus.rawValue)
        }
    }
    
//    public func monitoringDataFormLocalWhenNetChanged() {
//        self.monitoringNetwork{ (_) in
//
//        }
//    }
 
}

