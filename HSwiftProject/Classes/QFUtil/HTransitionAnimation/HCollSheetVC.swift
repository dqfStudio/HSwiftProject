//
//  HCollSheetVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HCollSheetNumberBlock = () -> Int
typealias HCollSheetInsetBlock = () -> UIEdgeInsets
typealias HCollSheetHeightBlock = (_ index: Int) -> CGFloat
typealias HCollSheetItemBlock = (_ coll: HCollView, _ indexPath: IndexPath) -> Void

class HCollSheetVC: HViewController, HCollViewDelegate {
    
    let itemsHeight = NSMutableDictionary()
    var numberBlock: HCollSheetNumberBlock?
    var insetBlock: HCollSheetInsetBlock?
    var heightBlock: HCollSheetHeightBlock?
    var itemBlock: HCollSheetItemBlock?
    var bottomHeight = UIScreen.bottomBarHeight

    init(bottomSpacing: CGFloat) {
        self.bottomHeight += bottomSpacing
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
        height += self.bottomHeight
        return CGSize(width: UIScreen.width, height: height)
    }
    
    override var presentType: HTransitionStyle {
        return .sheet
    }
    
    override var isShadowDismiss: Bool {
        return true
    }

    private lazy var collView: HCollView = {
        var frame = CGRect.zero
        frame.size = self.containerSize
        let collView = HCollView(frame: frame)
        collView.backgroundColor = UIColor.black
        collView.isScrollEnabled = false
        collView.setCornerRadiiOnTop(16)
        collView.disableBounce()
        return collView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.isHidden = true
        self.collView.delegate = self
        self.view.addSubview(self.collView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.collView.releaseCollBlock()
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

extension HCollSheetVC {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        return self.insetBlock?() ?? UIEdgeInsets.zero
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = self.collView.width(for: indexPath.section)
        let height = self.heightBlock?(indexPath.row) ?? 1.0
        return CGSize(width: width, height: height)
    }
    
    func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
        self.itemBlock?(coll, indexPath)
    }

}
