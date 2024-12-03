//
//  HActiveView.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/25.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

enum HActiveScrollDirection {
    case left
    case right
}

typealias HActiveScrollBlock = (_ direction: HActiveScrollDirection) -> Void

class HActiveView: UIStackView, HTupleViewDelegate {
    
    private var selectedIndexs: [Int] = []
    // 滚动回调
    var scrollBlock: HActiveScrollBlock?
    // 记录滚动偏移量
    var previousCntOffset = CGPoint.zero
    // 滚动阈值
    var scrollThreshold: CGFloat = 10.0
    
    weak var activeBar: HActivebar? {
        didSet {
            if let activeBar = activeBar, activeBar != oldValue {
                // activeBar点击回调
                activeBar.activeViewSelectBlock = { [weak self] index in
                    guard let self = self else { return }
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tupleView.scrollToItem(at: indexPath, at: .right, animated: false)
                }
            }
        }
    }
    
    // 是否可以滚动
    var isScrollEnabled: Bool = true {
        didSet {
            tupleView.isScrollEnabled = isScrollEnabled
        }
    }
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            oldValue.forEach { vc in
                vc.removeFromParent()
                if vc.isViewLoaded {
                    vc.view.removeFromSuperview()
                }
            }
            self.tupleView.reloadTupleData()
        }
    }
    
    // 获取被选中的ViewController
    var selectedController: UIViewController? {
        let count = self.viewControllers.count
        let selectedIndex = self.activeBar?.selectedIndex ?? 0
        if selectedIndex >= 0, selectedIndex < count {
            return viewControllers[selectedIndex]
        }
        return nil
    }
    
    // A lazy-loaded HTupleView instance
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.tupleFrame {
            return .zero
        } mode: {
            return .delegate
        } layout: {
            return HTupleViewLayout(.horizontal, .manual)
        }
        tupleView.enableHorizontalBounce()
        return tupleView
    }()
        
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        // Set the stack view properties
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        // 添加列表
        tupleView.delegate = self
        tupleView.isPagingEnabled = true
        tupleView.isScrollEnabled = isScrollEnabled
        self.addArrangedSubview(tupleView)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // 添加子vc
        viewControllers.forEach { vc in
            self.containerViewController?.addChild(vc)
        }
    }

    private var containerViewController: UIViewController? {
        var view: UIView? = self
        while let currentView = view {
            if let nextResponder = currentView.next as? UIViewController {
                return nextResponder
            }
            view = currentView.superview
        }
        return nil
    }
}

extension HActiveView {
    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.viewControllers.count
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return self.tupleView.size
    }
    func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        self.activeBar?.selectedIndex = indexPath.row
        // 添加view
        let vc = self.viewControllers[indexPath.row]
        vc.view.frame = cell.layoutViewBounds
        if vc.view.superview == nil {
            cell.contentView.addSubview(vc.view)
            // 记录是否被选中过
            self.selectedIndexs.append(indexPath.row)
        }
        // 重建生命周期
        if self.selectedIndexs.count > 1 {
            self.viewControllers.enumerated().forEach { (index, vc) in
                // 只有被选中过的才需要重建生命周期
                if self.selectedIndexs.contains(index) {
                    if indexPath.row == index {
                        vc.viewWillAppear(true)
                        vc.viewDidAppear(true)
                    } else {
                        vc.viewWillDisappear(true)
                        vc.viewDidDisappear(true)
                    }
                }
            }
        }
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        _ = tuple.reuseCell(HTupleBaseCell.self, nil, true, indexPath)
    }
    func tupleViewDidScroll(_ scrollView: UIScrollView) {
        let currentCntOffset = scrollView.contentOffset
        if currentCntOffset.x < previousCntOffset.x { //向左滑
            let lastIndex = self.viewControllers.count - 1
            if self.activeBar?.selectedIndex == lastIndex { //最后一个cell
                let distance = currentCntOffset.x - scrollView.width * CGFloat(lastIndex)
                if distance > scrollThreshold { //滑动距离大于阈值
                    // 最后一个cell，正在往左滑动，已滑出阈值距离
                    self.exclusive(exc: "leftScrollThreshold", delay: 1.0) { [weak self] in
                        self?.scrollBlock?(.left)
                    }
                }
            }
        } else if currentCntOffset.x > previousCntOffset.x { //向右滑
            if self.activeBar?.selectedIndex == 0 { //第一个cell
                if currentCntOffset.x < -scrollThreshold { //滑动距离大于阈值
                    // 在第一个cell，正在往右滑动，已滑出阈值距离
                    self.exclusive(exc: "rightScrollThreshold", delay: 1.0) { [weak self] in
                        self?.scrollBlock?(.right)
                    }
                }
            }
        }
        previousCntOffset = currentCntOffset
    }
}
