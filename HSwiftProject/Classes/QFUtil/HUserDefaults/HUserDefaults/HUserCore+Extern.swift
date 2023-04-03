//
//  HUserCore+Extern.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// Extensions must not contain stored properties

extension HUserCore {
    
    // Check if User is First Launch
    @NSManaged var isUserFirstLaunch: Bool
    
    // User ID
    @NSManaged var userId: String

}
