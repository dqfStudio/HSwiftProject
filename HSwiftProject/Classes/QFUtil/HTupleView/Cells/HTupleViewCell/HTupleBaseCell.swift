//
//  HTupleBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTupleCellSelectBlock = () -> Void

class HTupleBaseCell: UICollectionViewCell {
    
    /// Tuple view where the cell is located
    weak var tuple: UICollectionView?

    /// IndexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Callback when a cell is clicked
    var willDisplayBlock: HTupleCellSelectBlock?
    
    /// Callback when a cell is clicked
    var selectBlock: HTupleCellSelectBlock?

    /// Signal callback
    var signalBlock: HTupleCellSignalBlock?
    
    
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
    
    /// 内容边距。只参与子视图布局，不改 cell 自身 frame。
    @objc var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            if edgeInsets != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    /// 扣除 `edgeInsets` 后的排版区域（contentView 坐标系）。
    var layoutViewFrame: CGRect {
        contentView.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        contentView.bounds.inset(by: edgeInsets)
    }
    
    /// Refresh the current cell
    func reloadItemData() {
        guard let indexPath = self.indexPath else { return }
        self.tuple?.reloadItems(at: [indexPath])
    }
    
    func HLayoutTupleCell(_ v: UIView) {
        let frame = contentView.bounds.inset(by: edgeInsets)
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
    }
    
    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }
    
}
