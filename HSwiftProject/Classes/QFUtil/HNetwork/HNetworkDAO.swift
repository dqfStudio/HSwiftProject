//
//  HNetworkDAO.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/19.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit
import Alamofire
 
class HNetworkDAO: NSObject {
    
    ///初始化域名
    static let hostName = ""
    
    ///网络请求
    func getData(url: String, parameters: [String: Any]?,
                 success: @escaping (_ result: Any?) -> Void,
                 failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        Alamofire.SessionManager.default.retrier = nil
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                self.successWithResponse(response, block: success)
            case .failure(_):
                self.failureWithResponse(response, block: failure)
            }
        }
    }

    
    func postData(url: String, parameters:[String: Any]?,
                  success: @escaping (_ result: Any?) -> Void,
                  failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        Alamofire.SessionManager.default.retrier = nil
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                self.successWithResponse(response, block: success)
            case .failure(_):
                self.failureWithResponse(response, block: failure)
            }
        }
    }
    
    ///默认三次重试的网络请求
    func retryGetData(url: String, parameters:[String: Any]?,
                      success: @escaping (_ result: Any?) -> Void,
                      failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        Alamofire.SessionManager.default.retrier = HRetrier()
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                self.successWithResponse(response, block: success)
            case .failure(_):
                self.failureWithResponse(response, block: failure)
            }
        }
    }
    
    func retryPostData(url: String, parameters:[String: Any]?,
                       success: @escaping (_ result: Any?) -> Void,
                       failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        Alamofire.SessionManager.default.retrier = HRetrier()
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                self.successWithResponse(response, block: success)
            case .failure(_):
                self.failureWithResponse(response, block: failure)
            }
        }
    }
    
    private func successWithResponse(_ response: DataResponse<Any>, block: @escaping (_ result: Any?) -> Void) {
        block(response.result.value)
    }
    
    private func failureWithResponse(_ response: DataResponse<Any>, block: @escaping (_ error: Error?) -> Void) {
        block(response.error)
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
