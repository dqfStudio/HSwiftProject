//
//  HDefaultsBase.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation
import ObjectiveC

/// Objective-C type encoding
enum ObjCTypeEncoding {
    case int
    case longLong
    case float
    
    case double
    case bool
    case char
    
    case object
    case uInt8
    case unknown(String)

    init(e encoding: String) {
        switch encoding {
        case "i": self = .int
        case "q": self = .longLong
        case "f": self = .float
        case "d": self = .double
        case "B": self = .bool
        case "c": self = .char
        case "C": self = .uInt8
        case "@": self = .object   // string
        default:
            self = .unknown(encoding)
        }
    }
}

struct Property {

    let name: String

    private(set) var typeEncoding = ObjCTypeEncoding.unknown("?")

    init(x property: objc_property_t) {
        name = String(cString: property_getName(property))

        var count: UInt32 = 0
        // Safe: property_copyAttributeList returns nil only when count==0; guard prevents force-unwrap crash.
        guard let attributeList = property_copyAttributeList(property, &count) else { return }

        for i in 0..<Int(count) {
            let attribute = attributeList[i]

            let nick = String(cString: attribute.name)
            let value = String(cString: attribute.value)

            switch nick {
            case "T":
                var value = value
                if value.hasPrefix("@\"") && value.hasSuffix("\"") { // id
                    value = value
                        .replacingOccurrences(of: "@\"", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                } else if value.hasPrefix("r") { // const
                    value = value.replacingOccurrences(of: "r", with: "")
                }

                typeEncoding = value.classExists
                    ? ObjCTypeEncoding(e: "@")  // object types: String, Data, Array, ...
                    : ObjCTypeEncoding(e: value) // scalar types: Bool, Int, Float, Double
            default: break
            }
        }

        free(attributeList)
    }
}

extension String {

    var classExists: Bool {
        guard let cStr = cString(using: .utf8) else { return false }
        return objc_getClass(cStr) != nil
    }

    var getClass: NSObject.Type? {
        guard let cStr = cString(using: .utf8) else { return nil }
        return objc_getClass(cStr) as? NSObject.Type
    }
}

extension ObjCTypeEncoding: CustomStringConvertible {
    /// Returns the raw ObjC type encoding character used for class_addMethod type signatures.
    var description: String {
        switch self {
        case .int:            return "i"
        case .longLong:       return "q"
        case .float:          return "f"
        case .double:         return "d"
        case .bool:           return "B"
        case .char:           return "c"
        case .uInt8:          return "C"
        case .object:         return "@"
        case .unknown(let s): return s
        }
    }
}

// MARK: - HDefaultsBase
//
// Abstract base class shared by HDefaultsCore and HUserCore.
// Implements the ObjC Runtime dynamic property injection mechanism so each
// concrete subclass only needs to:
//   1. Call super.init / super.init(suiteName:)
//   2. Declare @NSManaged properties in its own +Extern extension file
//
// How it works:
//   • On first init, scans all @NSManaged properties via class_copyPropertyList.
//   • Dynamically adds getter/setter IMPs via class_addMethod, mapping each
//     property name to the corresponding UserDefaults key (no hardcoded strings).
//   • hasExchanged guard ensures the scan runs only once per concrete subclass,
//     even when multiple instances are created (e.g. on user switch).
//   • NSLock protects the static mapping dict and hasExchanged flag from data
//     races when accessed from multiple threads simultaneously.

class HDefaultsBase: UserDefaults {

    // MARK: - Static State (per concrete subclass)

    /// Per-subclass selector→Property lookup table.
    /// Must be overridden as a distinct variable in each subclass — achieved via
    /// the concrete subclass's own static storage (see HDefaultsCore / HUserCore).
    /// Here we store it on the metatype so Swift dispatches correctly.
    private static let _lock = NSLock()          // let: NSLock never needs replacing
    private static var _mapping = [String: Property]()
    private static var _hasExchanged = false

    // Each concrete subclass overrides these accessors to point to its own storage.
    class var sharedLock: NSLock { _lock }
    class var sharedMapping: [String: Property] {
        get { _mapping }
        set { _mapping = newValue }
    }
    class var sharedHasExchanged: Bool {
        get { _hasExchanged }
        set { _hasExchanged = newValue }
    }

    // MARK: - Init

    override init?(suiteName suitename: String?) {
        super.init(suiteName: suitename)
        exchangeAccessMethods()
    }

    // MARK: - Key Resolution

    /// Returns the UserDefaults key for a given ObjC selector, or the selector
    /// name itself as a safe fallback (with a debug assertion in DEBUG builds).
    /// Must be called on the concrete metatype (type(of: instance)) to hit the
    /// correct subclass mapping — never call HDefaultsBase.defaultKey directly.
    static func defaultKey(for selector: Selector) -> String {
        let selName = NSStringFromSelector(selector)
        sharedLock.lock(); defer { sharedLock.unlock() }
        guard let property = sharedMapping[selName] else {
            assertionFailure(
                "\(Self.self): unregistered selector '\(selName)'. " +
                "Make sure it is declared with @NSManaged in a \(Self.self) extension."
            )
            return selName
        }
        return property.name
    }
}

// MARK: - Properties
extension HDefaultsBase {
    
