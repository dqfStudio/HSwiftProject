//
//  HFlowBar.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/24.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

@objc protocol HFlowBarDelegate: NSObjectProtocol {
    @objc
    optional func numberOfItemsForBar() -> Any
    
    @objc
    optional func sizeForItemAt(_ index: Int) -> Any
    
    @objc
    optional func cellForBar(_ tuple: HTupleView, atIndexPath indexPath: IndexPath)
    
    @objc
    optional func headerSpacingForBar() -> CGFloat
    
    @objc
    optional func footerSpacingForBar() -> CGFloat
    
    @objc
    optional func leftSpacingForBar() -> CGFloat
    
    @objc
    optional func rightSpacingForBar() -> CGFloat
    
    @objc
    optional func itemSpacingForBar() -> CGFloat
    
    @objc
    optional func indicatorWidthForBar() -> CGFloat
    
    @objc
    optional func indicatorHeightForBar() -> CGFloat
    
    @objc
    optional func indicatorColorForBar() -> UIColor
    
    @objc
    optional func showSeparatorForBar() -> Bool
    
    @objc
    optional func separatorColorForBar() -> UIColor
}

// A custom UIStackView that displays a horizontal list of items with a selected item indicator
class HFlowBar: UIStackView, HTupleViewDelegate {
    
    weak var delegate: HFlowBarDelegate?
    
    // A lazy-loaded HTupleView instance
    private lazy var tupleView: HTupleView = {
        return HTupleView(frame: .zero)
    }()
    
    // Indicator bar
    private lazy var indicatorBar: UIView = {
        return UIView()
    }()
    
    // Indicator bar color
    private var indicatorColor: UIColor {
        return delegate?.indicatorColorForBar?() ?? UIColor.clear
    }
    
    // Indicator bar width
    private var indicatorWidth: CGFloat {
        return delegate?.indicatorWidthForBar?() ?? 0.0
    }
    
    // Indicator bar height
    private var indicatorHeight: CGFloat {
        return delegate?.indicatorHeightForBar?() ?? 0.0
    }
    
    // The index of the currently selected item
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                self.tupleView.reloadTupleData()
                // Scroll item
                let items = self.tupleView.numberOfItems(inSection: 0)
                var row = selectedIndex
                if row >= items { row = items - 1 }
                let indexPath = IndexPath(row: row, section: 0)
                self.tupleView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
        }
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            tupleView.isScrollEnabled = isScrollEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set the stack view properties
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        
        // Set the delegate of the tuple view to self and add it as a subview
        tupleView.delegate = self
        self.addArrangedSubview(tupleView)
        
        // Add indicatorBar background color
        tupleView.addSubview(indicatorBar)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 刷新指示器
    func reloadIndicatorBar(_ index: Int) {
        self.selectedIndex = index
    }
    
    // Returns the number of items in the section
    func numberOfItemsInSection(_ section: Any) -> Any {
        return delegate?.numberOfItemsForBar?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        let left = delegate?.leftSpacingForBar?() ?? 0.0
        let right = delegate?.rightSpacingForBar?() ?? 0.0
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
    }
    
    func sizeForHeaderInSection(_ section: Any) -> Any {
        let height = delegate?.headerSpacingForBar?() ?? 0.0
        return CGSize(width: self.width, height: height)
    }
    
    func sizeForFooterInSection(_ section: Any) -> Any {
        let showSeparator = delegate?.showSeparatorForBar?() ?? false
        if showSeparator {
            return CGSize(width: self.width, height: 0)
        }else {
            let height = delegate?.footerSpacingForBar?() ?? 1.0
            return CGSize(width: self.width, height: height)
        }
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return delegate?.sizeForItemAt?(indexPath.row) ?? CGSize.zero
    }
    
    func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return delegate?.itemSpacingForBar?() ?? 0.0
    }
    
    func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        _ = tuple.header(HTupleViewApex.self, nil, false, indexPath)
    }
    
    func tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.footer(HTupleViewApex.self, nil, false, indexPath) as! HTupleViewApex
        let showSeparator = delegate?.showSeparatorForBar?() ?? false
        let separatorColor = delegate?.separatorColorForBar?() ?? UIColor.clear
        let frame = cell.layoutViewBounds
        cell.label.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        cell.label.backgroundColor = separatorColor
        cell.label.isHidden = showSeparator
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        // cell回调
        delegate?.cellForBar?(tuple, atIndexPath: indexPath)
        
        let cell = tuple.cell(indexPath.row, indexPath.section) as! HTupleBaseCell
        let bounds = cell.layoutViewBounds
        
        // Set the font and color of the title based on whether it is selected or not
        if self.selectedIndex == indexPath.row {
            // Refresh indicatorBar frame
            let indicatorX = cell.x + (bounds.width - indicatorWidth) / 2
            self.indicatorBar.frame = CGRect(x: indicatorX,
                                             y: bounds.height - indicatorHeight + 1,
                                             width: indicatorWidth,
                                             height: indicatorHeight)
            self.indicatorBar.cornerRadius = indicatorHeight / 2
            self.indicatorBar.backgroundColor = indicatorColor
        }

        cell.selectBlock = {
            self.selectedIndex = indexPath.row
        }
    }
    
}
