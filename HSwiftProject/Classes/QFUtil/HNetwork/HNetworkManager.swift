//
//  HNetworkManager.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/19.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit
import Alamofire

@objc
enum KNetworkStatus: Int {
    case  Unknow    = -1  // 未知
    case  Not       = 0   // 无网络
    case  Wwan      = 1   // 2g，3g，4g，5g
    case  Wifi      = 2   // wifi
}

class HNetworkManager: NSObject {
    
    static let shareManager: HNetworkManager = {
        return HNetworkManager()
    }()
    
    ///当前网络状态
    var networkStatus: KNetworkStatus = .Unknow
    
//    ///网络请求
//    func getData(url: String, parameters:[String: Any]?,
//                 success: @escaping (_ result: Any?) -> Void,
//                 failure: @escaping (_ error: Error?) -> Void) {
//        HNetworkDAO().getData(url: url, parameters: parameters, success: success, failure: failure)
//    }
//    
//    func postData(url: String, parameters:[String: Any]?,
//                  success: @escaping (_ result: Any?) -> Void,
//                  failure: @escaping (_ error: Error?) -> Void) {
//        HNetworkDAO().postData(url: url, parameters: parameters, success: success, failure: failure)
//    }
//    
//    ///默认三次重试的网络请求
//    func retryGetData(url: String, parameters:[String: Any]?,
//                      success: @escaping (_ result: Any?) -> Void,
//                      failure: @escaping (_ error: Error?) -> Void) {
//        HNetworkDAO().retryGetData(url: url, parameters: parameters, success: success, failure: failure)
//    }
//    
//    func retryPostData(url: String, parameters:[String: Any]?,
//                       success: @escaping (_ result: Any?) -> Void,
//                       failure: @escaping (_ error: Error?) -> Void) {
//        HNetworkDAO().retryPostData(url: url, parameters: parameters, success: success, failure: failure)
//    }
}

// 网络状态监听
extension HNetworkManager {
    
    func monitoringNetwork (networkStatus: @escaping (_ KNetworkStatus: Int) -> Void) {
        guard let reachability = NetworkReachabilityManager(host: "baidu.com") else { return }
        let listener: NetworkReachabilityManager.Listener = { [weak self] status in
            guard let self = self else { return }
            if reachability.isReachable {
                switch status {
                case .notReachable:
                    self.networkStatus = .Not
                case .unknown:
                    self.networkStatus = .Unknow
                case .reachable(.cellular):
                    self.networkStatus = .Wwan
                case .reachable(.ethernetOrWiFi):
                    self.networkStatus = .Wifi
                }
            }else {
                self.networkStatus = .Not
            }
            networkStatus(self.networkStatus.rawValue)
        }
        
        // 开始监听网络状态变化
        reachability.startListening(onQueue: .main, onUpdatePerforming: listener)
        
        // 当你不再需要监听时，可以调用 stopListening() 方法
        // reachabilityManager.stopListening()
    }
        
}
