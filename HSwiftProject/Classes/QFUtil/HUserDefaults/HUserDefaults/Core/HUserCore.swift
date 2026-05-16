//
//  HUserCore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// MARK: - HUserCore
//
// Stores settings that belong to a specific logged-in user.
// Each user gets an isolated UserDefaults suite (suiteName = userId),
// so switching accounts never leaks data between users.
//
// Add new fields in HUserCore+Extern.swift:
//   extension HUserCore {
//       @NSManaged var token: String
//   }
//
// Access via HUserDefaults.user:
//   HUserDefaults.user.token = "abc123"

final class HUserCore: HDefaultsBase {

    // MARK: - Per-subclass static storage
    // These override the base-class class-vars so HUserCore gets its own
    // isolated mapping/lock/hasExchanged, separate from HDefaultsCore.
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
    /// Creates a user-scoped defaults instance.
    /// - Parameter suiteName: Unique identifier for this user's storage domain.
    ///   Pass the logged-in userId so each account gets isolated storage.
    ///   Falls back to a shared suite name if suiteName is nil.
    init(userSuiteName suiteName: String) {
        super.init(suiteName: suiteName)!
    }
}
