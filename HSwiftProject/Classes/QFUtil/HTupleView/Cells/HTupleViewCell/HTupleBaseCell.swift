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
    
    /// Refresh the current cell
    func reloadItemData() {
        guard let indexPath = self.indexPath else { return }
        self.tuple?.reloadItems(at: [indexPath])
    }
    
    /// 重写以下属性以启用自动大小计算
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        if let flowLayout = self.tuple?.collectionViewLayout as? UICollectionViewFlowLayout,
//            flowLayout.estimatedItemSize != CGSize.zero {
//            let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: UIView.layoutFittingCompressedSize.width)
//            let contentSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
//            preferredAttributes.frame.size = contentSize
//        }
//        return preferredAttributes
//    }
    
    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }
    
}