    static var properties: [Property] {
        var count: UInt32 = 0
        guard let propertyList = class_copyPropertyList(self, &count) else { return [] }

        var properties = [Property]()
        let cnt = Int(count)
        for i in 0..<cnt {
            properties.append(Property(x: propertyList[i]))
        }
        free(propertyList)
        return properties
    }
}

// MARK: - Method Registration
extension HDefaultsBase {

    private func exchangeAccessMethods() {
        let cls = type(of: self)

        // Lock → check → set flag → unlock  (double-checked locking pattern)
        cls.sharedLock.lock()
        guard !cls.sharedHasExchanged else {
            cls.sharedLock.unlock()
            return
        }
        cls.sharedHasExchanged = true
        cls.sharedLock.unlock()

        for property in cls.properties {
            let getterKey = property.name
            let setterKey = HDefaultsBase.objCSetterName(for: property.name)

            cls.sharedLock.lock()
            cls.sharedMapping[getterKey] = property
            cls.sharedMapping[setterKey] = property
            cls.sharedLock.unlock()

            let getterSel: Selector = NSSelectorFromString(getterKey)
            let setterSel: Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP
            var setterImp: IMP

            switch property.typeEncoding {
            case .int, .longLong, .uInt8:
                getterImp = unsafeBitCast(HDefaultsBase.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsBase.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(HDefaultsBase.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsBase.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(HDefaultsBase.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsBase.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(HDefaultsBase.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsBase.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(HDefaultsBase.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(HDefaultsBase.objectSetter, to: IMP.self)
            default:
                assertionFailure(
                    "\(cls): unsupported type encoding '\(property.typeEncoding)' " +
                    "for property '\(property.name)'"
                )
                continue
            }

            let setterTypes = "v@:\(property.typeEncoding)"
            let getterTypes = "\(property.typeEncoding)@:"

            setterTypes.withCString { _ = class_addMethod(classForCoder, setterSel, setterImp, $0) }
            getterTypes.withCString { _ = class_addMethod(classForCoder, getterSel, getterImp, $0) }
        }
    }

    /// Derives the ObjC setter name from a property name, e.g. "token" → "setToken:".
    /// Static because it doesn't depend on instance state.
    private static func objCSetterName(for propertyName: String) -> String {
        guard let first = propertyName.first else { return "set:" }
        let tail = propertyName.dropFirst()
        return "set\(first.uppercased())\(tail):"
    }
}

// MARK: - IMP Closures (C-convention, type-dispatched)
// IMPORTANT: Each closure resolves the key via `type(of: self_).defaultKey(for: cmd)`
// so that Swift's class-level dispatch hits the correct subclass mapping
// (HDefaultsCore.mapping or HUserCore.mapping), not the base-class mapping.
extension HDefaultsBase {

    static let objectGetter: @convention(c) (HDefaultsBase, Selector) -> Any? = { self_, cmd in
        self_.object(forKey: type(of: self_).defaultKey(for: cmd))
    }
    static let objectSetter: @convention(c) (HDefaultsBase, Selector, Any?) -> Void = { self_, cmd, val in
        self_.set(val, forKey: type(of: self_).defaultKey(for: cmd))
    }

    static let boolGetter: @convention(c) (HDefaultsBase, Selector) -> Bool = { self_, cmd in
        self_.bool(forKey: type(of: self_).defaultKey(for: cmd))
    }
    static let boolSetter: @convention(c) (HDefaultsBase, Selector, Bool) -> Void = { self_, cmd, val in
        self_.set(val, forKey: type(of: self_).defaultKey(for: cmd))
    }

    static let longGetter: @convention(c) (HDefaultsBase, Selector) -> CLong = { self_, cmd in
        self_.integer(forKey: type(of: self_).defaultKey(for: cmd))
    }
    static let longSetter: @convention(c) (HDefaultsBase, Selector, CLong) -> Void = { self_, cmd, val in
        self_.set(val, forKey: type(of: self_).defaultKey(for: cmd))
    }

    static let doubleGetter: @convention(c) (HDefaultsBase, Selector) -> CDouble = { self_, cmd in
        CDouble(self_.double(forKey: type(of: self_).defaultKey(for: cmd)))
    }
    static let doubleSetter: @convention(c) (HDefaultsBase, Selector, CDouble) -> Void = { self_, cmd, val in
        self_.set(Double(val), forKey: type(of: self_).defaultKey(for: cmd))
    }

    static let floatGetter: @convention(c) (HDefaultsBase, Selector) -> CFloat = { self_, cmd in
        CFloat(self_.float(forKey: type(of: self_).defaultKey(for: cmd)))
    }
    static let floatSetter: @convention(c) (HDefaultsBase, Selector, CFloat) -> Void = { self_, cmd, val in
        self_.set(val, forKey: type(of: self_).defaultKey(for: cmd))
    }
}
