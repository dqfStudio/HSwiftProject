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
        self.backgroundColor = .clear
        self.initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.initUI()
    }
    
    /// 内容边距。只参与子视图布局，不改自身 frame。
    @objc var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            if edgeInsets != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    /// 扣除 `edgeInsets` 后的排版区域（自身坐标系）。
    var layoutViewFrame: CGRect {
        bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        bounds.inset(by: edgeInsets)
    }
    
    func HLayoutTupleApex(_ v: UIView) {
        let frame = bounds.inset(by: edgeInsets)
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
