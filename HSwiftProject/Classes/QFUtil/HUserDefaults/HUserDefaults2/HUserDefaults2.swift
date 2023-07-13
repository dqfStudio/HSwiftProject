//
//  HUserDefaults2.swift
//  HUserDefaults2
//
//  Created by Wind on 2019/3/24.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation


class HUserDefaults2: NSObject {

    fileprivate static let standard = HUserDefaults2()

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
extension HUserDefaults2 {

    private func exchangeAccessMethods() {
        let properties = HUserDefaults2.properties

        for property in properties {

            let getterKey = property.name
            let setterKey = objCDefaultSetterName(for: property.name)
            HUserDefaults2.mapping[getterKey] = property
            HUserDefaults2.mapping[setterKey] = property

            let getterSel : Selector = NSSelectorFromString(getterKey)
            let setterSel : Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP!
            var setterImp: IMP!
            switch property.typeEncoding {
            
            case .int, .longLong, .uInt8:
                getterImp = unsafeBitCast(HUserDefaults2.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults2.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(HUserDefaults2.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults2.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(HUserDefaults2.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults2.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(HUserDefaults2.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults2.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(HUserDefaults2.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserDefaults2.objectSetter, to: IMP.self)
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
extension HUserDefaults2 {

    // block
    private static let objectGetter: @convention(c) (HUserDefaults2, Selector) -> Any? = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.object(forKey: key)
    }

    private static let objectSetter: @convention(c) (HUserDefaults2, Selector, Any?) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let boolGetter: @convention(c) (HUserDefaults2, Selector) -> Bool = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.bool(forKey: key)
    }

    private static let boolSetter: @convention(c) (HUserDefaults2, Selector, Bool) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longGetter: @convention(c) (HUserDefaults2, Selector) -> CLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.userDefaults.integer(forKey: key)
    }

    private static let longSetter: @convention(c) (HUserDefaults2, Selector, CLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longLongGetter: @convention(c) (HUserDefaults2, Selector) -> CLongLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.integer(forKey: key)
        return CLongLong(value)
    }

    private static let longLongSetter: @convention(c) (HUserDefaults2, Selector, CLongLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(Int(value), forKey: key)
    }

    private static let doubleGetter: @convention(c) (HUserDefaults2, Selector) -> CDouble = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.double(forKey: key)
        return CDouble(value)
    }

    private static let doubleSetter: @convention(c) (HUserDefaults2, Selector, CDouble) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(Double(value), forKey: key)
    }

    private static let floatGetter: @convention(c) (HUserDefaults2, Selector) -> CFloat = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.userDefaults.float(forKey: key)
        return CFloat(value)
    }

    private static let floatSetter: @convention(c) (HUserDefaults2, Selector, CFloat) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }
}


//extension UserDefaults {
//    static var std: HUserDefaults2 {
//        return HUserDefaults2.standard
//    }
//}
