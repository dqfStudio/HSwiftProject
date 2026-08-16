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
    
    /// Callback when a cell is displayed
    var willDisplayBlock: HCollCellSelectBlock?
    
    /// Callback when a cell is clicked
    var selectBlock: HCollCellSelectBlock?

    /// 当前 cell 中用到的图片 URL 列表，设置后框架会自动预取其尺寸
    /// 业务方在配置 cell 时设置此属性，框架在 willDisplay 时自动预取
    var prefetchImageURLs: [String] = []

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
    
    /// The frame and bounds of layoutView
    var layoutViewFrame: CGRect {
        return self.contentView.frame
    }

    var layoutViewBounds: CGRect {
        return self.contentView.bounds
    }
    
    /// Refresh the current cell
    func reloadItemData() {
        guard let indexPath = self.indexPath else { return }
        self.coll?.reloadItems(at: [indexPath])
    }
    
    func HLayoutCollCell(_ v: UIView) {
        if !v.frame.equalTo(self.bounds) {
            v.frame = self.bounds
        }
    }
    
    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }
    
    // MARK: - Self-sizing Support
    
    /// 当 layout 使用 estimatedItemSize 时，系统调用此方法获取 cell 的真实尺寸
    /// cell 子类如果使用 Auto Layout / SnapKit 布局，重写此方法让系统自动算高度
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // 让 cell 根据约束自动计算尺寸
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        // 用 systemLayoutSizeFitting 计算真实高度
        // 宽度保持 layoutAttributes 中的值（由 layout 决定），高度自适应
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let actualSize = self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,  // 宽度必须
            verticalFittingPriority: .fittingSizeLevel  // 高度自适应
        )
        
        var frame = layoutAttributes.frame
        frame.size.height = max(actualSize.height, 1)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
    
}
