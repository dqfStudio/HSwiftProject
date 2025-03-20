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
    
    /// Signal block
    var signalBlock: HCollCellSignalBlock?
    
    
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
    
    /// The layout view loaded on the content view
    lazy var layoutView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.addSubview(stackView)
        return stackView
    }()
    
    /// The separator view loaded on the content view
    lazy var separator: UIView = {
        let separator = UIView(frame: self.bounds)
        separator.backgroundColor = UIColor(hex: "#E9E9E9")
        self.addSubview(separator)
        return separator
    }()

    /// Method called during cell initialization
    func initUI() { }

}
