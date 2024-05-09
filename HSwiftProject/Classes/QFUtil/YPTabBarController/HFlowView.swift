//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/25.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HFlowView: UIScrollView, UIScrollViewDelegate {
    
    weak var flowBar: HFlowBar?
    
    var interceptLeftSlideGuetureInLastPage: Bool = false
    var interceptRightSlideGuetureInFirstPage: Bool = false
    
    // 被选中的Tab的Index
    private var selectedTabIndex: Int = 0
    
    // 是否可以滚动
    var contentScrollEnabled: Bool = true
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            oldValue.forEach({ vc in
                vc.removeFromParent()
                if vc.isViewLoaded {
                    vc.view.removeFromSuperview()
                }
            })
        }
    }
    
    // 获取被选中的ViewController
    var selectedController: UIViewController? {
        let count = self.viewControllers.count
        if self.selectedTabIndex >= 0, self.selectedTabIndex < count {
            return viewControllers[self.selectedTabIndex]
        }
        return nil
    }

    weak override var delegate: UIScrollViewDelegate? {
        get { return super.delegate }
        set { _ = newValue }
    }
        
    required init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    private func setup() {
        self.backgroundColor = .clear
        self.isPagingEnabled = true
        self.isScrollEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        super.delegate = self
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }

    // 更新vc frame
    private func updateContentViewsFrame() {
        if self.contentScrollEnabled {
            if !self.viewControllers.isEmpty {
                self.contentSize = CGSize(width: self.bounds.size.width * CGFloat(viewControllers.count), height: self.bounds.size.height)
                viewControllers.enumerated().forEach({ (idx, vc) in
                    if vc.isViewLoaded {
                        vc.view.frame = self.frameForControllerAtIndex(idx)
                    }
                })
                if let selectedController = self.selectedController {
                    if selectedController.view.superview == nil {
                        selectedController.view.frame = self.frameForControllerAtIndex(self.selectedTabIndex)
                        self.addSubview(selectedController.view)
                    }
                    self.scrollRectToVisible(selectedController.view.frame, animated: false)
                }
            }
        } else {
            self.contentSize = self.bounds.size
            viewControllers.enumerated().forEach({ (idx, vc) in
                if vc.isViewLoaded {
                    vc.view.removeFromSuperview()
                }
            })
            if let selectedController = self.selectedController {
                if selectedController.view.superview == nil {
                    selectedController.view.frame = self.bounds
                    self.addSubview(selectedController.view)
                }
            }
        }
    }

    private func frameForControllerAtIndex(_ index: Int) -> CGRect {
        let size = self.bounds.size
        return CGRect(x: CGFloat(index) * size.width, y: 0, width: size.width, height: size.height)
    }

    private var containerViewController: UIViewController? {
        var view: UIView? = self
        while let currentView = view {
            if let nextResponder = currentView.next as? UIViewController {
                return nextResponder
            }
            view = currentView.superview
        }
        return nil
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // 添加子vc
        viewControllers.forEach({ vc in
            self.containerViewController?.addChild(vc)
        })
        
        // 更新scrollView的content size
        if !viewControllers.isEmpty, self.contentScrollEnabled {
            self.contentSize = CGSize(width: self.bounds.size.width * CGFloat(viewControllers.count), 
                                      height: self.bounds.size.height)
        }
        
        // flowBar选中的index
        self.selectedTabIndex = self.flowBar?.selectedIndex ?? 0
        
        // 更新vc frame
        self.updateContentViewsFrame()
        
        // flowBar点击回调
        self.flowBar?.flowViewSelectBlock = { index in
            self.selectedTabIndex = index
            self.updateContentViewsFrame()
        }
    }

    // UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.flowBar?.selectedIndex = page
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 如果不是手势拖动导致的此方法被调用，不处理
        guard scrollView.isDragging || scrollView.isDecelerating else { return }


        // 滑动越界不处理
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.size.width

        if offsetX < 0 { return }
        if offsetX > scrollView.contentSize.width - scrollViewWidth { return }

        let leftIndex = Int(offsetX / scrollViewWidth)
        let rightIndex = leftIndex + 1

        // 将需要显示的child view放到scrollView上
        for index in leftIndex..<rightIndex {
            let controller = self.viewControllers[index]
            if !controller.isViewLoaded {
                let frame = self.frameForControllerAtIndex(index)
                controller.view.removeFromSuperview()
                controller.view.frame = frame
            }
            if controller.isViewLoaded, controller.view.superview == nil {
                self.addSubview(controller.view)
            }
        }
    }
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view?.isKind(of: UISlider.self) ?? false {
            self.isScrollEnabled = false
        } else {
            self.isScrollEnabled = true
        }
        return view
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if !gestureRecognizer.responds(to: #selector(gestureRecognizer.location(in:))) {
            return true
        }
        // 计算可能切换到的index
        let currentIndex = Int(self.contentOffset.x / self.frame.size.width)
        var targetIndex = currentIndex
        
        let location = gestureRecognizer.location(in: self)
        if location.x > 0 {
            targetIndex = currentIndex - 1
        } else {
            targetIndex = currentIndex + 1
        }
        
        // 第一页往右滑动
        if self.interceptRightSlideGuetureInFirstPage, targetIndex < 0 {
            return false
        }
        
        // 最后一页往左滑动
        if self.interceptLeftSlideGuetureInLastPage {
            let numberOfPage = Int(self.contentSize.width / self.frame.size.width)
            if targetIndex >= numberOfPage {
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if contentOffset.x <= 0 {
            return true
        } else {
            return false
        }
    }
}
