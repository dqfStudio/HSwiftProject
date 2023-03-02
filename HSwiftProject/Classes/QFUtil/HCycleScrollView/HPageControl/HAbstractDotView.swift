//
//  HAbstractDotView.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

class HAbstractDotView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSException(name: NSExceptionName.internalInconsistencyException,
                    reason: NSString(format: "You must override %@ in %@", NSStringFromSelector(#function), self.className) as String,
                    userInfo: nil).raise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSException(name: NSExceptionName.internalInconsistencyException,
                    reason: NSString(format: "You must override %@ in %@", NSStringFromSelector(#function), self.className) as String,
                    userInfo: nil).raise()
    }
    
    @objc
    func changeActivityState(_ active: Bool) {
        NSException(name: NSExceptionName.internalInconsistencyException,
                    reason: NSString(format: "You must override %@ in %@", NSStringFromSelector(#function), self.className) as String,
                    userInfo: nil).raise()
    }

}
