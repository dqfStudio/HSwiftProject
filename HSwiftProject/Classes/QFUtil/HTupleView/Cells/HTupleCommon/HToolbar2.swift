//
//  HToolbar2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/15.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HToolbar2: UIStackView, HTupleViewDelegate {

    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero, scrollDirection: .horizontal)
//        let tupleView = HTupleView(frame: .zero)
        tupleView.tupleStatus = .block
        return tupleView
    }()

    lazy var indicatorBar: UIView = {
//        return UIView(frame: .zero)
        return UIView(frame: CGRect(x: 0, y: 37, width: 120, height: 3))
    }()

    var selectedIndex: Int = 0


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill

        self.tupleView.delegate = self
        self.addArrangedSubview(tupleView)

//        indicatorBar.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        indicatorBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        self.addArrangedSubview(indicatorBar)
//        UICollectionView
        
//        tupleView.isPagingEnabled = true
//        tupleView.isScrollEnabled = true
        
        
        
        indicatorBar.backgroundColor = .red
        tupleView.addSubview(indicatorBar)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 6
    }
    
    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleBaseApex.self, nil, true) as! HTupleBaseApex
        cell.sizeBlock = {
            let bounds = cell.layoutViewBounds
            return CGSize(width: bounds.width, height: 3)
        }
    }
    
//    func tupleFooter(_ footerBlock: Any, inSection section: Any) {
//        let footerBlock = footerBlock as! HTupleFooter
//        let cell = footerBlock(nil, HTupleBaseApex.self, nil, true) as! HTupleBaseApex
//        cell.sizeBlock = {
//            let bounds = cell.layoutViewBounds
//            return CGSize(width: bounds.width, height: 3)
//        }
//    }

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
        cell.sizeBlock = {
            let bounds = cell.layoutViewBounds
            return CGSize(width: bounds.width / 3, height: bounds.height)
        }
        cell.cellBlock = {

            let bounds = cell.layoutViewBounds
            cell.label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 37)
            cell.label.textAlignment = .center
            cell.label.text = "wwww"
            if indexPath.row == 0 {
                cell.label.backgroundColor = UIColor.blue
            } else if indexPath.row == 1 {
                cell.label.backgroundColor = UIColor.green
            } else if indexPath.row == 2 {
                cell.label.backgroundColor = UIColor.yellow
            }

//            cell.detailLabel.frame = CGRect(x: 0, y: 37, width: bounds.width, height: 3)
//            if indexPath.row == 0 {
//                cell.detailLabel.backgroundColor = .red
//            } else if indexPath.row == 1 {
//
//            } else if indexPath.row == 2 {
//
//            }
            if self.selectedIndex == indexPath.row {
//                cell.detailLabel.backgroundColor = .red
            } else {
//                cell.detailLabel.backgroundColor = .clear
            }
        }
        cell.selectBlock = {
            self.selectedIndex = indexPath.row
            
            self.indicatorBar.frame = CGRect(x: 120 * indexPath.row, y: 37, width: 120, height: 3)
            
            
            self.tupleView.reloadTupleData()
        }

    }

//    func tupleScrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        if (offsetY >= 2 * self.view.height) {//向上滚动
//            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
//            self.tupleScrollViewDidScrollToTop(scrollView)
//        }else if (offsetY <= 0) {//向下滚动
//            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
//            self.tupleScrollViewDidScrollToBottom(scrollView)
//        }
//    }

//    func tupleScrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        if (offsetY >= 2 * self.view.height) {//向上滚动
//            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
//            self.tupleScrollViewDidScrollToTop(scrollView)
//        }else if (offsetY <= 0) {//向下滚动
//            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
//            self.tupleScrollViewDidScrollToBottom(scrollView)
//        }
//    }

    func tupleViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: CGPoint) {
        let targetX = targetContentOffset.x
        let currentX = self.tupleView.contentOffset.x
        let distance = targetX - currentX

        if distance > 0 {
            // User swiped right
            print("User swiped right")
        } else if distance < 0 {
            // User swiped left
            print("User swiped left")
        }

        let page: Int = Int(currentX / 150)
//        self.tabBar.selectedItemIndex = page

//        self.selectedIndex = page
//        self.tupleView.reloadTupleData()
    }

    // UIScrollViewDelegate
    func tupleViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let page: Int = Int(scrollView.contentOffset.x / 150)
//        self.tabBar.selectedItemIndex = page

//        self.selectedIndex = page
//        self.tupleView.reloadTupleData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        // 如果不是手势拖动导致的此方法被调用，不处理
//        if !(scrollView.isDragging || scrollView.isDecelerating) {
//            if (scrollView.contentOffset.x == 0) {
//                // 解决有时候滑动冲突后scrollView跳动导致的item颜色显示错乱的问题
//                self.tabBar.updateSubViewsWhenParentScrollViewScroll(self.contentScrollView)
//            }
//            return
//        }
//
//        // 滑动越界不处理
//        let offsetX: CGFloat = scrollView.contentOffset.x
//        let scrollViewWidth: CGFloat = scrollView.frame.size.width
//
//        if (offsetX < 0) {
//            return
//        }
//        if (offsetX > scrollView.h_contentSize.width - scrollViewWidth) {
//            return
//        }
//
//        let leftIndex: Int = Int(offsetX / scrollViewWidth)
//        var rightIndex: Int = leftIndex + 1
    }

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let targetX = targetContentOffset.pointee.x
//        let currentX = scrollView.contentOffset.x
//        let distance = targetX - currentX
//
//        if distance > 0 {
//            // User swiped right
//            print("User swiped right")
//        } else if distance < 0 {
//            // User swiped left
//            print("User swiped left")
//        }
//    }

//    //向上滚动
//    func tupleScrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        // 更改直播状态
////        self.liveStatus = .loading
//    }
//    //向下滚动
//    func tupleScrollViewDidScrollToBottom(_ scrollView: UIScrollView) {
//        // 更改直播状态
////        self.liveStatus = .loading
//    }

}
