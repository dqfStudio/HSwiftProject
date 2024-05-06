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
    
    func uploadImage(url: String, image: UIImage,
                     success: @escaping (_ result: Any?) -> Void,
                     failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        guard let tmpURL = URL(string: urlString) else { return }
        guard let urlRequest = try? URLRequest(url: tmpURL, method: .post, headers: nil) else { return }
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let fileName = "\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
                multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        }, with: urlRequest) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        self.successWithResponse(response, block: success)
                    case .failure(_):
                        self.failureWithResponse(response, block: failure)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func uploadVideo(url: String, videoURL: URL,
                     success: @escaping (_ result: Any?) -> Void,
                     failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        guard let tmpURL = URL(string: urlString) else { return }
        guard let urlRequest = try? URLRequest(url: tmpURL, method: .post, headers: nil) else { return }
        Alamofire.upload(multipartFormData: { multipartFormData in
            if FileManager.default.fileExists(atPath: videoURL.path) {
                let fileName = "\(Int(Date().timeIntervalSince1970 * 1000)).mp4"
                multipartFormData.append(videoURL, withName: "video", fileName: fileName, mimeType: "video/mp4")
            }
        }, with: urlRequest) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        self.successWithResponse(response, block: success)
                    case .failure(_):
                        self.failureWithResponse(response, block: failure)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func uploadMedia(url: String, image: UIImage, videoURL: URL,
                     success: @escaping (_ result: Any?) -> Void,
                     failure: @escaping (_ error: Error?) -> Void) {
        guard !url.isEmpty else { return }
        let baseUrl = HNetworkDAO.hostName
        let urlString = url.hasPrefix(baseUrl) ? url : baseUrl + url
        guard let tmpURL = URL(string: urlString) else { return }
        guard let urlRequest = try? URLRequest(url: tmpURL, method: .post, headers: nil) else { return }
        Alamofire.upload(multipartFormData: { multipartFormData in
            let timeInterval = Int(Date().timeIntervalSince1970 * 1000)
            let imageName = "\(timeInterval).jpg"
            let videoName = "\(timeInterval).mp4"
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
            }
            if FileManager.default.fileExists(atPath: videoURL.path) {
                multipartFormData.append(videoURL, withName: "video", fileName: videoName, mimeType: "video/mp4")
            }
        }, with: urlRequest) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        self.successWithResponse(response, block: success)
                    case .failure(_):
                        self.failureWithResponse(response, block: failure)
                    }
                }
            case .failure(let error):
                failure(error)
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
