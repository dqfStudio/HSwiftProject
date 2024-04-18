//
//  HTupleBannerCell.swift
//  FreeChat
//
//  Created by owner on 2023/6/28.
//

import UIKit

private let kBannerSize: Int = 1000
private let kRunloopCount: CGFloat = 5.0

typealias HTupleBannerCellBlock = (_ index: Int, _ url: String) -> Void

class HTupleBannerCell : HTupleBaseCell, HTupleViewDelegate {
    
    // dot之间的间隔
    var dotSpace: CGFloat = 8.0
    
    // dot的高度
    var dotHeight: CGFloat = 6.0
    
    // 网络图片 url string 数组
    var imageUrlArr: [String]? {
        didSet {
            if let groups = imageUrlArr, groups != oldValue, groups.count > 0 {
                self.tupleView.reloadTupleData()
                self.tupleView.isScrollEnabled = false
                if self.dotIndicatorBar.superview == nil, groups.count > 1 {
                    self.tupleView.isScrollEnabled = true
                    self.addSubview(self.dotIndicatorBar)
                    DispatchQueue.main.asyncAfter(deadline: .now() + kRunloopCount) {
                        self.bringSubviewToFront(self.dotIndicatorBar)
                        self.runloopTimer.safe_resume()
                    }
                }
            }
        }
    }
    
    var selectedBannerBlock: HTupleBannerCellBlock?
    
    lazy var dotIndicatorBar: HDotIndicatorBar = {
        let dotIndicatorBar = HDotIndicatorBar(frame: .zero)
        dotIndicatorBar.items = imageUrlArr?.count ?? 0
        dotIndicatorBar.itemSpace = dotSpace
        dotIndicatorBar.itemColor = UIColor(white: 1.0, alpha: 0.5)
        dotIndicatorBar.itemSelectedColor = UIColor.white
        dotIndicatorBar.itemSelectedWidth = dotHeight * 4
        return dotIndicatorBar
    }()
    
    // 是否为自动滚动
    private var autoScroll: Bool = false
    // 是否为延时执行
    private var delayPerform: Bool = false
    
    // 当前选中的item序号
    private var selectedIndex: Int = 0 {
        didSet {
            // 自动滚动
            if self.autoScroll {
                self.autoScroll = false
            } else {
                self.runloopTimer.safe_pause()
                // 添加延时任务
                if self.delayPerform {
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTimer), object: nil)
                }
                self.perform(#selector(resumeTimer), with: nil, afterDelay: kRunloopCount)
                self.delayPerform = true
            }
        }
    }

    @objc
    private func resumeTimer() {
        self.runloopTimer.safe_resume()
    }
    
    private lazy var runloopTimer: Timer = {
        let timer = Timer(timeInterval: kRunloopCount, repeats: true) { [self] weakTimer in
            if let imageUrlArr = imageUrlArr, imageUrlArr.count > 1 {
                if selectedIndex <= imageUrlArr.count * kBannerSize - 2 {
                    self.autoScroll = true //自动滚动
                    let indexPath = IndexPath(row: 0, section: selectedIndex + 1)
                    self.tupleView.scrollToItem(at: indexPath, at: .right, animated: true)
                    self.bringSubviewToFront(self.dotIndicatorBar)
                }
            }
        }
        timer.safe_pause()
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    //Cell初始化是调用的方法
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
        if let imageUrlArr = imageUrlArr, imageUrlArr.count > 1 {
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
        return CGSize(width: self.tupleView.width - 16, height: self.tupleView.height)
    }
    
    func minimumFooterSpacingForSectionAt(_ section: Any) -> Any {
        return 16
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.cell(HTupleButtonCell.self, "banner", true, indexPath) as! HTupleButtonCell
        if let imageUrlArr = imageUrlArr {
            let index = indexPath.section % imageUrlArr.count
            let imageUrlString = imageUrlArr[index]
            cell.buttonView.cornerRadius = 16
            cell.buttonView.setImageUrlString(imageUrlString, placeholder: UIImage(named: "community_banner_placeholder"))
            cell.buttonView.pressed = { (sender, data) in
                self.selectedBannerBlock?(index, imageUrlString)
            }
        }
    }
    
    func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        if let imageUrlArr = imageUrlArr, imageUrlArr.count > 1 {
            if indexPath.section == 0 || indexPath.section == imageUrlArr.count * kBannerSize - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.autoScroll = true //自动滚动
                    let tmpIndexPath = IndexPath(row: 0, section: imageUrlArr.count * kBannerSize / 2)
                    self.tupleView.scrollToItem(at: tmpIndexPath, at: .right, animated: false)
                }
            } else {
                let index = indexPath.section % imageUrlArr.count
                self.dotIndicatorBar.selectedIndex = index
                self.selectedIndex = indexPath.section
            }
        }
    }

}
