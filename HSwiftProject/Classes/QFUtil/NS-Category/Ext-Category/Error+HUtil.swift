//
//  Error+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

let kCodeOK: Int = 200
let kInnerErrorCode : Int = -1023
let kCancelCode : Int = -1022
let kDataFormatErrorCode : Int = -1024
let kNetWorkErrorCode : Int = -1025
let kLogicErrorCode : Int = -1026
let kNoDataErrorCode : Int = -1027
let kAsyncCanelErrorCode : Int = -1029

extension NSError {
    
    static func errorWithDomain(_ domain: String!, code: NSInteger) -> AnyObject {
        return NSError(domain: domain, code: code, userInfo: nil)
    }
    
    static func errorWithDomain(_ domain: String!, code: NSInteger, description: String!) -> AnyObject {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : description!])
    }
    
    static func errorWithDomain(_ domain: String!, code: NSInteger, description: String!, reason: String!) -> AnyObject {
        let dict: NSDictionary = [NSLocalizedDescriptionKey : description!, NSLocalizedFailureReasonErrorKey : reason!]
        return NSError(domain: domain, code: code, userInfo: dict as? [String : Any])
    }
    
}

func herr(_ theCode: NSInteger, desc: String) -> NSError { return NSError.errorWithDomain("\(#file)", code: theCode, description: desc) as! NSError }
