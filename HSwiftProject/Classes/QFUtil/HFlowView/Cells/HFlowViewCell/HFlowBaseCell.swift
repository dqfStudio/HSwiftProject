//
//  HFlowBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HFlowCellSelectBlock = () -> Void

class HFlowBaseCell: UICollectionViewCell {
    
    /// Flow view where the cell is located
    weak var flow: UICollectionView?

    /// IndexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Callback when a cell is clicked
    var willDisplayBlock: HFlowCellSelectBlock?
    
    /// Callback when a cell is clicked
    var selectBlock: HFlowCellSelectBlock?

    /// Signal callback
    var signalBlock: HFlowCellSignalBlock?

    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator()
        self.contentView.addSubview(separator)
        return separator
    }()
    
    /// Refresh the current cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.flow?.reloadItems(at: [indexPath])
    }
    
    /// 重写以下属性以启用自动大小计算
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        if let flowLayout = self.flow?.collectionViewLayout as? UICollectionViewFlowLayout,
            flowLayout.estimatedItemSize != CGSize.zero {
            let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: UIView.layoutFittingCompressedSize.width)
            let contentSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
            preferredAttributes.frame.size = contentSize
        }
        return preferredAttributes
    }
    
}
