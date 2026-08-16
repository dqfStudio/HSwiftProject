//
//  HCollAlertVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HCollAlertNumberBlock = () -> Int
typealias HCollAlertInsetBlock = () -> UIEdgeInsets
typealias HCollAlertHeightBlock = (_ index: Int) -> CGFloat
typealias HCollAlertItemBlock = (_ coll: HCollView, _ indexPath: IndexPath) -> Void

let kCollAlertWidth: CGFloat = 291.0

class HCollAlertVC: HBaseController, HCollViewDelegate {
    
    let itemsHeight = NSMutableDictionary()
    var numberBlock: HCollAlertNumberBlock?
    var insetBlock: HCollAlertInsetBlock?
    var heightBlock: HCollAlertHeightBlock?
    var itemBlock: HCollAlertItemBlock?
    
    override var containerSize: CGSize {
        performBlocks()
        let height = itemsHeight.allValues.reduce(CGFloat(0)) { $0 + (($1 as? CGFloat) ?? 0) }
        return CGSize(width: kCollAlertWidth, height: height)
    }
    
    // 转场动画内容视图阴影部分颜色
    @objc override var shadowColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    override var presentType: HTransitionStyle {
        return .alert
    }
    
    override var isShadowDismiss: Bool {
        return true
    }

    private lazy var collView: HCollView = {
        var frame = CGRect.zero
        frame.size = self.containerSize
        let collView = HCollView(frame: frame)
        collView.backgroundColor = UIColor.red
        collView.isScrollEnabled = false
        collView.cornerRadius = 14
        //collView.setBoarderWith(0.5, color: UIColor.black)
        collView.disableBounce()
        return collView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.collView.delegate = self
        self.view.addSubview(self.collView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        super.vcWillDisappear(type)
        if type == .pop || type == .dismiss {
            collView.releaseCollBlock()
        }
    }
    
    // 执行block
    func performBlocks() {
        let items = max(numberBlock?() ?? 0, 0)
        itemsHeight.removeAllObjects()
        guard items > 0 else { return }
        for item in 0..<items {
            let height = heightBlock?(item) ?? 0
            itemsHeight.setObject(height, forKey: "\(item)" as NSCopying)
        }
    }

}

extension HCollAlertVC {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        return self.insetBlock?() ?? UIEdgeInsets.zero
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        let width = self.collView.width(for: indexPath.section)
        let width = self.collView.width
        let height = self.heightBlock?(indexPath.row) ?? 1.0
        return CGSize(width: width, height: height)
    }
    
    func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
        self.itemBlock?(coll, indexPath)
    }

}
