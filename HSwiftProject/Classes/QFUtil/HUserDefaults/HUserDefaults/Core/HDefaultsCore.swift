//
//  HDefaultsCore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// MARK: - HDefaultsCore
//
// Stores app-wide settings that are independent of the logged-in user.
// Backed by UserDefaults.standard (suiteName: nil).
//
// Add new fields in HDefaultsCore+Extern.swift:
//   extension HDefaultsCore {
//       @NSManaged var appTheme: String
//   }
//
// Access via HUserDefaults.defaults:
//   HUserDefaults.defaults.isUserLogin = true

final class HDefaultsCore: HDefaultsBase {

    // MARK: - Per-subclass static storage
    // These override the base-class class-vars so HDefaultsCore gets its own
    // isolated mapping/lock/hasExchanged, separate from HUserCore.
    private static let _lock         = NSLock()
    private static var _mapping      = [String: Property]()
    private static var _hasExchanged = false

    override class var sharedLock: NSLock { _lock }
    override class var sharedMapping: [String: Property] {
        get { _mapping }
        set { _mapping = newValue }
    }
    override class var sharedHasExchanged: Bool {
        get { _hasExchanged }
        set { _hasExchanged = newValue }
    }

    // MARK: - Init
    init() {
        // suiteName: nil → UserDefaults.standard domain
        super.init(suiteName: nil)!
    }
}
