//
//  HUserDefaults.swift
//  HUserDefaults
//
//  Created by wind on 2019/3/24.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation


class HUserDefaults: NSObject {

    fileprivate static let standard = HUserDefaults()

    private let userDefaults = UserDefaults.standard

    private static var mapping = [String: Property]()

    init(placeHolder nan: Bool? = nil) {
        super.init()
        exchangeAccessMethods()
    }
    
    private static func defaultKey(for selector: Selector) -> String {
        let selName = NSStringFromSelector(selector)
        return mapping[selName]!.name
    }
}

/// Exchange access methods
extension HUserDefaults {

    private func exchangeAccessMethods() {
        let properties = HUserDefaults.properties

        for property in properties {

            let getterKey = property.name
            let setterKey = objCDefaultSetterName(for: property.name)
            HUserDefaults.mapping[getterKey] = property
            HUserDefaults.mapping[setterKey] = property

            let getterSel : Selector = NSSelectorFromString(getterKey)
            let setterSel : Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP!
            var setterImp: IMP!
            switch property.typeEncoding {
            
            case .int, .longLong, .uInt8:
                getterImp = unsafeBitCast(HUserDefaults.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(HUserDefaults.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(HUserDefaults.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(HUserDefaults.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(HUserDefaults.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults.objectSetter, to: IMP.self)
            default:
                NSException(name:NSExceptionName(rawValue: "exchange Access Methods"), reason:"Unsupported type of property", userInfo:nil).raise()
            }

            let setterTypes = "v@:\(property.typeEncoding)"
            let getterTypes = "\(property.typeEncoding)@:"

            setterTypes.withCString { typesCString in
                _ = class_addMethod(classForCoder, setterSel, setterImp, typesCString)
            }

            getterTypes.withCString { typesCString in
                _ = class_addMethod(classForCoder, getterSel, getterImp, typesCString)
            }
        }
    }

    private func objCDefaultSetterName(for propertyName: String) -> String {
        let head = propertyName.uppercased().first!
        let tail = propertyName[propertyName.index(after: propertyName.startIndex)...]
        return "set\(head)\(tail):"
    }
}

/// Getter and Setter Methods
extension HUserDefaults {

    // block
    private static let objectGetter: @convention(c) (HUserDefaults, Selector) -> Any? = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.object(forKey: key)
    }

    private static let objectSetter: @convention(c) (HUserDefaults, Selector, Any?) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let boolGetter: @convention(c) (HUserDefaults, Selector) -> Bool = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.bool(forKey: key)
    }

    private static let boolSetter: @convention(c) (HUserDefaults, Selector, Bool) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longGetter: @convention(c) (HUserDefaults, Selector) -> CLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.integer(forKey: key)
    }

    private static let longSetter: @convention(c) (HUserDefaults, Selector, CLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longLongGetter: @convention(c) (HUserDefaults, Selector) -> CLongLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.integer(forKey: key)
        return CLongLong(value)
    }

    private static let longLongSetter: @convention(c) (HUserDefaults, Selector, CLongLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(Int(value), forKey: key)
    }

    private static let doubleGetter: @convention(c) (HUserDefaults, Selector) -> CDouble = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.double(forKey: key)
        return CDouble(value)
    }

    private static let doubleSetter: @convention(c) (HUserDefaults, Selector, CDouble) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(Double(value), forKey: key)
    }

    private static let floatGetter: @convention(c) (HUserDefaults, Selector) -> CFloat = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.float(forKey: key)
        return CFloat(value)
    }

    private static let floatSetter: @convention(c) (HUserDefaults, Selector, CFloat) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }
}


extension UserDefaults {
    static var std: HUserDefaults {
        return HUserDefaults.standard
    }
}
