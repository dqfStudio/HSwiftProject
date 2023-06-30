//
//  HTupleBannerApex.swift
//  FreeChat
//
//  Created by owner on 2023/6/28.
//

import UIKit

private let kBannerSize: Int = 1000

typealias HTupleBannerApexBlock = (_ index: Int, _ url: String) -> Void

class HTupleBannerApex : HTupleBaseApex, HTupleViewDelegate {
    
    // 图片之间的间隔
    var dotSpace: CGFloat = 8.0
    
    var dotHeight: CGFloat = 16.0
    
    // 网络图片 url string 数组
    var imageUrlArr: [String]? {
        didSet {
            if let groups = imageUrlArr, groups != oldValue, groups.count > 0 {
                self.tupleView.reloadTupleData()
                if self.dotIndicatorBar.superview == nil {
                    self.addSubview(self.dotIndicatorBar)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.runloopTimer.safe_resume()
                    }
                }
            }
        }
    }
    
    var selectedBannerBlock: HTupleBannerApexBlock?
    
    lazy var dotIndicatorBar: HDotIndicatorBar = {
        let dotIndicatorBar = HDotIndicatorBar(frame: .zero)
        dotIndicatorBar.items = imageUrlArr?.count ?? 0
        dotIndicatorBar.itemSpace = dotSpace
        dotIndicatorBar.itemColor = .green
        dotIndicatorBar.itemSelectedColor = .yellow
        dotIndicatorBar.itemSelectedWidth = dotHeight * 4
        return dotIndicatorBar
    }()
    
    private var selectedIndex: Int = 0
    private lazy var runloopTimer: Timer = {
        let timer = Timer(timeInterval: 3.0, repeats: true) { [self] weakTimer in
            if let imageUrlArr = imageUrlArr, imageUrlArr.count > 0 {
                if selectedIndex == imageUrlArr.count * kBannerSize - 1 {
                    selectedIndex = imageUrlArr.count * kBannerSize / 2
                }
                let indexPath = IndexPath(row: 0, section: selectedIndex + 1)
                self.tupleView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
        }
        timer.safe_pause()
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    //Apex初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    deinit {
        runloopTimer.invalidate()
    }
    
    //用于子类更新子视图布局
    override func relayoutSubviews() {
        self.tupleView.frame = self.layoutViewFrame
        self.dotIndicatorBar.frame = CGRect(x: self.layoutViewFrame.x,
                                            y: self.height - 12 - dotHeight,
                                            width: self.layoutViewBounds.width,
                                            height: dotHeight)
    }
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: layoutViewBounds, scrollDirection: .horizontal)
        tupleView.backgroundColor = .clear
        tupleView.isPagingEnabled = true
        return tupleView
    }()
    
    func numberOfSectionsInTupleView() -> Any {
        if let imageUrlArr = imageUrlArr, imageUrlArr.count > 0 {
            return imageUrlArr.count * kBannerSize
        }
        return 1
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        if let imageUrlArr = imageUrlArr, imageUrlArr.count > 0 {
            return 1
        }
        return 0
    }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width - dotSpace, height: self.tupleView.height)
    }
    
    func minimumFooterSpacingForSectionAt(_ section: Any) -> Any {
        return dotSpace
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleButtonApex.self, nil, true) as! HTupleButtonApex
        if let imageUrlArr = imageUrlArr {
            let index = indexPath.section % imageUrlArr.count
            let imageUrlString = imageUrlArr[index]
            cell.buttonView.setImageUrlString(imageUrlString)
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.selectedBannerBlock?(index, imageUrlString)
            }
        }
    }
    
    func willDisplayCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        if let imageUrlArr = imageUrlArr, imageUrlArr.count > 0 {
            if indexPath.section == 0 || indexPath.section == imageUrlArr.count * kBannerSize - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.tupleView.contentOffset = CGPoint(x: Int(self.tupleView.width) * imageUrlArr.count * kBannerSize / 2, y: 0)
                }
            }
            let index = indexPath.section % imageUrlArr.count
            self.dotIndicatorBar.selectedIndex = index
            self.selectedIndex = indexPath.section
        }
    }

}
