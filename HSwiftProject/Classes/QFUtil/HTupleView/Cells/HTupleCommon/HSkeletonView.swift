//
//  HSkeletonView.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/22.
//  Copyright © 2023 wind. All rights reserved.
//

//import UIKit
//import TABAnimated
//
//class HSkeletonView: UIStackView, HTupleViewDelegate {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .clear
//        self.tupleView.delegate = self
//        self.addArrangedSubview(self.tupleView)
//    }
//
//    @available(*, unavailable)
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // Navigation bar
//    private lazy var tupleView: HTupleView = {
//        let tupleView = HTupleView(frame: .zero)
//        tupleView.backgroundColor = .clear
//        tupleView.isScrollEnabled = false
//        tupleView.tupleStatus = .block
//        tupleView.disableBounce()
//        return tupleView
//    }()
//
//    deinit {
//        self.tupleView.signalToAllHeader(nil, {
//            self.tupleView.signalToAllItems(nil, { })
//        })
//        self.tupleView.releaseTupleBlock()
//    }
//
//}
//
//extension HSkeletonView {
//
//    func insetForSection(_ section: Any) -> Any {
//        return UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
//    }
//
//    func numberOfItemsInSection(_ section: Any) -> Any {
//        return 5
//    }
//
//    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        return CGSize(width: self.width, height: 90)
//    }
//
//    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
//        let itemBlock = itemBlock as! HTupleItem
//        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
//
//        let frame = cell.layoutViewBounds
//
//        cell.imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        cell.imageView.cornerRadius = 8
//        cell.imageView.setImage(StandardUI.set_avatar_placeholder)
//
//        cell.label.frame = CGRect(x: 80, y: 0, width: frame.width - 80, height: 25)
//        cell.detailLabel.frame = CGRect(x: 80, y: 35, width: frame.width - 80, height: 25)
//
//        // 开始骨架动画
//        cell.tabAnimated = TABViewAnimated(viewHeight: 90)
//        cell.tab_startAnimation()
//        //接收信号
//        cell.signalBlock = { (target, signal) in
//            cell.tab_endAnimation()
//        }
//
//    }
//
//}
//
