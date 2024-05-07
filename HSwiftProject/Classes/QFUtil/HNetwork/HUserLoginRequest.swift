//
//  HUserLoginRequest.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/7.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation
import RxSwift

class HUserLoginRequest {
    static func loadData(userID: String,
                         success: @escaping (_ model: HUserLoginModel?) -> Void,
                         failure: @escaping (_ error: HNetworkError) -> Void) {
        let oid = "\(Int(Date().timeIntervalSince1970))"
        let param = ["operationID": oid, "userID": userID] as [String : Any]
        HNetworkDAO.getPort10008(api: Network10008API.userLogin, parameters: param) { result in
            success(self.dataHandle(result))
        } failure: { error in
            failure(error)
        }
    }
    
    static func dataHandle(_ data: String?) -> HUserLoginModel? {
//        guard let result = data,
//              let tmpData = kHttpCryptor ? AESEncryptor.cfbDecode(key: GlobalInfo.shared.apiKey ?? "", value: (result as? String) ?? "").data(using: .utf8) : result.data(using: .utf8),
//              let model = try? JSONDecoder().decode(HUserLoginModel.self, from: tmpData) else {
//            return nil
//        }
//        return model
        return nil
    }
}

struct HUserLoginModel: Decodable {
    var userId: String?
    var userName: String?
}
