//
//  HKeyChainStore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum HKeyChainStoreErrorCode: Int {
    case invalidArguments = 1
}

enum HKeyChainStoreItemClass: Int {
    case genericPassword = 1
    case internetPassword = 2
}

enum HKeyChainStoreProtocolType: Int {
    case FTP = 1
    case FTPAccount = 2
    case HTTP = 3
    case IRC = 4
    case NNTP = 5
    case POP3 = 6
    case SMTP = 7
    case SOCKS = 8
    case IMAP = 9
    case LDAP = 10
    case AppleTalk = 11
    case AFP = 12
    case Telnet = 13
    case SSH = 14
    case FTPS = 15
    case HTTPS = 16
    case HTTPProxy = 17
    case HTTPSProxy = 18
    case FTPProxy = 19
    case SMB = 20
    case RTSP = 21
    case RTSPProxy = 22
    case DAAP = 123
    case EPPC = 24
    case NNTPS = 25
    case LDAPS = 26
    case TelnetS = 27
    case IRCS = 28
    case POP3S = 29
}

enum HKeyChainStoreAuthenticationType: Int {
    case NTLM = 1
    case MSN = 2
    case DPA = 3
    case RPA = 4
    case HTTPBasic = 5
    case HTTPDigest = 6
    case HTMLForm = 7
    case Default = 8
}

enum HKeyChainStoreAccessibility: Int {
    case WhenUnlocked = 1
    case AfterFirstUnlock = 2
    case Always = 3
    case WhenPasscodeSetThisDeviceOnly = 4
    case WhenUnlockedThisDeviceOnly = 5
    case AfterFirstUnlockThisDeviceOnly = 6
    case AlwaysThisDeviceOnly = 7
}

enum HKeyChainStoreAuthenticationPolicy: Int {
    case UserPresence       = 0
    case TouchIDAny         = 1
    case TouchIDCurrentSet  = 2
    case DevicePasscode     = 3
    case ControlOr          = 4
    case ControlAnd         = 5
    case PrivateKeyUsage    = 6
    case ApplicationPassword = 7
}

private var HKeyChainStoreErrorDomain: String = "com.kishikawakatsumi.Hkeychainstore"
private var _defaultService: String = Bundle.main.bundleIdentifier ?? ""

class HKeyChainStore : NSObject {

    private var _itemClass: HKeyChainStoreItemClass = .genericPassword
    var itemClass: HKeyChainStoreItemClass {
        return _itemClass
    }
    
    private var _service: String?
    var service: String? {
        return _service
    }
    
    private var _accessGroup: String?
    var accessGroup: String? {
        return _accessGroup
    }
    
    private var _server: URL?
    var server: URL? {
        return _server
    }
    
    private var _protocolType: HKeyChainStoreProtocolType = .FTP
    var protocolType: HKeyChainStoreProtocolType {
        return _protocolType
    }
    
    private var _authenticationType: HKeyChainStoreAuthenticationType = .NTLM
    var authenticationType: HKeyChainStoreAuthenticationType {
        return _authenticationType
    }
    
    private var _accessibility: HKeyChainStoreAccessibility = .WhenUnlocked
    var accessibility: HKeyChainStoreAccessibility {
        return _accessibility
    }
    
    private var _authenticationPolicy: HKeyChainStoreAuthenticationPolicy = .UserPresence
    var authenticationPolicy: HKeyChainStoreAuthenticationPolicy {
        return _authenticationPolicy
    }
    
    private var _useAuthenticationUI: Bool = false
    var useAuthenticationUI: Bool {
        get { return _useAuthenticationUI }
        set { _useAuthenticationUI = newValue }
    }
    
    private var _synchronizable: Bool = false
    var synchronizable: Bool {
        get { return _synchronizable }
        set {
            _synchronizable = newValue
            if _authenticationPolicy != .UserPresence {
                NSLog("Cannot specify both an authenticationPolicy and a synchronizable")
            }
        }
    }

    var authenticationPrompt: String?
    
    var allKeys: NSArray {
        let items: NSArray = HKeyChainStore.prettify(self.itemClassObject, items:self.items)
        let keys: NSMutableArray = NSMutableArray()
        for tempItem in items {
            let item = tempItem as! NSDictionary
            let key: Any? = item["key"]
            if key != nil {
                keys.add(key!)
            }
        }
        return keys
    }
    
    var allItems: NSArray {
        return HKeyChainStore.prettify(self.itemClassObject, items: self.items)
    }

    ///class init methods
    static var defaultService: String = {
        return _defaultService
    }()

    static func setDefaultService(_ defaultService: String?) {
        _defaultService = defaultService ?? ""
    }

    static var keyChainStore: HKeyChainStore = {
        return HKeyChainStore(service: nil, accessGroup: nil)
    }()

    static func keyChainStoreWithService(_ service: String?) -> HKeyChainStore {
        return HKeyChainStore(service: service, accessGroup: nil)
    }

    static func keyChainStoreWithService(_ service: String?, accessGroup: String?) -> HKeyChainStore {
        return HKeyChainStore(service: service, accessGroup: accessGroup)
    }

    static func keyChainStoreWithServer(_ server: URL, protocolType: HKeyChainStoreProtocolType) -> HKeyChainStore {
        return HKeyChainStore(server: server, protocolType: protocolType, authenticationType: .Default)
    }

    static func keyChainStoreWithServer(_ server: URL, protocolType: HKeyChainStoreProtocolType, authenticationType: HKeyChainStoreAuthenticationType) -> HKeyChainStore {
        return HKeyChainStore(server: server, protocolType: protocolType, authenticationType: authenticationType)
    }

