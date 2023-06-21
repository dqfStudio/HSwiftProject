//
//  HNetworkDAO.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/19.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit
import Alamofire

typealias HRequestSuccessBlock = (_ response: AnyObject) -> Void
typealias HRequestFailureBlock = (_ error: AnyObject) -> Void
 
class HNetworkDAO: NSObject {
    
    ///初始化域名
    static let hostName = ""
    
    ///网络请求
    func sendGetWith(url: String,
                     parameters:[String: Any]?,
                        success:@escaping HRequestSuccessBlock,
                        failure:@escaping HRequestFailureBlock) {
        var urlString = url
        let baseUrl = HNetworkDAO.hostName
        if baseUrl.length > 0, url.length > 0 {
            if url.hasPrefix(baseUrl) == false {
                urlString = baseUrl + url
            }
            Alamofire.SessionManager.default.retrier = nil
            Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    self.successWithResponse(response, block: success)
                    break
                case .failure(_):
                    self.failureWithResponse(response, block: failure)
                    break
                }
            }
        }
    }
    
    func sendPostWith(url: String,
                      parameters:[String: Any]?,
                         success:@escaping HRequestSuccessBlock,
                         failure:@escaping HRequestFailureBlock) {
        var urlString = url
        let baseUrl = HNetworkDAO.hostName
        if baseUrl.length > 0, url.length > 0 {
            if url.hasPrefix(baseUrl) == false {
                urlString = baseUrl + url
            }
            Alamofire.SessionManager.default.retrier = nil
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    self.successWithResponse(response, block: success)
                    break
                case .failure(_):
                    self.failureWithResponse(response, block: failure)
                    break
                }
            }
        }
    }
    
    ///默认三次重试的网络请求
    func retryGetWithUrl(url: String,
                         parameters:[String: Any]?,
                            success:@escaping HRequestSuccessBlock,
                            failure:@escaping HRequestFailureBlock) {
        var urlString = url
        let baseUrl = HNetworkDAO.hostName
        if baseUrl.length > 0, url.length > 0 {
            if url.hasPrefix(baseUrl) == false {
                urlString = baseUrl + url
            }
            Alamofire.SessionManager.default.retrier = HRetrier()
            Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    self.successWithResponse(response, block: success)
                    break
                case .failure(_):
                    self.failureWithResponse(response, block: failure)
                    break
                }
            }
        }
    }
    
    func retryPostWithUrl(url: String,
                          parameters:[String: Any]?,
                             success:@escaping HRequestSuccessBlock,
                             failure:@escaping HRequestFailureBlock) {
        var urlString = url
        let baseUrl = HNetworkDAO.hostName
        if baseUrl.length > 0, url.length > 0 {
            if url.hasPrefix(baseUrl) == false {
                urlString = baseUrl + url
            }
            Alamofire.SessionManager.default.retrier = HRetrier()
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    self.successWithResponse(response, block: success)
                    break
                case .failure(_):
                    self.failureWithResponse(response, block: failure)
                    break
                }
            }
        }
    }
    
    private func successWithResponse(_ response: DataResponse<Any>, block: @escaping HRequestSuccessBlock) {
        if let value = response.result.value as? [String: Any] {
            block(value as AnyObject)
        }
    }
    
    private func failureWithResponse(_ response: DataResponse<Any>, block: @escaping HRequestFailureBlock) {
        block(response.error as AnyObject)
    }
}

private class HRetrier: RequestRetrier {
    private var count: Int = 0
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if count < 3 {
            completion(true, 0.25)
            count += 1
        }else {
            completion(false, 0.25)
        }
    }
}
