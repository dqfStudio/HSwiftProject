////
////  HFlowView.swift
////  HSwiftProject
////
////  Created by owner on 2024/4/25.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import UIKit
//
////自定义UIScrollView，在需要时可以拦截其滑动手势
//@objc protocol HFlowViewDelegate: NSObjectProtocol {
//    @objc
//    optional func scrollView(_ scrollView: HFlowView, shouldScrollToPageIndex index: Int) -> Bool
//    @objc
//    optional func scrollView(_ scrollView: HFlowView, didSelectedItemAtIndex index: Int)
////    @objc
////    optional func h_tabBar(_ tabBar: HTabBar, didSelectedItemAtIndex index: Int)
//}
//
//class HFlowView: UIScrollView {
//    
//    weak var h_delegate: HFlowViewDelegate?
//    var interceptLeftSlideGuetureInLastPage: Bool = false
//    var interceptRightSlideGuetureInFirstPage: Bool = false
//    
//    
//    
//    
//    
////    private var _tabBar: HTabBar = HTabBar()
////    var tabBar: HTabBar {
////        get { return _tabBar }
////        set {
////            _tabBar = newValue
////            _tabBar.delegate = self
////        }
////    }
//    
//    var selectedIndex: Int = 0
//    
//    private var _viewControllers: [UIViewController]?
//    var viewControllers: [UIViewController]? {
//        get {
//            return _viewControllers
//        }
//        set {
//            _viewControllers?.forEach({ vc in
////                if vc.h_hasAddedContentOffsetObserver {
////                    vc.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
////                    vc.h_hasAddedContentOffsetObserver = false
////                }
//                vc.removeFromParent()
//                if vc.isViewLoaded {
//                    vc.h_displayView.removeFromSuperview()
//                }
//            })
//
//            _viewControllers = newValue
//            
//            let containerVC = self.containerViewController
//
////            var items = [HTabItem]()
//            _viewControllers?.forEach({ vc in
//                containerVC?.addChild(vc)
//                
////                let item = HTabItem()
////                item.image = vc.h_tabItemImage
////                item.selectedImage = vc.h_tabItemSelectedImage
////                item.title = vc.h_tabItemTitle
////                items.append(item)
//            })
////            self.tabBar.items = items
//
//            // 更新scrollView的content size
//            if let viewControllers = _viewControllers, self.contentScrollEnabled {
//                self.h_contentSize = CGSize(width: self.bounds.size.width * CGFloat(viewControllers.count), height: self.bounds.size.height)
//            }
//            
////            if _isDefaultSelectedTabIndexSetuped {
////                _selectedTabIndex = NSNotFound
////                self.tabBar.selectedItemIndex = 0
////            }
//        }
//    }
//    
//    weak var delegate: HTabContentViewDelegate?
//    
//    
//    /**
//     *  获取被选中的ViewController
//     */
//    var selectedController: UIViewController? {
//        if self.selectedTabIndex != NSNotFound, let viewControllers = self.viewControllers {
//            return viewControllers[self.selectedTabIndex]
//        }
//        return nil
//    }
//
//    private var _isDefaultSelectedTabIndexSetuped: Bool = false
//    private var _lastContentScrollViewOffsetX: CGFloat = 0.0
//    private var _currentScrollViewOffsetY: CGFloat = 0.0
//
//    private var _contentScrollView: _HTabContentScrollView = _HTabContentScrollView()
//    private var contentScrollView: _HTabContentScrollView {
//        get { return _contentScrollView }
//        set { _contentScrollView = newValue }
//    }
//
//    private var headerViewDefaultHeight: CGFloat = 0.0
//    private var tabBarStopOnTopHeight: CGFloat = 0.0
//    private var headerViewNeedStretch: Bool = false
//    
//    private var contentScrollEnabled: Bool = false
//    private var contentSwitchAnimated: Bool = false
//    
//        
//    required init() {
//        super.init(frame: .zero)
//        self.setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.setup()
//    }
//    
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setup()
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.setup()
//    }
//
//    private func setup() {
//        self.backgroundColor = .clear
////        self.clipsToBounds = true
//
////        _tabBar.delegate = self
//        
////        _contentScrollView.frame = self.frame
//        self.isPagingEnabled = true
//        self.isScrollEnabled = false
//        self.showsHorizontalScrollIndicator = false
//        self.showsVerticalScrollIndicator = false
//        self.scrollsToTop = false
//        self.delegate = self
//        self.h_delegate = self
////        self.interceptRightSlideGuetureInFirstPage = self.interceptRightSlideGuetureInFirstPage
////        self.interceptLeftSlideGuetureInLastPage = self.interceptLeftSlideGuetureInLastPage
//        if #available(iOS 11.0, *) {
//            self.contentInsetAdjustmentBehavior = .never
//        }
////        self.addSubview(_contentScrollView)
//    }
//
//    override var frame: CGRect {
//        get { return super.frame }
//        set {
//            super.frame = newValue
//            if newValue != CGRect.zero {
////                self.contentScrollView.frame = self.bounds
//                self.updateContentViewsFrame()
//            }
//        }
//    }
//
//    deinit {
//        if let viewControllers = self.viewControllers {
//            for vc in viewControllers where vc.h_hasAddedContentOffsetObserver {
//                // 如果vc注册了contentOffset的观察者，需移除
//                vc.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
//                vc.h_hasAddedContentOffsetObserver = false
//            }
//        }
//    }
//
//    private func updateContentViewsFrame() {
//        if self.contentScrollEnabled {
//            if let viewControllers = self.viewControllers, viewControllers.count > 0 {
//                self.h_contentSize = CGSize(width: self.bounds.size.width * CGFloat(viewControllers.count), height: self.bounds.size.height)
//                viewControllers.enumerated().forEach({ (idx, vc) in
//                    if vc.isViewLoaded {
//                        vc.h_displayView.frame = self.frameForControllerAtIndex(idx)
//                    }
//                })
//                if let selectedController = self.selectedController {
//                    self.scrollRectToVisible(selectedController.h_displayView.frame, animated: false)
//                }
//            }
//        } else {
//            self.h_contentSize = self.bounds.size
//            self.selectedController?.h_displayView.frame = self.bounds
//        }
//    }
//
//    private func frameForControllerAtIndex(_ index: Int) -> CGRect {
//        let size = self.bounds.size
//        return CGRect(x: CGFloat(index) * size.width, y: 0, width: size.width, height: size.height)
//    }
//
//    private var containerViewController: UIViewController? {
//        var view: UIView? = self
//        while let currentView = view {
//            if let nextResponder = currentView.next as? UIViewController {
//                return nextResponder
//            }
//            view = currentView.superview
//        }
//        return nil
//    }
//
////    override func didMoveToSuperview() {
////        super.didMoveToSuperview()
////        if _isDefaultSelectedTabIndexSetuped { return }
////        if let vc = self.containerViewController {
////            if #available(iOS 11.0, *) {
////                if let scrollView = vc.view as? UIScrollView {
////                    scrollView.contentInsetAdjustmentBehavior = .never
////                }
////            }else {
////                vc.automaticallyAdjustsScrollViewInsets = false
////            }
////            vc.h_willAppearInjectBlock = { (_ viewController: UIViewController, _ animated: Bool) in
////                self.selectedTabIndex = self.defaultSelectedTabIndex
////                self._isDefaultSelectedTabIndexSetuped = true
////                vc.h_willAppearInjectBlock = nil
////            }
////        }
////    }
//
////    @objc
////    private func handlePan(_ gesture: UIPanGestureRecognizer) {
////        if let scrollView = self.selectedController?.h_displayView as? UIScrollView {
////            
////            if !scrollView.isKind(of: UIScrollView.self) { return }
////            if gesture.state == .began {
////                _currentScrollViewOffsetY = scrollView.contentOffset.y
////            }
////            
////            let point = gesture.translation(in: self)
////            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: _currentScrollViewOffsetY - point.y)
////            if gesture.state == .ended {
////                let defaultOffsetY: CGFloat = -(self.headerViewDefaultHeight + self.tabBar.frame.size.height)
////                if scrollView.contentOffset.y < defaultOffsetY {
////                    scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.frame.size.height + defaultOffsetY - 1, width: scrollView.frame.size.width, height: 1), animated:true)
////                }
////            }
////        }
////    }
//
////    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////        if kContentOffset == keyPath {
////            let value = change![NSKeyValueChangeKey.newKey] as! NSValue
////            let offsetY: CGFloat = value.cgPointValue.y + self.headerViewDefaultHeight + self.tabBar.frame.size.height
////            var headerFrame: CGRect = .zero
////            let minHeaderY: CGFloat = self.headerViewDefaultHeight - self.tabBarStopOnTopHeight
////            if (offsetY > minHeaderY) {
////                headerFrame = CGRect(x: 0, y: -minHeaderY, width: self.frame.size.width, height: self.headerViewDefaultHeight)
////            } else if (offsetY >= 0 && offsetY <= minHeaderY) {
////                headerFrame = CGRect(x: 0, y: -offsetY, width: self.frame.size.width, height: self.headerViewDefaultHeight)
////            } else {
////                let height: CGFloat = self.headerViewDefaultHeight - (self.headerViewNeedStretch ? offsetY : 0)
////                headerFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
////            }
////            self.headerView?.frame = headerFrame
////
////            var tabBarFrame: CGRect = self.tabBar.frame
////            tabBarFrame.origin.y = headerFrame.maxY
////            self.tabBar.frame = tabBarFrame
////            
////            if let delegate = self.delegate {
////                let selector = #selector(delegate.tabContentView(_:didChangedContentOffsetY:))
////                if delegate.responds(to: selector) {
////                    delegate.tabContentView?(self, didChangedContentOffsetY: offsetY)
////                }
////            }
////        }
////    }
//
////    private func updateContentOffsetOfDisplayScrollView(_ scrollView: UIScrollView) {
////        let tabBarY = self.tabBar.frame.origin.y
////        if tabBarY > self.tabBarStopOnTopHeight ||
////            scrollView.contentOffset.y == 0 ||
////            scrollView.contentOffset.y <= -self.tabBar.frame.maxY {
////            scrollView.contentOffset = CGPoint(x: 0, y: -(tabBarY + self.tabBar.frame.size.height))
////        }
////    }
//
////    // HTabBarDelegate
////    func h_tabBar(_ tabBar: HTabBar, shouldSelectItemAtIndex index: Int) -> Bool {
////        return self.shouldSelectItemAtIndex(index)
////    }
////
////    func h_tabBar(_ tabBar: HTabBar, willSelectItemAtIndex index: Int) {
////        if let delegate = self.delegate {
////            let selector = #selector(delegate.tabContentView(_:willSelectTabAtIndex:))
////            if delegate.responds(to: selector) {
////                delegate.tabContentView?(self, willSelectTabAtIndex: index)
////            }
////        }
////    }
////
////    func h_tabBar(_ tabBar: HTabBar, didSelectedItemAtIndex index: Int) {
////        if index == self.selectedTabIndex { return }
////        var oldController: UIViewController?
////        if self.selectedTabIndex != NSNotFound {
////            oldController = self.viewControllers?[self.selectedTabIndex]
////            oldController?.h_tabItemDidDeselected()
////            let selector = #selector(oldController!.h_tabItemDidDeselected)
////            if oldController!.responds(to: selector) {
////                oldController!.perform(selector)
////            }
////            if (!self.contentScrollEnabled ||
////                    (self.contentScrollEnabled && self.removeViewOfChildContollerWhileDeselected)) {
////                self.viewControllers?.enumerated().forEach({ (idx, vc) in
////                    if (idx != index && vc.isViewLoaded && vc.h_displayView.superview != nil) {
////                        vc.h_displayView.removeFromSuperview()
////                    }
////               })
////            }
////        }
////        let curController = self.viewControllers![index]
////        if self.contentScrollEnabled {
////            // contentView支持滚动
////            if !curController.isViewLoaded {
////                let frame = self.frameForControllerAtIndex(index)
////                if curController.view != curController.h_displayView {
////                    curController.view.frame = frame
////                }
////                curController.h_displayView.frame = frame
////            }
////
////            self.contentScrollView.addSubview(curController.h_displayView)
////            // 切换到curController
////            self.contentScrollView.scrollRectToVisible(curController.h_displayView.frame, animated: self.contentSwitchAnimated)
////
////        } else {
////            // contentView不支持滚动
////            self.contentScrollView.addSubview(curController.h_displayView)
////            // 设置curController.view的frame
////            if curController.h_displayView.frame != self.contentScrollView.bounds {
////                if curController.view != curController.h_displayView {
////                    curController.view.frame = self.contentScrollView.bounds
////                }
////                curController.h_displayView.frame = self.contentScrollView.bounds
////            }
////        }
////
////        // 获取是否是第一次被选中的标识
////        if curController.h_hasBeenDisplayed {
////            curController.h_tabItemDidSelected(false)
////        } else {
////            curController.h_tabItemDidSelected(true)
////            curController.h_hasBeenDisplayed = true
////        }
////
////        if curController.responds(to: #selector(curController.h_tabItemDidSelected(_:))) {
////            curController.perform(#selector(curController.h_tabItemDidSelected(_:)))
////        }
////
////        // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
////        if let scrollView = oldController?.h_displayView as? UIScrollView {
////            scrollView.scrollsToTop = false
////        }
////        if let curScrollView = curController.h_displayView as? UIScrollView {
////            curScrollView.scrollsToTop = false
////            if self.headerView != nil {
////                var insets = curScrollView.contentInset
////                insets.top = self.headerViewDefaultHeight + self.tabBar.frame.size.height
////                curScrollView.contentInset = insets
////                curScrollView.scrollIndicatorInsets = insets
////                if !curController.h_disableMinContentHeight {
////                    curScrollView.minContentSizeHeight = self.contentScrollView.frame.size.height - self.tabBar.frame.size.height - self.tabBarStopOnTopHeight
////                }
////
////                if let oldVC = oldController, oldVC.h_hasAddedContentOffsetObserver {
////                    // 移除oldController的h_displayView注册的观察者
////                    oldVC.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
////                    oldVC.h_hasAddedContentOffsetObserver = false
////                }
////                if !curController.h_hasAddedContentOffsetObserver {
////                    // 注册curScrollView的观察者
////                    curScrollView.addObserver(self, forKeyPath: kContentOffset, options: .new, context: nil)
////                    curController.h_hasAddedContentOffsetObserver = true
////                }
////                self.updateContentOffsetOfDisplayScrollView(curScrollView)
////            }
////        }
////
////        _selectedTabIndex = index
////
////        if let delegate = self.delegate {
////            let selecotr = #selector(delegate.tabContentView(_:didSelectedTabAtIndex:))
////            if delegate.responds(to: selecotr) {
////                delegate.tabContentView?(self, didSelectedTabAtIndex: index)
////            }
////        }
////    }
////
////    func h_tabBar(_ tabBar: HTabBar, reSelectedTabAtIndex index: Int) {
////        if let delegate = self.delegate {
////            let selector = #selector(delegate.tabContentView(_:reSelectedTabAtIndex:))
////            if delegate.responds(to: selector) {
////                delegate.tabContentView?(self, reSelectedTabAtIndex: index)
////            }
////        }
////    }
//
////    // _HTabContentScrollViewDelegate
////    fileprivate func scrollView(_ scrollView: _HTabContentScrollView, shouldScrollToPageIndex index: Int) -> Bool {
////        return self.shouldSelectItemAtIndex(index)
////    }
////
////    private func shouldSelectItemAtIndex(_ index: Int) -> Bool {
////        if let delegate = self.delegate {
////            let selector = #selector(delegate.tabContentView(_:shouldSelectTabAtIndex:))
////            if delegate.responds(to: selector) {
////                return delegate.tabContentView!(self, shouldSelectTabAtIndex: index)
////            }
////        }
////        return true
////    }
//
//    // UIScrollViewDelegate
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
////        self.tabBar.selectedItemIndex = page
//        
//        self.h_delegate?.scrollView(self, didSelectedItemAtIndex: page)
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        // 如果不是手势拖动导致的此方法被调用，不处理
//        if !(scrollView.isDragging || scrollView.isDecelerating) {
//            if scrollView.contentOffset.x == 0 {
//                // 解决有时候滑动冲突后scrollView跳动导致的item颜色显示错乱的问题
//                self.tabBar.updateSubViewsWhenParentScrollViewScroll(self)
//            }
//            return
//        }
//
//        // 滑动越界不处理
//        let offsetX: CGFloat = scrollView.contentOffset.x
//        let scrollViewWidth: CGFloat = scrollView.frame.size.width
//
//        if offsetX < 0 { return }
////        if offsetX > scrollView.h_contentSize.width - scrollViewWidth { return }
//        if offsetX > scrollView.contentSize.width - scrollViewWidth { return }
//
//        let leftIndex = Int(offsetX / scrollViewWidth)
//        var rightIndex = leftIndex + 1
//
//        // 这里处理shouldSelectItemAtIndex方法
//        if let delegate = self.delegate {
//            let selector = #selector(delegate.tabContentView(_:shouldSelectTabAtIndex:))
//            if delegate.responds(to: selector), !scrollView.isDecelerating {
//                var targetIndex: Int = 0
//                if _lastContentScrollViewOffsetX < offsetX {
//                    // 向左
//                    targetIndex = rightIndex
//                } else {
//                    // 向右
//                    targetIndex = leftIndex
//                }
//                if targetIndex != self.selectedTabIndex {
//                    if !self.shouldSelectItemAtIndex(targetIndex) {
//                        scrollView.setContentOffset(CGPoint(x: CGFloat(self.selectedTabIndex) * scrollViewWidth, y: 0), animated: false)
//                    }
//                }
//            }
//        }
//        _lastContentScrollViewOffsetX = offsetX
//
//        // 刚好处于能完整显示一个child view的位置
//        if leftIndex == Int(offsetX / scrollViewWidth) {
//            rightIndex = leftIndex
//        }
//        // 将需要显示的child view放到scrollView上
//        for index in leftIndex..<rightIndex + 1 {
//
//            let controller = self.viewControllers![index]
//
//            if !controller.isViewLoaded, self.loadViewOfChildContollerWhileAppear {
//                let frame: CGRect = self.frameForControllerAtIndex(index)
//                if controller.view != controller.h_displayView {
//                    controller.view.frame = frame
//                }
//                controller.h_displayView.removeFromSuperview()
//                controller.h_displayView.frame = frame
//            }
////            if controller.isViewLoaded, controller.h_displayView.superview == nil {
//            if controller.isViewLoaded, controller.view.superview == nil {
//                self.addSubview(controller.view)
//
////                if self.headerView != nil {
////                    let scrollView = controller.h_displayView as! UIScrollView
////                    // 如果有headerView，需要更新contentOffset
////                    var insets = scrollView.contentInset
////                    insets.top = self.headerViewDefaultHeight + self.tabBar.frame.size.height
////                    scrollView.contentInset = insets
////                    scrollView.scrollIndicatorInsets = insets
////                    if !controller.h_disableMinContentHeight {
////                        scrollView.minContentSizeHeight = self.contentScrollView.frame.size.height - self.tabBar.frame.size.height - self.tabBarStopOnTopHeight
////                    }
////                    self.updateContentOffsetOfDisplayScrollView(scrollView)
////                }
//            }
//        }
//
//        // 同步修改tarBar的子视图状态
////        self.tabBar.updateSubViewsWhenParentScrollViewScroll(self.contentScrollView)
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//        
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        if view?.isKind(of: UISlider.self) ?? false {
//            self.isScrollEnabled = false
//        } else {
//            self.isScrollEnabled = true
//        }
//        return view
//    }
//
//    /**
//     *  重写此方法，在需要的时候，拦截UIPanGestureRecognizer
//     */
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
//        
//        if !gestureRecognizer.responds(to: #selector(gestureRecognizer.translation(in:))) {
//            return true
//        }
//        // 计算可能切换到的index
//        let currentIndex = Int(self.contentOffset.x / self.frame.size.width)
//        var targetIndex = currentIndex
//        
//        let translation = gestureRecognizer.translation(in: self)
//        if translation.x > 0 {
//            targetIndex = currentIndex - 1
//        } else {
//            targetIndex = currentIndex + 1
//        }
//        
//        // 第一页往右滑动
//        if self.interceptRightSlideGuetureInFirstPage, targetIndex < 0 {
//            return false
//        }
//        
//        // 最后一页往左滑动
//        if self.interceptLeftSlideGuetureInLastPage {
//            let numberOfPage = Int(self.h_contentSize.width / self.frame.size.width)
//            if targetIndex >= numberOfPage {
//                return false
//            }
//        }
//        
//        // 其他情况
//        if let delegate = self.h_delegate {
//            let selector = #selector(delegate.scrollView(_:shouldScrollToPageIndex:))
//            if delegate.responds(to: selector) {
//                return delegate.scrollView!(self, shouldScrollToPageIndex: targetIndex)
//            }
//        }
//        
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if contentOffset.x <= 0 {
//            return true
//        } else {
//            return false
//        }
//    }
//}