    ///instance init methods
    override convenience init() {
        self.init(service: HKeyChainStore.defaultService, accessGroup: nil)
    }

    convenience init(service: String?) {
        self.init(service: service, accessGroup: nil)
    }

    convenience init(service: String?, accessGroup: String?) {
        self.init()
        _itemClass = HKeyChainStoreItemClass.genericPassword

        var tmpService = service
        if tmpService == nil {
            tmpService = HKeyChainStore.defaultService
        }
        _service = tmpService
        _accessGroup = accessGroup
        self.commonInit()
    }

    convenience init(server: URL, protocolType: HKeyChainStoreProtocolType) {
        self.init(server: server, protocolType: protocolType, authenticationType: .Default)
    }
    
    convenience init(server: URL, protocolType: HKeyChainStoreProtocolType, authenticationType: HKeyChainStoreAuthenticationType) {
        self.init()
        _itemClass = .internetPassword
        
        _server = server
        _protocolType = protocolType
        _authenticationType = authenticationType
        
        self.commonInit()
    }

    private func commonInit() {
        _accessibility = .AfterFirstUnlock
        useAuthenticationUI = true
    }

    ///string for key
    static func stringForKey(_ key: String?) -> String? {
        var error: Error?
        return self.stringForKey(key, service:nil, accessGroup: nil, error: &error)
    }

    static func stringForKey(_ key: String?, error: inout Error?) -> String? {
        return self.stringForKey(key, service: nil, accessGroup: nil, error: &error)
    }

    static func stringForKey(_ key: String?, service: String?) -> String? {
        var error: Error?
        return self.stringForKey(key, service:service, accessGroup: nil, error: &error)
    }

    static func stringForKey(_ key: String?, service: String?, error: inout Error?) -> String? {
        return self.stringForKey(key, service:service, accessGroup: nil, error: &error)
    }

    static func stringForKey(_ key: String?, service: String?, accessGroup: String?) -> String? {
        var error: Error?
        return self.stringForKey(key, service:service, accessGroup: accessGroup, error: &error)
    }

    static func stringForKey(_ key: String?, service: String?, accessGroup: String?, error: inout Error?) -> String? {
        if key == nil {
            let e: NSError = HKeyChainStore.argumentError("the key must not to be nil")
            if error != nil {
                error = e
            }
            return nil
        }
        var tmpService = service
        if tmpService == nil {
            tmpService = self.defaultService
        }
        
        let keychain: HKeyChainStore = HKeyChainStore.keyChainStoreWithService(tmpService, accessGroup:accessGroup)
        return keychain.stringForKey(key, error:&error)
    }

