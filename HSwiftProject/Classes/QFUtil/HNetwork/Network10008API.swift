//
//  Network10008API.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/7.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum Network10008API: String, URLConvertible {
    /// User
    case userLogin = "/user/user_login" // 用户登陆
    
    /// 实现协议方法
    func asURL() throws -> URL {
        guard let url = URL(string: urlString) else { throw AFError.invalidURL(url: self) }
        return url
    }

    /// 拼接过的地址链接
    private var urlString: String {
        return "IPServer.shared.ipIm10008".appending(rawValue)
    }

//    var method: HTTPMethod {
//        switch self {
//        case .getOpenGroupNew, .avatar, .selectOldFace, .groupGetBlacks, .groupCreateType, .getLiveSessionID, .getOpenBanner, .postUnreadMsg, .getGroupClassList, .getGroupClass, .getGroupClassNew, .svideoMsgUnreadCount, .getCreatorApply, .getCreatorEarning, .getOwnedGroups, .groupAdmin, .getGroupSelectTime:
//            return .get
//        default:
//            return .post
//        }
//    }

    var header: HTTPHeaders {
//        var token = ""
//        if GlobalInfo.shared.isLogin {
//            token = UserDefaults.standard.string(forKey: kIMTokenKey) ?? ""
//        }
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
//            "app-version": kHttpCryptor ? Utility.getOutVersion() : "",
//            "timestamp": "\(Int(Date().timeIntervalSince1970))",
//            "lang": GLocalizationManager.userLang(),
//            "token": token,
//            "fingerInfo": IPServer.shared.fingerprint ?? "",
//            "deviceFinger": IPServer.shared.ydunFinger ?? "",
//            "deviceinfo": IPServer.shared.getDeviceInfo(),
            "platform": "1"
        ]
        return headers
    }
}

extension HNetworkDAO {
    /// 网络请求方法
    static func getPort10008(api: Network10008API,
                             parameters: Parameters? = nil,
                             success: @escaping (_ result: String?) -> Void,
                             failure: @escaping (_ error: HNetworkError) -> Void) {
        self.request(url: api, method: .get, headers: api.header, parameters: parameters, encoding: URLEncoding.default) { response in
            if response.errCode == 0 {
                success(response.data)
            }else {
                failure(HNetworkError(code: -1, msg: "errCode不为零"))
            }
        } failure: { error in
            failure(error)
        }
    }
    
    static func postPort10008(api: Network10008API,
                              parameters: Parameters? = nil,
                              success: @escaping (_ result: String?) -> Void,
                              failure: @escaping (_ error: HNetworkError) -> Void) {
        self.request(url: api, method: .post, headers: api.header, parameters: parameters, encoding: JSONEncoding.default) { response in
            if response.errCode == 0 {
                success(response.data)
            }else {
                failure(HNetworkError(code: -1, msg: "errCode不为零"))
            }
        } failure: { error in
            failure(error)
        }
    }
    
    /// 默认两次重试的网络请求
    static func retryGetPort10008(api: Network10008API,
                                  parameters: Parameters? = nil,
                                  success: @escaping (_ result: String?) -> Void,
                                  failure: @escaping (_ error: HNetworkError) -> Void) {
        self.request(url: api, method: .get, headers: api.header, parameters: parameters, encoding: URLEncoding.default, interceptor: RetryPolicy()) { response in
            if response.errCode == 0 {
                success(response.data)
            }else {
                failure(HNetworkError(code: -1, msg: "errCode不为零"))
            }
        } failure: { error in
            failure(error)
        }
    }
    
    static func retryPostPort10008(api: Network10008API,
                                   parameters: Parameters? = nil,
                                   success: @escaping (_ result: String?) -> Void,
                                   failure: @escaping (_ error: HNetworkError) -> Void) {
        self.request(url: api, method: .post, headers: api.header, parameters: parameters, encoding: JSONEncoding.default, interceptor: RetryPolicy()) { response in
            if response.errCode == 0 {
                success(response.data)
            }else {
                failure(HNetworkError(code: -1, msg: "errCode不为零"))
            }
        } failure: { error in
            failure(error)
        }
    }
}
