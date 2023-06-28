//
//  HTupleBannerCell.swift
//  FreeChat
//
//  Created by owner on 2023/6/28.
//

import UIKit

private let kBannerSize: Int = 1000

typealias HTupleBannerCellBlock = (_ index: Int, _ url: String) -> Void

class HTupleBannerCell : HTupleBaseCell, HTupleViewDelegate {
    
    // 图片之间的间隔
    var imageSpace: CGFloat = 16.0
    
    // 网络图片 url string 数组
    var imageURLStringsGroup: [String]? {
        didSet {
            if let groups = imageURLStringsGroup, groups != oldValue, groups.count > 0 {
                self.tupleView.reloadTupleData()
            }
        }
    }
    
    var selectedBannerBlock: HTupleBannerCellBlock?
    
    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    //用于子类更新子视图布局
    override func relayoutSubviews() {
        self.tupleView.frame = self.layoutViewFrame
    }
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: layoutViewBounds, scrollDirection: .horizontal)
        tupleView.backgroundColor = .clear
        tupleView.isPagingEnabled = true
        return tupleView
    }()
    
    func numberOfSectionsInTupleView() -> Any {
        if let imageURLStringsGroup = imageURLStringsGroup, imageURLStringsGroup.count > 0 {
            return imageURLStringsGroup.count * kBannerSize
        }
        return 1
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        if let imageURLStringsGroup = imageURLStringsGroup, imageURLStringsGroup.count > 0 {
            return 1
        }
        return 0
    }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width - imageSpace, height: self.tupleView.height)
    }
    
    func minimumFooterSpacingForSectionAt(_ section: Any) -> Any {
        return imageSpace
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
        if let imageURLStringsGroup = imageURLStringsGroup {
            let index = indexPath.section % imageURLStringsGroup.count
            let imageUrlString = imageURLStringsGroup[index]
            cell.buttonView.setImageUrlString(imageUrlString)
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.selectedBannerBlock?(index, imageUrlString)
            }
        }
    }
    
    func willDisplayCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        if let imageURLStringsGroup = imageURLStringsGroup, imageURLStringsGroup.count > 0 {
            if indexPath.section == 0 || indexPath.section == imageURLStringsGroup.count * kBannerSize - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.tupleView.contentOffset = CGPoint(x: Int(self.tupleView.width) * imageURLStringsGroup.count * kBannerSize / 2, y: 0)
                }
            }
        }
    }

}