    ///set string with key
    @discardableResult
    static func setString(value: String?, forKey key: String?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: nil, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, error: inout Error?) -> Bool {
        return self.setString(value, forKey:key, service: nil, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: nil, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        return self.setString(value, forKey:key, service: nil, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: service, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, error: inout Error?) -> Bool {
        return self.setString(value, forKey:key, service: service, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: service, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        return self.setString(value, forKey:key, service: service, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, accessGroup: String?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, accessGroup: String?, error: inout Error?) -> Bool {
        return self.setString(value, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setString(value: String?, forKey key: String?, service: String?, accessGroup: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setString(value, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setString(_ value: String?, forKey key: String?, service: String?, accessGroup: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        if value == nil {
            return self.removeItemForKey(key, service:service, accessGroup: accessGroup, error: &error)
        }
        let data: Data? = value?.data(using: .utf8)
        if data != nil {
            return self.setData(data, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: genericAttribute, error: &error)
        }
        let e: Error? = self.conversionError("failed to convert string to data")
        if error != nil {
            error = e
        }
        return false
    }

    ///data for key
    static func dataForKey(_ key: String?) -> Data? {
        var error: Error?
        return self.dataForKey(key, service:nil, accessGroup: nil, error: &error)
    }

    static func dataForKey(_ key: String?, error: inout Error?) -> Data? {
        return self.dataForKey(key, service:nil, accessGroup: nil, error: &error)
    }

    static func dataForKey(_ key: String?, service: String?) -> Data? {
        var error: Error?
        return self.dataForKey(key, service:service, accessGroup: nil, error: &error)
    }

    static func dataForKey(_ key: String?, service: String?, error: inout Error?) -> Data? {
        return self.dataForKey(key, service:service, accessGroup: nil, error: &error)
    }

    static func dataForKey(_ key: String?, service: String?, accessGroup: String?) -> Data? {
        var error: Error?
        return self.dataForKey(key, service:service, accessGroup: accessGroup, error: &error)
    }

    static func dataForKey(_ key: String?, service: String?, accessGroup: String?, error: inout Error?) -> Data? {
        if key == nil {
            let e: Error = self.argumentError("the key must not to be nil")
            if error != nil {
                error = e
            }
            return nil
        }
        var tmpService = service
        if tmpService == nil {
            tmpService = self.defaultService
        }
        
        let keychain: HKeyChainStore = HKeyChainStore.keyChainStoreWithService(tmpService, accessGroup: accessGroup)
        return keychain.dataForKey(key, error: &error)
    }

    ///set data with key
    @discardableResult
    static func setData(data: Data?, forKey key: String?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: nil, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, service: nil, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: nil, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, service: nil, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: service, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, service: service, accessGroup: nil, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: service, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, service: service, accessGroup: nil, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, accessGroup: String?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, accessGroup: String?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: nil, error: &error)
    }

    @discardableResult
    static func setData(data: Data?, forKey key: String?, service: String?, accessGroup: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, service: service, accessGroup: accessGroup, genericAttribute: genericAttribute, error: &error)
    }

    @discardableResult
    static func setData(_ data: Data?, forKey key: String?, service: String?, accessGroup: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        if key == nil {
        let e: Error? = self.argumentError("the key must not to be nil")
            if error != nil {
                error = e
            }
            return false
        }
        var tmpService = service
        if tmpService == nil {
            tmpService = self.defaultService
        }
        
        let keychain: HKeyChainStore = HKeyChainStore.keyChainStoreWithService(tmpService, accessGroup: accessGroup)
        return keychain.setData(data: data, forKey: key, genericAttribute: genericAttribute)
    }

    private func contains(_ key: String?) -> Bool {
        let query: NSMutableDictionary = self.query
        query[kSecAttrAccount] = key

        let status: OSStatus = SecItemCopyMatching(query, nil)
        return status == errSecSuccess || status == errSecInteractionNotAllowed
    }

    func stringForKey(_ key: String?) -> String? {
        var error: Error?
        return self.stringForKey(key, error: &error)
    }

    func stringForKey(_ key: String?, error: inout Error?) -> String? {
        let data: Data? = self.dataForKey(key, error:&error)
        if data != nil {
            let string: String? = String(data: data!, encoding: .utf8)
            if string != nil {
                return string
            }
            let e: NSError = HKeyChainStore.conversionError("failed to convert data to string")
            if error != nil {
                error = e
            }
        }
        return nil
    }

    ///set string with key
    @discardableResult
    func setString(string: String?, forKey key: String?) -> Bool {
        var error: Error?
        return self.setString(string, forKey:key, genericAttribute: nil, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setString(string: String?, forKey key: String?, error: inout Error?) -> Bool {
        return self.setString(string, forKey:key, genericAttribute: nil, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setString(string: String?, forKey key: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setString(string, forKey:key, genericAttribute: genericAttribute, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setString(string: String?, forKey key: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        return self.setString(string, forKey:key, genericAttribute: genericAttribute, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setString(string: String?, forKey key: String?, label: String?, comment: String?) -> Bool {
        var error: Error?
        return self.setString(string, forKey:key, genericAttribute: nil, label: label, comment: comment, error: &error)
    }

    @discardableResult
    func setString(string: String?, forKey key: String?, label: String?, comment: String?, error: inout Error?) -> Bool {
        return self.setString(string, forKey:key, genericAttribute: nil, label: label, comment: comment, error: &error)
    }

    @discardableResult
    func setString(_ string: String?, forKey key: String?, genericAttribute: AnyObject?, label: String?, comment: String?, error: inout Error?) -> Bool {
        if string == nil {
            return self.removeItemForKey(key, error: &error)
        }
        let data: Data? = string?.data(using: .utf8)
        if data != nil {
            return self.setData(data, forKey:key, genericAttribute: genericAttribute, label: label, comment: comment, error: &error)
        }
        let e: Error = HKeyChainStore.conversionError("failed to convert string to data")
        if error != nil {
            error = e
        }
        return false
    }

    func dataForKey(_ key: String?) -> Data? {
        var error: Error?
        return self.dataForKey(key, error: &error)
    }

    func dataForKey(_ key: String?, error: inout Error?) -> Data? {
        let query: NSMutableDictionary = self.query
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnData] = kCFBooleanTrue
        
        query[kSecAttrAccount] = key
        
        let data: CFTypeRef? = nil
        let status: OSStatus = SecItemCopyMatching(query, data as? UnsafeMutablePointer<CFTypeRef?>)
        
        if status == errSecSuccess {
            let tmpString = data as! String
            let ret: Data? = tmpString.data(using: .utf8)
            if data != nil {
                return ret
            } else {
                let e: Error = HKeyChainStore.unexpectedError("Unexpected error has occurred.")
                if error != nil {
                    error = e
                }
                return nil
            }
        } else if (status == errSecItemNotFound) {
            return nil
        }
        
        let e: Error = HKeyChainStore.securityError(status)
        if error != nil {
            error = e
        }
        return nil
    }

    ///set data with key
    @discardableResult
    func setData(data: Data?, forKey key: String?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, genericAttribute: nil, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setData(data: Data?, forKey key: String?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, genericAttribute: nil, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setData(data: Data?, forKey key: String?, genericAttribute: AnyObject?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, genericAttribute: genericAttribute, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setData(data: Data?, forKey key: String?, genericAttribute: AnyObject?, error: inout Error?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, genericAttribute: genericAttribute, label: nil, comment: nil, error: &error)
    }

    @discardableResult
    func setData(data: Data?, forKey key: String?, label: String?, comment: String?) -> Bool {
        var error: Error?
        return self.setData(data, forKey:key, genericAttribute: nil, label: label, comment: comment, error: &error)
    }

    @discardableResult
    func setData(data: Data?, forKey key: String?, label: String?, comment: String?, error: inout Error?) -> Bool {
        return self.setData(data, forKey:key, genericAttribute: nil, label: label, comment: comment, error: &error)
    }

    @discardableResult
    func setData(_ data: Data?, forKey key: String?, genericAttribute: AnyObject?, label: String?, comment: String?, error: inout Error?) -> Bool {
        if key == nil {
            let e: Error = HKeyChainStore.argumentError("the key must not to be nil")
            if error != nil {
                error = e
            }
            return false
        }
        if data == nil {
            return self.removeItemForKey(key, error:&error)
        }
        
        var query: NSMutableDictionary = self.query
        query[kSecAttrAccount] = key
        if (floor(NSFoundationVersionNumber) > floor(1144.17)) { // iOS 9+
            query[kSecUseAuthenticationUI] = kSecUseAuthenticationUIFail
        }
        
        var status: OSStatus = SecItemCopyMatching(query, nil)
        if (status == errSecSuccess || status == errSecInteractionNotAllowed) {
            query = self.query
            query[kSecAttrAccount] = key
            
            var unexpectedError: NSError?
            let attributes: NSMutableDictionary = self.attributesWithKey(nil, value: data! as NSData, error: &unexpectedError)
            
            if genericAttribute != nil {
                attributes[kSecAttrGeneric] = genericAttribute
            }
            if label != nil {
                attributes[kSecAttrLabel] = label
            }
            if comment != nil {
                attributes[kSecAttrComment] = comment
            }
            
            if unexpectedError != nil {
                NSLog("error: [\(unexpectedError!.code))] @%", "Unexpected error has occurred.")
                if error != nil {
                    error = unexpectedError
                }
                return false
            } else {
                
                if (status == errSecInteractionNotAllowed && floor(NSFoundationVersionNumber) <= floor(1140.11)) { // iOS 8.0.x
                    if (self.removeItemForKey(key, error: &error)) {
                        return self.setData(data: data, forKey:key, label:label, comment:comment, error:&error)
                    }
                } else {
                    status = SecItemUpdate(query, attributes)
                }
                if (status != errSecSuccess) {
                    let e: Error = HKeyChainStore.securityError(status)
                    if error != nil {
                        error = e
                    }
                    return false
                }
            }
        } else if (status == errSecItemNotFound) {
            var unexpectedError: NSError?
            let attributes: NSMutableDictionary = self.attributesWithKey(key, value:data! as NSData, error:&unexpectedError)
            
            if genericAttribute != nil {
                attributes[kSecAttrGeneric] = genericAttribute
            }
            if label != nil {
                attributes[kSecAttrLabel] = label
            }
            if comment != nil {
                attributes[kSecAttrComment] = comment
            }
            
            if unexpectedError != nil {
                NSLog("error: [\(unexpectedError!.code)] @%", "Unexpected error has occurred.")
                if error != nil {
                    error = unexpectedError
                }
                return false
            } else {
                status = SecItemAdd(attributes, nil)
                if (status != errSecSuccess) {
                    let e: Error = HKeyChainStore.securityError(status)
                    if error != nil {
                        error = e
                    }
                    return false
                }
            }
        } else {
            let e: Error = HKeyChainStore.securityError(status)
            if error != nil {
                error = e
            }
            return false
        }
        
        return true
    }

    ///remove item with key
    @discardableResult
    static func removeItemForKey(_ key: String?) -> Bool {
        var error: Error?
        return HKeyChainStore.removeItemForKey(key, service:nil, accessGroup: nil, error: &error)
    }

    @discardableResult
    static func removeItemForKey(_ key: String?, error: inout Error?) -> Bool {
        return HKeyChainStore.removeItemForKey(key, service:nil, accessGroup: nil, error: &error)
    }

    @discardableResult
    static func removeItemForKey(_ key: String?, service: String?) -> Bool {
        var error: Error?
        return HKeyChainStore.removeItemForKey(key, service:service, accessGroup: nil, error: &error)
    }

    @discardableResult
    static func removeItemForKey(_ key: String?, service: String?, error: inout Error?) -> Bool {
        return HKeyChainStore.removeItemForKey(key, service:service, accessGroup: nil, error: &error)
    }

    @discardableResult
    static func removeItemForKey(_ key: String?, service: String?, accessGroup: String?) -> Bool {
        var error: Error?
        return HKeyChainStore.removeItemForKey(key, service:service, accessGroup: accessGroup, error: &error)
    }

    @discardableResult
    static func removeItemForKey(_ key: String?, service: String?, accessGroup: String?, error: inout Error?) -> Bool {
        if key == nil {
            let e: Error = HKeyChainStore.argumentError("the key must not to be nil")
            if error != nil {
                error = e
            }
            return false
        }
        var tmpService = service
        if tmpService == nil {
            tmpService = self.defaultService
        }
        
        let keychain: HKeyChainStore = HKeyChainStore.keyChainStoreWithService(tmpService, accessGroup: accessGroup)
        return keychain.removeItemForKey(key, error: &error)
    }

    ///remove all items with key
    @discardableResult
    static func removeAllItems() -> Bool {
        var error: Error?
        return HKeyChainStore.removeAllItemsForService(nil, accessGroup:nil, error: &error)
    }

    @discardableResult
    static func removeAllItemsWithError(_ error: inout Error?) -> Bool {
        return HKeyChainStore.removeAllItemsForService(nil, accessGroup:nil, error: &error)
    }

    @discardableResult
    static func removeAllItemsForService(_ service: String?) -> Bool {
        var error: Error?
        return HKeyChainStore.removeAllItemsForService(service, accessGroup:nil, error: &error)
    }

    @discardableResult
    static func removeAllItemsForService(_ service: String?, error: inout Error?) -> Bool {
        return HKeyChainStore.removeAllItemsForService(service, accessGroup:nil, error: &error)
    }

    @discardableResult
    static func removeAllItemsForService(_ service: String?, accessGroup: String?) -> Bool {
        var error: Error?
        return HKeyChainStore.removeAllItemsForService(service, accessGroup:accessGroup, error: &error)
    }

    @discardableResult
    static func removeAllItemsForService(_ service: String?, accessGroup: String?, error: inout Error?) -> Bool {
        let keychain: HKeyChainStore = HKeyChainStore.keyChainStoreWithService(service, accessGroup: accessGroup)
        return keychain.removeAllItemsWithError(&error)
    }

    ///instance remove method
    @discardableResult
    func removeItemForKey(_ key: String?) -> Bool {
        var error: Error?
        return self.removeItemForKey(key, error: &error)
    }

    @discardableResult
    func removeItemForKey(_ key: String?, error: inout Error?) -> Bool {
        let query: NSMutableDictionary = self.query
        query[kSecAttrAccount] = key
        
        let status: OSStatus = SecItemDelete(query)
        if (status != errSecSuccess && status != errSecItemNotFound) {
            let e: Error = HKeyChainStore.securityError(status)
            if error != nil {
                error = e
            }
            return false
        }
        return true
    }

    @discardableResult
    func removeAllItems() -> Bool {
        var error: Error?
        return self.removeAllItemsWithError(&error)
    }

    @discardableResult
    private func removeAllItemsWithError(_ error: inout Error?) -> Bool {
        let query: NSMutableDictionary = self.query
    #if !TARGET_OS_IPHONE
        query[kSecMatchLimit] = kSecMatchLimitAll
    #endif
        
        let status: OSStatus = SecItemDelete(query)
        if (status != errSecSuccess && status != errSecItemNotFound) {
            let e: Error = HKeyChainStore.securityError(status)
            if error != nil {
                error = e
            }
            return false
        }
        return true
    }

    func objectForKeyedSubscript(_ key: String) -> String? {
        return self.stringForKey(key)
    }

    func setObject(_ obj: String?, forKeyedSubscript key: String) {
        if obj == nil {
            self.removeItemForKey(key)
        } else {
            self.setString(string: obj, forKey:key)
        }
    }
    
    static func allKeysWithItemClass(_ itemClass: HKeyChainStoreItemClass) -> NSArray {
        var itemClassObject: CFString = kSecClassGenericPassword
        if itemClass == HKeyChainStoreItemClass.genericPassword {
            itemClassObject = kSecClassGenericPassword
        } else if itemClass == HKeyChainStoreItemClass.internetPassword {
            itemClassObject = kSecClassInternetPassword
        }
        
        let query: NSMutableDictionary = NSMutableDictionary()
        query[kSecClass] = itemClassObject
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = kCFBooleanTrue
        
        var result: AnyObject?
        let cfquery: CFDictionary = CFBridgingRetain(query) as! CFDictionary
        
        let status: OSStatus = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(cfquery, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            var array: NSArray?
            if let data = result as! Data? {
                if #available(iOS 11.0, *) {
                    array = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: data) as? NSArray
                } else {
                    array = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray
                }
                if array == nil {
                    return []
                }
            }
            
            let items: NSArray = self.prettify(itemClassObject, items: array!)
            let keys: NSMutableArray = NSMutableArray()
            for tmpItem in items {
                let item = tmpItem as! NSDictionary
                if itemClassObject == kSecClassGenericPassword {
                    keys.add(["service": item["service"] ?? "", "key": item["key"] ?? ""])
                } else if itemClassObject == kSecClassInternetPassword {
                    keys.add(["server": item["service"] ?? "", "key": item["key"] ?? ""])
                }
            }
            return keys
        } else if (status == errSecItemNotFound) {
            return []
        }
        
        return []
    }

    static func allItemsWithItemClass(_ itemClass: HKeyChainStoreItemClass) -> NSArray {
        
        var itemClassObject: CFString = kSecClassGenericPassword
        if itemClass == HKeyChainStoreItemClass.genericPassword {
            itemClassObject = kSecClassGenericPassword
        } else if itemClass == HKeyChainStoreItemClass.internetPassword {
            itemClassObject = kSecClassInternetPassword
        }
        
        let query: NSMutableDictionary = NSMutableDictionary()
        query[kSecClass] = itemClassObject
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = kCFBooleanTrue
        #if TARGET_OS_IPHONE
            query[kSecReturnData] = kCFBooleanTrue
        #endif
        
        var result: AnyObject?
        let cfquery: CFDictionary = CFBridgingRetain(query) as! CFDictionary
        let status: OSStatus = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(cfquery, UnsafeMutablePointer($0)) }
        
        if (status == errSecSuccess) {
            var array: NSArray?
            if let data = result as! Data? {
                if #available(iOS 11.0, *) {
                    array = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: data) as? NSArray
                } else {
                    array = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray
                }
                if array == nil {
                    return []
                }
            }
            return self.prettify(itemClassObject, items: array!)
        } else if (status == errSecItemNotFound) {
            return []
        }
        
        return []
    }

    private var items: NSArray {
        var query: NSMutableDictionary = self.query
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = kCFBooleanTrue
    #if TARGET_OS_IPHONE
        query[kSecReturnData] = kCFBooleanTrue
    #endif
        
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if (status == errSecSuccess) {
            var array: NSArray?
            if let data = result as! Data? {
                if #available(iOS 11.0, *) {
                    array = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: data) as? NSArray
                } else {
                    array = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray
                }
                if array == nil {
                    return []
                }
            }
            return array!
        } else if (status == errSecItemNotFound) {
            return []
        }
        
        return []
    }

    private static func prettify(_ itemClass: CFString, items: NSArray) -> NSArray {
        let prettified: NSMutableArray = NSMutableArray()
        
        for tmpItem in items {
            let attributes = tmpItem as! NSDictionary
            let item: NSMutableDictionary = NSMutableDictionary()
            if itemClass == kSecClassGenericPassword {
                item["class"] = "GenericPassword"
                let service: Any? = attributes[kSecAttrService as String]
                if service != nil {
                    item["service"] = service
                }
                let accessGroup: Any? = attributes[kSecAttrAccessGroup as String]
                if accessGroup != nil {
                    item["accessGroup"] = accessGroup
                }
            } else if itemClass == kSecClassInternetPassword {
                item["class"] = "InternetPassword"
                let service: Any? = attributes[kSecAttrService as String]
                if service != nil {
                    item["service"] = service
                }
                let protocolType: Any? = attributes[kSecAttrProtocol as String]
                if protocolType != nil {
                    item["protocol"] = protocolType
                }
                let authenticationType: Any? = attributes[kSecAttrAuthenticationType as String]
                if authenticationType != nil {
                    item["authenticationType"] = authenticationType
                }
            }
            let key: Any? = attributes[kSecAttrAccount as String]
            if key != nil {
                item["key"] = key
            }
            let data: Data = attributes[kSecValueData as String] as! Data
            let string: String? = String(data: data, encoding: .utf8)
            if string != nil {
                item["value"] = string
            } else {
                item["value"] = data
            }
            
            let accessible: Any? = attributes[kSecAttrAccessible as String]
            if accessible != nil {
                item["accessibility"] = accessible
            }
            
            if (floor(NSFoundationVersionNumber) > floor(993.00)) { // iOS 7+
                let synchronizable: Any? = attributes[kSecAttrSynchronizable as String]
                if synchronizable != nil {
                    item["synchronizable"] = synchronizable
                }
            }
            
            prettified.add(item)
        }
        
        return prettified
    }

    func setAccessibility(_ accessibility: HKeyChainStoreAccessibility, authenticationPolicy: HKeyChainStoreAuthenticationPolicy) {
        _accessibility = accessibility
        _authenticationPolicy = authenticationPolicy
        if (_synchronizable) {
            NSLog("Cannot specify both an authenticationPolicy and a synchronizable")
        }
    }

    func sharedPasswordWithCompletion(_ completion: @escaping (_ account: String?, _ password: String?, _ error: Error?) -> Void) {
        let domain: String = self.server?.host ?? ""
        if domain.length > 0 {
            HKeyChainStore.requestSharedWebCredentialForDomain(domain, nil) { (credentials, error) in
                let credential: NSDictionary? = credentials.firstObject as? NSDictionary
                if credential != nil {
                    let account = credential!["account"] as! String
                    let password = credential!["password"] as! String
                    completion(account, password, error)
                }else {
                    completion(nil, nil, error)
                }
            }
        }else {
            let error: Error = HKeyChainStore.argumentError("the server property must not to be nil, should use 'keyChainStoreWithServer:protocolType:' initializer to instantiate keychain store")
            completion(nil, nil, error)
        }
    }

    func sharedPasswordForAccount(_ account: String?, completion: @escaping (_ password: String?, _ error: Error?) -> Void) {
        let domain: String = self.server?.host ?? ""
        if domain.length > 0 {
            HKeyChainStore.requestSharedWebCredentialForDomain(domain, nil) { (credentials, error) in
                let credential: NSDictionary? = credentials.firstObject as? NSDictionary
                if credential != nil {
                    let password: String = credential!["password"] as! String
                    completion(password, error)
                }else {
                    completion(nil, error)
                }
            }
        } else {
            let error: Error = HKeyChainStore.argumentError("the server property must not to be nil, should use 'keyChainStoreWithServer:protocolType:' initializer to instantiate keychain store")
            completion(nil, error)
        }
    }

    func setSharedPassword(_ password: String?, forAccount account: String?, completion: @escaping (_ error: Error?) -> Void) {
        let domain: String = self.server?.host ?? ""
        if domain.length > 0 {
            SecAddSharedWebCredential(domain as CFString, account! as CFString, password as CFString?) { (error) in
                completion(error)
            }
        } else {
            let error: Error = HKeyChainStore.argumentError("the server property must not to be nil, should use 'keyChainStoreWithServer:protocolType:' initializer to instantiate keychain store")
            completion(error)
        }
    }

    func removeSharedPasswordForAccount(_ account: String?, completion: @escaping (_ error: Error?) -> Void) {
        self.setSharedPassword(nil, forAccount: account, completion: completion)
    }

    static func requestSharedWebCredentialWithCompletion(_ completion: @escaping (_ credentials: NSArray, _ error: Error?) -> Void) {
        self.requestSharedWebCredentialForDomain(nil, nil, completion: completion)
    }

    static func requestSharedWebCredentialForDomain(_ domain: String?, _ account: String?, completion: @escaping (_ credentials: NSArray, _ error: Error?) -> Void) {
        SecRequestSharedWebCredential(domain as CFString?, account as CFString?) { (credentials, error) in
            
            if error != nil && CFErrorGetCode(error) != errSecItemNotFound {
                NSLog("error: [\(CFErrorGetCode(error))] @%", error!.localizedDescription)
            }

            let sharedCredentials = NSMutableArray()
            let tmpCredentials: NSArray = credentials!
            for item in tmpCredentials {
                let credential = item as! NSDictionary
                let sharedCredential = NSMutableDictionary()
                let server: String? = credential[kSecAttrServer as String] as? String
                if server != nil {
                    sharedCredential["server"] = server
                }
                let account: String? = credential[kSecAttrAccount as String] as? String
                if account != nil {
                    sharedCredential["account"] = account
                }
                let password: String? = credential[kSecSharedPassword as String] as? String
                if password != nil {
                    sharedCredential["password"] = password
                }
                sharedCredentials.add(sharedCredential)
            }
            completion(sharedCredentials, error)
        }
    }

    private static var generatePassword: String? {
        return SecCreateSharedWebCredentialPassword() as String?
    }

    private func description() -> String {
        let items: NSArray = self.allItems
        if items.count == 0 {
            return "()"
        }
        let description = NSMutableString(string: "(\n")
        for item in items {
            description.appendFormat("    @%", item as! NSDictionary)
        }
        description.append(")")
        return description as String
    }

    private func debugDescription() -> String {
        return String(format: "@%", self.items)
    }

    private var query: NSMutableDictionary {
        let query = NSMutableDictionary()
        
        let itemClass: CFString = self.itemClassObject
        query[kSecClass] = itemClass
        if (floor(NSFoundationVersionNumber) > floor(993.00)) { // iOS 7+ (NSFoundationVersionNumber_iOS_6_1)
            query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        }
        
        if (itemClass == kSecClassGenericPassword) {
            query[kSecAttrService] = _service
    #if !TARGET_OS_SIMULATOR
            if _accessGroup != nil {
                query[kSecAttrAccessGroup] = _accessGroup
            }
    #endif
        } else {
            if _server?.host != nil {
                query[kSecAttrServer] = _server!.host
            }
            if _server?.port != nil {
                query[kSecAttrPort] = _server!.port
            }
            let protocolTypeObject: CFString? = self.protocolTypeObject
            if protocolTypeObject != nil {
                query[kSecAttrProtocol] = protocolTypeObject
            }
            let authenticationTypeObject: CFString? = self.authenticationTypeObject
            if authenticationTypeObject != nil {
                query[kSecAttrAuthenticationType] = authenticationTypeObject
            }
        }
        
    #if TARGET_OS_IOS
        if (_authenticationPrompt) {
            if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+ (NSFoundationVersionNumber_iOS_7_1)
                query[kSecUseOperationPrompt] = _authenticationPrompt
            } else {
                NSLog("Unavailable 'authenticationPrompt' attribute on iOS versions prior to 8.0.")
            }
        }
    #endif

        if useAuthenticationUI == false {
            if floor(NSFoundationVersionNumber) > floor(1144.17) { // iOS 9+
                query[kSecUseAuthenticationUI] = kSecUseAuthenticationUIFail
            }
        }
        
        return query
    }

    private func attributesWithKey(_ key: String?, value: NSData, error: inout NSError?) -> NSMutableDictionary {
        let attributes: NSMutableDictionary
        
        if key != nil {
            attributes = self.query
            attributes[kSecAttrAccount] = key
        } else {
            attributes = NSMutableDictionary()
        }
        
        attributes[kSecValueData] = value
        
    #if TARGET_OS_IOS
        let iOS_7_1_or_10_9_2 = 1047.25 // NSFoundationVersionNumber_iOS_7_1
    #else
        let iOS_7_1_or_10_9_2 = 1056.13 // NSFoundationVersionNumber10_9_2
    #endif
        let accessibilityObject: CFString? = self.accessibilityObject
        if accessibilityObject != nil {
            if (floor(NSFoundationVersionNumber) > floor(iOS_7_1_or_10_9_2)) { // iOS 8+ or OS X 10.10+
                let securityError: AnyObject? = nil
                let accessControl: SecAccessControl? = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibilityObject!, SecAccessControlCreateFlags(rawValue: CFOptionFlags(authenticationPolicy.rawValue)), securityError as! UnsafeMutablePointer<Unmanaged<CFError>?>?)
                if securityError != nil {
                    let e: NSError? = securityError as? NSError
                    NSLog("error: [\(e?.code ?? 0)] @%", e?.localizedDescription ?? "")
                    if error != nil {
                        error = e
                        return attributes
                    }
                }
                if accessControl == nil {
                    let message: String = "Unexpected error has occurred."
                    let e: NSError = HKeyChainStore.unexpectedError(message)
                    if error != nil {
                        error = e
                    }
                    return attributes
                }
                attributes[kSecAttrAccessControl] = accessControl
            } else {
    #if TARGET_OS_IOS
                NSLog("Unavailable 'Touch ID integration' on iOS versions prior to 8.0.")
    #else
                NSLog("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
    #endif
            }
        } else {
            if (floor(NSFoundationVersionNumber) <= floor(iOS_7_1_or_10_9_2) && _accessibility == HKeyChainStoreAccessibility.WhenPasscodeSetThisDeviceOnly) {
    #if TARGET_OS_IOS
                NSLog("Unavailable 'HKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly' attribute on iOS versions prior to 8.0.")
    #else
                NSLog("Unavailable 'HKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly' attribute on OS X versions prior to 10.10.")
    #endif
            } else {
                if accessibilityObject != nil {
                    attributes[kSecAttrAccessible] = accessibilityObject
                }
            }
        }
        
        if (floor(NSFoundationVersionNumber) > floor(993.00)) { // iOS 7+
            attributes[kSecAttrSynchronizable] = (_synchronizable)
        }
        
        return attributes
    }

    private var itemClassObject: CFString {
        switch (_itemClass) {
        case HKeyChainStoreItemClass.genericPassword:
            return kSecClassGenericPassword
        case HKeyChainStoreItemClass.internetPassword:
            return kSecClassInternetPassword
        }
    }

    private var protocolTypeObject: CFString {
        switch (_protocolType) {
        case HKeyChainStoreProtocolType.FTP:
            return kSecAttrProtocolFTP
        case HKeyChainStoreProtocolType.FTPAccount:
            return kSecAttrProtocolFTPAccount
        case HKeyChainStoreProtocolType.HTTP:
            return kSecAttrProtocolHTTP
        case HKeyChainStoreProtocolType.IRC:
            return kSecAttrProtocolIRC
        case HKeyChainStoreProtocolType.NNTP:
            return kSecAttrProtocolNNTP
        case HKeyChainStoreProtocolType.POP3:
            return kSecAttrProtocolPOP3
        case HKeyChainStoreProtocolType.SMTP:
            return kSecAttrProtocolSMTP
        case HKeyChainStoreProtocolType.SOCKS:
            return kSecAttrProtocolSOCKS
        case HKeyChainStoreProtocolType.IMAP:
            return kSecAttrProtocolIMAP
        case HKeyChainStoreProtocolType.LDAP:
            return kSecAttrProtocolLDAP
        case HKeyChainStoreProtocolType.AppleTalk:
            return kSecAttrProtocolAppleTalk
        case HKeyChainStoreProtocolType.AFP:
            return kSecAttrProtocolAFP
        case HKeyChainStoreProtocolType.Telnet:
            return kSecAttrProtocolTelnet
        case HKeyChainStoreProtocolType.SSH:
            return kSecAttrProtocolSSH
        case HKeyChainStoreProtocolType.FTPS:
            return kSecAttrProtocolFTPS
        case HKeyChainStoreProtocolType.HTTPS:
            return kSecAttrProtocolHTTPS
        case HKeyChainStoreProtocolType.HTTPProxy:
            return kSecAttrProtocolHTTPProxy
        case HKeyChainStoreProtocolType.HTTPSProxy:
            return kSecAttrProtocolHTTPSProxy
        case HKeyChainStoreProtocolType.FTPProxy:
            return kSecAttrProtocolFTPProxy
        case HKeyChainStoreProtocolType.SMB:
            return kSecAttrProtocolSMB
        case HKeyChainStoreProtocolType.RTSP:
            return kSecAttrProtocolRTSP
        case HKeyChainStoreProtocolType.RTSPProxy:
            return kSecAttrProtocolRTSPProxy
        case HKeyChainStoreProtocolType.DAAP:
            return kSecAttrProtocolDAAP
        case HKeyChainStoreProtocolType.EPPC:
            return kSecAttrProtocolEPPC
        case HKeyChainStoreProtocolType.NNTPS:
            return kSecAttrProtocolNNTPS
        case HKeyChainStoreProtocolType.LDAPS:
            return kSecAttrProtocolLDAPS
        case HKeyChainStoreProtocolType.TelnetS:
            return kSecAttrProtocolTelnetS
        case HKeyChainStoreProtocolType.IRCS:
            return kSecAttrProtocolIRCS
        case HKeyChainStoreProtocolType.POP3S:
            return kSecAttrProtocolPOP3S
        }
    }

    private var authenticationTypeObject: CFString {
        switch (_authenticationType) {
        case HKeyChainStoreAuthenticationType.NTLM:
            return kSecAttrAuthenticationTypeNTLM
        case HKeyChainStoreAuthenticationType.MSN:
            return kSecAttrAuthenticationTypeMSN
        case HKeyChainStoreAuthenticationType.DPA:
            return kSecAttrAuthenticationTypeDPA
        case HKeyChainStoreAuthenticationType.RPA:
            return kSecAttrAuthenticationTypeRPA
        case HKeyChainStoreAuthenticationType.HTTPBasic:
            return kSecAttrAuthenticationTypeHTTPBasic
        case HKeyChainStoreAuthenticationType.HTTPDigest:
            return kSecAttrAuthenticationTypeHTTPDigest
        case HKeyChainStoreAuthenticationType.HTMLForm:
            return kSecAttrAuthenticationTypeHTMLForm
        case HKeyChainStoreAuthenticationType.Default:
            return kSecAttrAuthenticationTypeDefault
        }
    }

    private var accessibilityObject: CFString {
        switch (accessibility) {
        case HKeyChainStoreAccessibility.WhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case HKeyChainStoreAccessibility.AfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case HKeyChainStoreAccessibility.Always:
            if #available(iOS 12.0, *) {
                return kSecAttrAccessibleAfterFirstUnlock
            }else {
                return kSecAttrAccessibleAlways
            }
        case HKeyChainStoreAccessibility.WhenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case HKeyChainStoreAccessibility.WhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case HKeyChainStoreAccessibility.AfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case HKeyChainStoreAccessibility.AlwaysThisDeviceOnly:
            if #available(iOS 12.0, *) {
                return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            }else {
                return kSecAttrAccessibleAlwaysThisDeviceOnly
            }
        }
    }

    private static func argumentError(_ message: String) -> NSError {
        let error = NSError(domain: HKeyChainStoreErrorDomain, code: HKeyChainStoreErrorCode.invalidArguments.rawValue, userInfo: [NSLocalizedDescriptionKey: message])
        NSLog("error: [\(error.code)) " + error.localizedDescription)
        return error
    }

    private static func conversionError(_ message: String) -> NSError {
        let error = NSError(domain: HKeyChainStoreErrorDomain, code: -67594, userInfo: [NSLocalizedDescriptionKey: message])
        NSLog("error: [\(error.code)) " + error.localizedDescription)
        return error
    }

    private static func securityError(_ status: OSStatus) -> NSError {
        let message: String? = "Security error has occurred."
    #if TARGET_OS_MAC && !TARGET_OS_IPHONE
        let description: CFStringRef? = SecCopyErrorMessageString(status, NULL)
        if description != nil {
            message = description as? String?
        }
    #endif
        let error = NSError(domain: HKeyChainStoreErrorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey: message ?? ""])
        NSLog("OSStatus error: [\(error.code)) " + error.localizedDescription)
        return error
    }

    private static func unexpectedError(_ message: String?) -> NSError {
        let error = NSError(domain: HKeyChainStoreErrorDomain, code: -99999, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
        NSLog("error: [\(error.code)) " + error.localizedDescription)
        return error
    }

}

extension HKeyChainStore {

    func synchronize() {
        // Deprecated, calling this method is false longer required
    }

    func synchronizeWithError(_ error: inout Error?) -> Bool {
        // Deprecated, calling this method is false longer required
        return true
    }

}
