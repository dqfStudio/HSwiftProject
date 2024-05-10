//
//  HFlowBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HFlowBaseApex: UICollectionReusableView {
    
    /// Flow view where the cell is located
    weak var flow: UICollectionView?
    
    /// Whether the cell is a section header
    var isHeader: Bool = false
    
    /// The indexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Signal block
    var signalBlock: HFlowCellSignalBlock?

    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator()
        self.addSubview(separator)
        return separator
    }()

}
