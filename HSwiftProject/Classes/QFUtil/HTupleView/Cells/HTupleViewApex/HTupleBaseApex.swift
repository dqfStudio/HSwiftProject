//
//  HTupleBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleBaseApex: UICollectionReusableView {
    
    /// Tuple view where the cell is located
    weak var tuple: UICollectionView?
    
    /// Whether the cell is a section header
    var isHeader: Bool = false
    
    /// The indexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Signal block
    var signalBlock: HTupleCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator(frame: self.bounds)
        self.addSubview(separator)
        return separator
    }()

    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }

}
