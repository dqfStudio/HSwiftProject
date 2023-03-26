//
//  HDefaultsCore+Extern.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// Extensions must not contain stored properties

extension HDefaultsCore {

    // Check if APP is First Launch
    @NSManaged var isAPPFirstLaunch: Bool
    
    // Check if User is Logged In
    @NSManaged var isUserLogin: Bool
    
}
