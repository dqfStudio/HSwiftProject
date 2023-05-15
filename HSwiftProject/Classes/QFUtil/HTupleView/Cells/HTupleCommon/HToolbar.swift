//
//  HToolbar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HToolbar: UIStackView, HTupleViewDelegate {
 
    lazy var tupleView: HTupleView = {
        return HTupleView(frame: .zero, scrollDirection: .horizontal)
    }()
    
//    lazy var indicatorBar: UIView = {
//        return UIView(frame: .zero)
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        self.tupleView.delegate = self
        self.addArrangedSubview(tupleView)
        
//        indicatorBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        self.addArrangedSubview(indicatorBar)
        
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 2
    }

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
        cell.sizeBlock = {
            return CGSize(width: 150, height: 40)
        }
        cell.cellBlock = {
            cell.backgroundColor = UIColor.red
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
    }
    
    // UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//        self.tabBar.selectedItemIndex = page
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
