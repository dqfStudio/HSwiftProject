//
//  HUserCore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

class HUserCore: UserDefaults {

    private static var mapping = [String: Property]()

    override init?(suiteName suitename: String?) {
        super.init(suiteName: suitename)
        exchangeAccessMethods()
    }
    
    private static func defaultKey(for selector: Selector) -> String {
        let selName = NSStringFromSelector(selector)
        return mapping[selName]!.name
    }
}

/// Exchange access methods
extension HUserCore {

    private func exchangeAccessMethods() {
        let properties = HUserCore.properties

        for property in properties {

            let getterKey = property.name
            let setterKey = objCDefaultSetterName(for: property.name)
            HUserCore.mapping[getterKey] = property
            HUserCore.mapping[setterKey] = property

            let getterSel : Selector = NSSelectorFromString(getterKey)
            let setterSel : Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP!
            var setterImp: IMP!
            switch property.typeEncoding {
            
            case .int, .longLong, .uInt8:
                getterImp = unsafeBitCast(HUserCore.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserCore.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(HUserCore.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserCore.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(HUserCore.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserCore.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(HUserCore.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserCore.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(HUserCore.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(HUserCore.objectSetter, to: IMP.self)
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
extension HUserCore {

    // block
    private static let objectGetter: @convention(c) (HUserCore, Selector) -> Any? = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.object(forKey: key)
    }

    private static let objectSetter: @convention(c) (HUserCore, Selector, Any?) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let boolGetter: @convention(c) (HUserCore, Selector) -> Bool = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.bool(forKey: key)
    }

    private static let boolSetter: @convention(c) (HUserCore, Selector, Bool) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let longGetter: @convention(c) (HUserCore, Selector) -> CLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.integer(forKey: key)
    }

    private static let longSetter: @convention(c) (HUserCore, Selector, CLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let longLongGetter: @convention(c) (HUserCore, Selector) -> CLongLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.integer(forKey: key)
        return CLongLong(value)
    }

    private static let longLongSetter: @convention(c) (HUserCore, Selector, CLongLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(Int(value), forKey: key)
    }

    private static let doubleGetter: @convention(c) (HUserCore, Selector) -> CDouble = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.double(forKey: key)
        return CDouble(value)
    }

    private static let doubleSetter: @convention(c) (HUserCore, Selector, CDouble) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(Double(value), forKey: key)
    }

    private static let floatGetter: @convention(c) (HUserCore, Selector) -> CFloat = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.float(forKey: key)
        return CFloat(value)
    }

    private static let floatSetter: @convention(c) (HUserCore, Selector, CFloat) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }
}
