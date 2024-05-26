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
        self.contentView.addSubview(separator)
        return separator
    }()
    
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
