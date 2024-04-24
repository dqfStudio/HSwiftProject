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
    optional func numberOfItemsForBar() -> Int
    
    @objc
    optional func widthForItemAt(_ index: Int) -> CGFloat
    
    @objc
    optional func cellForBar(_ tuple: HTupleView, atIndexPath indexPath: IndexPath)
}

// A custom UIStackView that displays a horizontal list of items with a selected item indicator
class HFlowBar: UIStackView, HTupleViewDelegate {
    
    weak var delegate: HFlowBarDelegate?
    
    // A lazy-loaded HTupleView instance
    private lazy var tupleView: HTupleView = {
        return HTupleView(frame: .zero)
    }()
    
    
    //***********header和footer的间隔************//
    
    var headerSpacing: CGFloat = 0.0 //sectionHeader间隔
    var footerSpacing: CGFloat = 1.0 //sectionFooter间隔
    
    
    //************最左边和最右边的间隔*************//
    
    var leftSpacing: CGFloat = 0.0 //最左边间隔
    var rightSpacing: CGFloat = 0.0 //最右边间隔
    
    
    //**************item之间的间隔**************//
    
    var itemSpacing: CGFloat = 0.0 //item之间的间隔
    
    
    //******************指示器******************//
    
    var indicatorBar = UIView() //指示器
    var showIndicator: Bool = false //是否显示指示器
    var indicatorColor = UIColor.clear //指示器颜色
    var indicatorWidth: CGFloat = 0.0 //指示器宽度
    var indicatorHeight: CGFloat = 0.0 //指示器高度
    
    
    //******************间隔线******************//
    
    var showSeparator: Bool = false //是否显示间隔线
    var separatorColor = UIColor.clear //间隔线颜色
    
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
    
    // 是否可以滚动
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
    
    // 刷新列表
    func reloadData() {
        self.tupleView.reloadTupleData()
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return delegate?.numberOfItemsForBar?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: leftSpacing, bottom: 0, right: rightSpacing)
    }
    
    func sizeForHeaderInSection(_ section: Any) -> Any {
        return CGSize(width: self.width, height: headerSpacing)
    }
    
    func sizeForFooterInSection(_ section: Any) -> Any {
        if showSeparator {
            return CGSize(width: self.width, height: footerSpacing)
        }else {
            return CGSize(width: self.width, height: 0)
        }
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = delegate?.widthForItemAt?(indexPath.row) ?? 1.0
        var height = self.height - headerSpacing
        if showSeparator { height -= footerSpacing }
        return CGSize(width: width, height: height)
    }
    
    func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return itemSpacing
    }
    
    func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        _ = tuple.header(HTupleViewApex.self, nil, false, indexPath)
    }
    
    func tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.footer(HTupleViewApex.self, nil, false, indexPath) as! HTupleViewApex
        let frame = cell.layoutViewBounds
        cell.label.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        cell.label.backgroundColor = separatorColor //分割线颜色
        cell.label.isHidden = !showSeparator //是否显示分割线
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
            var indicatorY = bounds.height - indicatorHeight
            indicatorY += showSeparator ? footerSpacing : 0 //是否显示分割线
            self.indicatorBar.frame = CGRect(x: indicatorX,
                                             y: indicatorY,
                                             width: indicatorWidth,
                                             height: indicatorHeight)
            self.indicatorBar.cornerRadius = indicatorHeight / 2
            self.indicatorBar.backgroundColor = indicatorColor //指示器颜色
            self.indicatorBar.isHidden = !showIndicator //是否显示指示器
        }

        cell.selectBlock = {
            self.selectedIndex = indexPath.row
        }
    }
    
}
