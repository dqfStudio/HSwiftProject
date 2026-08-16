//
//  HCollBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HCollBaseApex: UICollectionReusableView {
    
    /// Coll view where the cell is located
    weak var coll: UICollectionView?
    
    /// Whether the cell is a section header
    var isHeader: Bool = false
    
    /// The indexPath where the cell is located
    var indexPath: IndexPath?

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.initUI()
    }
    
    /// The edge insets of the cell.
    @objc override var edgeInsets: UIEdgeInsets {
        get {
            let edgeInsetsString = self.getAssociatedValueForKey(&kViewEdgeInsetsKey) as? String ?? NSCoder.string(for: UIEdgeInsets.zero)
            return NSCoder.uiEdgeInsets(for: edgeInsetsString)
        }
        set {
            if edgeInsets != newValue {
                self.setAssociateValue(NSCoder.string(for: newValue), key: &kViewEdgeInsetsKey)
            }
        }
    }
    
    /// The frame and bounds of layoutView
    var layoutViewFrame: CGRect {
        return self.frame
    }

    var layoutViewBounds: CGRect {
        return self.bounds
    }
    
    func HLayoutCollApex(_ v: UIView) {
        if !v.frame.equalTo(self.bounds) {
            v.frame = self.bounds
        }
    }

    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }

}
