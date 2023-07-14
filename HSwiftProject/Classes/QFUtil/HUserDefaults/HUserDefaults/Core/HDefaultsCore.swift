//
//  HDefaultsCore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

class HDefaultsCore: UserDefaults {

    private static var mapping = [String: Property]()

    init() {
        super.init(suiteName: nil)!
        exchangeAccessMethods()
    }
    
    private static func defaultKey(for selector: Selector) -> String {
        let selName = NSStringFromSelector(selector)
        return mapping[selName]!.name
    }
}

/// Exchange access methods
extension HDefaultsCore {

    private func exchangeAccessMethods() {
        let properties = HDefaultsCore.properties

        for property in properties {

            let getterKey = property.name
            let setterKey = objCDefaultSetterName(for: property.name)
            HDefaultsCore.mapping[getterKey] = property
            HDefaultsCore.mapping[setterKey] = property

            let getterSel: Selector = NSSelectorFromString(getterKey)
            let setterSel: Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP!
            var setterImp: IMP!
            switch property.typeEncoding {
            
            case .int, .longLong, .uInt8:
                getterImp = unsafeBitCast(HDefaultsCore.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsCore.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(HDefaultsCore.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsCore.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(HDefaultsCore.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsCore.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(HDefaultsCore.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsCore.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(HDefaultsCore.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsCore.objectSetter, to: IMP.self)
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
extension HDefaultsCore {

    // block
    private static let objectGetter: @convention(c) (HDefaultsCore, Selector) -> Any? = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.object(forKey: key)
    }

    private static let objectSetter: @convention(c) (HDefaultsCore, Selector, Any?) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let boolGetter: @convention(c) (HDefaultsCore, Selector) -> Bool = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.bool(forKey: key)
    }

    private static let boolSetter: @convention(c) (HDefaultsCore, Selector, Bool) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let longGetter: @convention(c) (HDefaultsCore, Selector) -> CLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        return _userDefault.integer(forKey: key)
    }

    private static let longSetter: @convention(c) (HDefaultsCore, Selector, CLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }

    private static let longLongGetter: @convention(c) (HDefaultsCore, Selector) -> CLongLong = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.integer(forKey: key)
        return CLongLong(value)
    }

    private static let longLongSetter: @convention(c) (HDefaultsCore, Selector, CLongLong) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(Int(value), forKey: key)
    }

    private static let doubleGetter: @convention(c) (HDefaultsCore, Selector) -> CDouble = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.double(forKey: key)
        return CDouble(value)
    }

    private static let doubleSetter: @convention(c) (HDefaultsCore, Selector, CDouble) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(Double(value), forKey: key)
    }

    private static let floatGetter: @convention(c) (HDefaultsCore, Selector) -> CFloat = { _userDefault, _cmd in
        let key = defaultKey(for: _cmd)
        let value = _userDefault.float(forKey: key)
        return CFloat(value)
    }

    private static let floatSetter: @convention(c) (HDefaultsCore, Selector, CFloat) -> Void = { _userDefault, _cmd, value in
        let key = defaultKey(for: _cmd)
        _userDefault.set(value, forKey: key)
    }
}
