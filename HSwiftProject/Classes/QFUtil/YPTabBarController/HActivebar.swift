//
//  HActivebar.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/24.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HActivebarNumberBlock = () -> Int
typealias HActivebarSizeBlock = (_ index: Int) -> CGFloat
typealias HActivebarItemBlock = (_ tuple: HTupleView, _ indexPath: IndexPath) -> Void
typealias HActivebarSelectBlock = (_ index: Int) -> Void

class HActivebar: UIStackView, HTupleViewDelegate {
    
    var numberBlock: HActivebarNumberBlock?
    var sizeBlock: HActivebarSizeBlock?
    var itemBlock: HActivebarItemBlock?
    
    var willSelectBlock: HActivebarSelectBlock?
    var didSelectBlock: HActivebarSelectBlock?
    var reSelectBlock: HActivebarSelectBlock?
    
    // 仅供HActiveView内部使用
    var activeViewSelectBlock: HActivebarSelectBlock?
    
    // 垂直或水平方向
    private var direction: HTupleDirection = .horizontal
    
    // A lazy-loaded HTupleView instance
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            return .zero
        } mode: {
            return .delegate
        } exclusiveSections: {
            return []
        } layout: {
            return HTupleViewLayout(self.direction, .manual)
        }
        if self.direction == .vertical {
            tupleView.tupleState = 0
            tupleView.enableVerticalBounce()
        }else {
            tupleView.tupleState = 1
            tupleView.enableHorizontalBounce()
        }
        return tupleView
    }()
    
    
    //***********header和footer的间隔************//
    
    var headerSpacing: CGFloat = 1.0 //section最左边间隔
    var footerSpacing: CGFloat = 1.0 //section最右边间隔
    
    
    //**************item之间的间隔**************//
    
    var itemSpacing: CGFloat = 0.0 //item之间的间隔
    
    
    //******************指示器******************//
    
    // 指示器
    private lazy var indicatorBar: UIView = {
        let frame = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
        let view = UIView(frame: frame)
        view.isHidden = !showIndicator
        return view
    }()
    // 是否显示指示器
    var showIndicator: Bool = false {
        didSet {
            if showIndicator != oldValue {
                indicatorBar.isHidden = !showIndicator
            }
        }
    }
    // 指示器颜色
    var indicatorColor: UIColor = UIColor.clear {
        didSet {
            if indicatorColor != oldValue {
                indicatorBar.backgroundColor = indicatorColor
            }
        }
    }
    // 指示器宽度
    var indicatorWidth: CGFloat = 0.0 {
        didSet {
            if indicatorWidth != oldValue {
                indicatorBar.width = indicatorWidth
            }
        }
    }
    // 指示器高度
    var indicatorHeight: CGFloat = 0.0 {
        didSet {
            if indicatorHeight != oldValue {
                indicatorBar.height = indicatorHeight
                indicatorBar.cornerRadius = indicatorHeight / 2
            }
        }
    }
    
    //******************顶部间隔线******************//
    
    // 顶部间隔线
    lazy var topSeparator: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.width, height: 1)
        let view = UIView(frame: frame)
        view.isHidden = !showTopSeparator
        return view
    }()
    // 是否显示顶部间隔线
    var showTopSeparator: Bool = false {
        didSet {
            if showTopSeparator != oldValue {
                topSeparator.isHidden = !showTopSeparator
            }
        }
    }
    // 顶部间隔线颜色
    var topSeparatorColor: UIColor = UIColor.clear {
        didSet {
            if topSeparatorColor != oldValue {
                topSeparator.backgroundColor = topSeparatorColor
            }
        }
    }
    
    //******************底部间隔线******************//
    
    // 底部间隔线
    lazy var bottomSeparator: UIView = {
        let frame = CGRect(x: 0, y: self.height - 1, width: self.width, height: 1)
        let view = UIView(frame: frame)
        view.isHidden = !showBottomSeparator
        return view
    }()
    // 是否显示底部间隔线
    var showBottomSeparator: Bool = false {
        didSet {
            if showBottomSeparator != oldValue {
                bottomSeparator.isHidden = !showBottomSeparator
            }
        }
    }
    // 底部间隔线颜色
    var bottomSeparatorColor: UIColor = UIColor.clear {
        didSet {
            if bottomSeparatorColor != oldValue {
                bottomSeparator.backgroundColor = bottomSeparatorColor
            }
        }
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
                self.tupleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // 是否可以滚动
    var isScrollEnabled: Bool = true {
        didSet {
            tupleView.isScrollEnabled = isScrollEnabled
        }
    }
    
    init(frame: CGRect, direction: HTupleDirection) {
        super.init(frame: frame)

        // Set the stack view properties
        self.direction = direction
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        // 添加列表
        tupleView.delegate = self
        self.addArrangedSubview(tupleView)
        
        // 顶部间隔线
        if direction == .horizontal {
            self.insertSubview(topSeparator, belowSubview: tupleView)
        }
        
        // 底部间隔线
        if direction == .horizontal {
            self.insertSubview(bottomSeparator, belowSubview: tupleView)
        }
        
        // 指示器
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

}

// vertical
extension HActivebar {

    @objc
    func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    @objc
    func tuple0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: headerSpacing, left: 0, bottom: footerSpacing, right: 0)
    }
    
    @objc
    func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let size = self.sizeBlock?(indexPath.row) ?? 1.0
        return CGSize(width: self.width, height: size)
    }
    
    @objc
    func tuple0_minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return itemSpacing
    }
    
    @objc
    func tuple0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        // cell回调
        self.itemBlock?(tuple, indexPath)
        
        let cell = tuple.cell(indexPath.row, indexPath.section) as! HTupleBaseCell
        let bounds = cell.layoutViewBounds
        
        // Set the font and color of the title based on whether it is selected or not
        if self.selectedIndex == indexPath.row {
            // Refresh indicatorBar frame
            let indicatorX = (bounds.width - indicatorWidth) / 2
            let indicatorY = cell.maxY - indicatorHeight
            self.indicatorBar.frame = CGRect(x: indicatorX,
                                             y: indicatorY,
                                             width: indicatorWidth,
                                             height: indicatorHeight)
        }

        cell.selectBlock = { [weak self]  in
            guard let self = self else { return }
            if self.selectedIndex != indexPath.row {
                self.willSelectBlock?(indexPath.row)
                self.selectedIndex = indexPath.row
                self.didSelectBlock?(indexPath.row)
                self.activeViewSelectBlock?(indexPath.row)
            }else {
                self.reSelectBlock?(indexPath.row)
            }
        }
    }

}

