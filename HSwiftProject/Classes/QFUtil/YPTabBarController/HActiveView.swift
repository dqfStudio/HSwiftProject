//
//  HActiveView.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/25.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HActiveView: UIStackView, HTupleViewDelegate {
    
    weak var activeBar: HActivebar?
    
    // 是否可以滚动
    var isScrollEnabled: Bool = true {
        didSet {
            tupleView.isScrollEnabled = isScrollEnabled
        }
    }
    
    var viewControllers: [UIViewController] = [] {
        didSet {
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
        // activeBar点击回调
        self.activeBar?.activeViewSelectBlock = { [weak self] index in
            guard let self = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.tupleView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
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
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, nil, false, indexPath) as! HTupleBaseCell
        let vc = self.viewControllers[indexPath.row]
        vc.view.frame = cell.layoutViewBounds
        if vc.view.superview == nil {
            cell.contentView.addSubview(vc.view)
        }
    }
}
