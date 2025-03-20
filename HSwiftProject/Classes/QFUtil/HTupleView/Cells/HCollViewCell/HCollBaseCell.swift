//
//  HCollBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HCollCellSelectBlock = () -> Void

class HCollBaseCell: UICollectionViewCell {
    
    /// Coll view where the cell is located
    weak var coll: UICollectionView?

    /// IndexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Callback when a cell is clicked
    var willDisplayBlock: HCollCellSelectBlock?
    
    /// Callback when a cell is clicked
    var selectBlock: HCollCellSelectBlock?

    /// Signal callback
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
        self.contentView.addSubview(stackView)
        return stackView
    }()
    
    /// The separator view loaded on the content view
    lazy var separator: UIView = {
        let separator = UIView(frame: self.bounds)
        separator.backgroundColor = UIColor(hex: "#E9E9E9")
        self.contentView.addSubview(separator)
        return separator
    }()
    
    /// Refresh the current cell
    func reloadItemData() {
        guard let indexPath = self.indexPath else { return }
        self.coll?.reloadItems(at: [indexPath])
    }
    
    /// Method called during cell initialization
    func initUI() { }
    
}
