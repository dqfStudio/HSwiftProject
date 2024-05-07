//
//  HNetworkDAO.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/19.
//  Copyright © 2020 wind. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class HNetworkDAO {
    
    /// 网络请求方法
    static func request(url: URLConvertible,
                        method: HTTPMethod,
                        headers: HTTPHeaders,
                        parameters: Parameters?,
                        encoding: ParameterEncoding,
                        interceptor: RequestInterceptor? = nil,
                        success: @escaping (_ response: HNetworkResponse) -> Void,
                        failure: @escaping (_ error: HNetworkError) -> Void) {
        AF.request(url, method: method, parameters: parameters,
                   encoding: encoding, headers: headers, interceptor: interceptor,
                   requestModifier: { $0.timeoutInterval = 30 }).response { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                guard let resData = data, !resData.isEmpty else {
                    failure(HNetworkError(code: -1, msg: "数据为空"))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: resData, options: .allowFragments)
                    // NSLog(resData.stringValue ?? "")
                    self.success(withString: json, block: success)
                } catch {
                    // NSLog(resData.stringValue ?? "")
                    failure(HNetworkError(code: -1, msg: "数据不能格式化"))
                }
            case .failure(let error):
                failure(HNetworkError.requestError(with: error))
            }
        }
    }
    
    /// 上传请求方法
    static func uploadMedia(url: URLConvertible,
                            headers: HTTPHeaders,
                            parameters: Parameters?,
                            image: UIImage?,
                            videoURL: URL?,
                            interceptor: RequestInterceptor? = nil,
                            success: @escaping (_ response: HNetworkResponse) -> Void,
                            failure: @escaping (_ error: HNetworkError) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            let timeInterval = Int(Date().timeIntervalSince1970 * 1000)
            let imageName = "\(timeInterval).jpg"
            let videoName = "\(timeInterval).mp4"
            if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
            }
            if let videoURL = videoURL, FileManager.default.fileExists(atPath: videoURL.path) {
                multipartFormData.append(videoURL, withName: "video", fileName: videoName, mimeType: "video/mp4")
            }
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let val = value as? String, let data = val.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
        }, to: url, headers: headers, interceptor: interceptor).response { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                guard let resData = data, !resData.isEmpty else {
                    failure(HNetworkError(code: -1, msg: "数据为空"))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: resData, options: .allowFragments)
                    // NSLog(resData.stringValue ?? "")
                    self.success(withString: json, block: success)
                } catch {
                    // NSLog(resData.stringValue ?? "")
                    failure(HNetworkError(code: -1, msg: "数据不能格式化"))
                }
            case .failure(let error):
                failure(HNetworkError.requestError(with: error))
            }
        }
    }
}

fileprivate extension HNetworkDAO {
    
    static func success(withString string: Any, block: @escaping (_ response: HNetworkResponse) -> Void) {
        let response = HNetworkResponse()
        guard let resString = string as? String, !resString.isEmpty else {
            response.errCode = -1
            response.errMsg = "数据解析出错"
            block(response)
            return
        }
        guard var dict = resString.dictionary else {
            response.errCode = -1
            response.errMsg = "数据序列化出错"
            block(response)
            return
        }
        if let codeValue = dict["code"] as? Int {
            response.errCode = codeValue
            dict.updateValue(codeValue, forKey: "errCode")
        }
        if let msgValue = dict["msg"] as? String {
            response.errMsg = msgValue
            dict.updateValue(msgValue, forKey: "errCode")
        }
        if let newJsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let newStr = String(data: newJsonData, encoding: .utf8) {
            response.data = newStr
        }
        block(response)
    }
    
}
