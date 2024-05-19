//
//  HTupleDropVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HTupleDropNumberBlock = () -> Int
typealias HTupleDropInsetBlock = () -> UIEdgeInsets
typealias HTupleDropHeightBlock = (_ index: Int) -> CGFloat
typealias HTupleDropItemBlock = (_ tuple: HTupleView, _ indexPath: IndexPath) -> Void

class HTupleDropVC: HViewController, HTupleViewDelegate {
    
    let itemsHeight = NSMutableDictionary()
    var numberBlock: HTupleDropNumberBlock?
    var insetBlock: HTupleDropInsetBlock?
    var heightBlock: HTupleDropHeightBlock?
    var itemBlock: HTupleDropItemBlock?
    var topHeight = UIScreen.statusBarHeight

    init(topSpacing: CGFloat) {
        self.topHeight += topSpacing
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var containerSize: CGSize {
        // 执行block
        self.performBlocks()
        // 计算高度
        var height = self.itemsHeight.allValues.reduce(0, { $0 + ($1 as! CGFloat) })
        // 加上底部间隔
        height += self.topHeight
        return CGSize(width: UIScreen.width, height: height)
    }
    
    override var presentType: HTransitionStyle {
        return .drop
    }
    
    override var isShadowDismiss: Bool {
        return true
    }

    private lazy var tupleView: HTupleView = {
        var frame = CGRect.zero
        frame.size = self.containerSize
        let tupleView = HTupleView(frame: frame)
        tupleView.backgroundColor = UIColor.black
        tupleView.isScrollEnabled = false
        tupleView.setCornerRadiiOnBottom(16)
        tupleView.disableBounce()
        return tupleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    // 执行block
    func performBlocks() {
        // 调用代理
        let items = self.numberBlock?() ?? 0
        self.itemsHeight.removeAllObjects()
        for item in 0...items - 1 {
            let height = self.heightBlock?(item) ?? 0
            self.itemsHeight.setObject(height, forKey: "\(item)" as NSCopying)
        }
    }

}

extension HTupleDropVC {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        return self.insetBlock?() ?? UIEdgeInsets.zero
    }
    
    func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any {
        return self.topHeight
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = self.tupleView.width(forSection: indexPath.section)
        let height = self.heightBlock?(indexPath.row) ?? 1.0
        return CGSize(width: width, height: height)
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        self.itemBlock?(tuple, indexPath)
    }

}
