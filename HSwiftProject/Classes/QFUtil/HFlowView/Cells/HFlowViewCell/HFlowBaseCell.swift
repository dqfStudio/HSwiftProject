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
    
    // 指定的宽度
    var fixedWidth = 0.0
    
    // 指定的高度
    var fixedHeight = 0.0

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
        let separator = HCellApexSeparator(frame: self.bounds)
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
            
            var contentSize = CGSize.zero
            if fixedWidth > 0, fixedHeight > 0 {
                contentSize = CGSize(width: fixedWidth, height: fixedHeight)
            }else if fixedWidth > 0 {
                let targetSize = CGSize(width: fixedWidth, height: UIView.layoutFittingCompressedSize.height)
                contentSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            }else if fixedHeight > 0 {
                let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: fixedHeight)
                contentSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
            }
            preferredAttributes.frame.size = contentSize
        }
        
        return preferredAttributes
    }
    
}