// horizontal
extension HActivebar {

    @objc
    func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    @objc
    func tuple1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: headerSpacing, bottom: 0, right: footerSpacing)
    }
    
    @objc
    func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let size = self.sizeBlock?(indexPath.row) ?? 1.0
        return CGSize(width: size, height: self.height)
    }
    
    @objc
    func tuple1_minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return itemSpacing
    }
    
    @objc
    func tuple1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        // cell回调
        self.itemBlock?(tuple, indexPath)
        
        let cell = tuple.cell(indexPath.row, indexPath.section) as! HTupleBaseCell
        let bounds = cell.layoutViewBounds
        
        // Set the font and color of the title based on whether it is selected or not
        if self.selectedIndex == indexPath.row {
            // Refresh indicatorBar frame
            let indicatorX = cell.midX - indicatorWidth / 2
            let indicatorY = bounds.height - indicatorHeight
            self.indicatorBar.frame = CGRect(x: indicatorX,
                                             y: indicatorY,
                                             width: indicatorWidth,
                                             height: indicatorHeight)
        }

        cell.selectBlock = { [weak self]  in
            guard let self = self else { return }
            if self.selectedIndex != indexPath.row {
                self.willSelectBlock?(indexPath.row)
                self.selectedIndex = indexPath.row
                self.didSelectBlock?(indexPath.row)
                self.activeViewSelectBlock?(indexPath.row)
            }else {
                self.reSelectBlock?(indexPath.row)
            }
        }
    }

}
