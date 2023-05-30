//
//  HTabBar.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/29.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum HTabBarIndicatorAnimationStyle: Int {
    case `default` = 0
    case style1 = 1
}

@objc protocol HTabBarDelegate : NSObjectProtocol {

    /**
     *  是否能切换到指定index
     */
    @objc
    optional func h_tabBar(_ tabBar: HTabBar, shouldSelectItemAtIndex index: Int) -> Bool

    /**
     *  将要切换到指定index
     */
    @objc
    optional func h_tabBar(_ tabBar: HTabBar, willSelectItemAtIndex index: Int)

    /**
     *  已经切换到指定index
     */
    @objc
    optional func h_tabBar(_ tabBar: HTabBar, didSelectedItemAtIndex index: Int)

    /**
     *  重复点击到指定index
     */
    @objc
    optional func h_tabBar(_ tabBar: HTabBar, reSelectedTabAtIndex index: Int)

}

typealias HTabbardSelectedBlock = (_ idx: Int) -> Void

class HTabBar : UIView {
    
    private enum HTabBarIndicatorStyle : Int {
        case fitItem
        case fitTitle
        case fixedWidth
    }

    private let BADGE_BG_COLOR_DEFAULT = UIColor(red: 252 / 255.0, green: 15 / 255.0, blue: 29 / 255.0, alpha: 1.0)

    private var _scrollViewLastOffsetX: CGFloat = 0.0

    // 当TabBar支持滚动时，使用此scrollView
    private var scrollView: UIScrollView = UIScrollView()

    private var specialItem: HTabItem?
    
    private typealias HSpecialItemHandler = (_ item: HTabItem) -> Void
    private var specialItemHandler: HSpecialItemHandler?

    // 选中背景
    private var indicatorImageView: UIImageView = UIImageView(frame: CGRect.zero)

    // 选中背景相对于HTabItem的insets
    private var indicatorInsets: UIEdgeInsets = UIEdgeInsets.zero
    private var indicatorStyle: HTabBarIndicatorStyle = .fitItem
    private var indicatorWidthFixTitleAdditional: CGFloat = 0.0
    private var indicatorWidth: CGFloat = 0.0

    // TabItem选中切换时，是否显示动画
    private var indicatorSwitchAnimated: Bool = false

    // Item是否匹配title的文字宽度
    private var itemFitTextWidth: Bool = false

    // 当Item匹配title的文字宽度时，左右留出的空隙，item的宽度 = 文字宽度 + spacing
    private var itemFitTextWidthSpacing: CGFloat = 0.0

    // item的宽度
    private var itemWidth: CGFloat = 0.0
    private var itemHeight: CGFloat = 0.0
    private var itemMinWidth: CGFloat = 0.0

    // item的内容水平居中时，image与顶部的距离
    private var itemContentHorizontalCenterVerticalOffset: CGFloat = 0.0

    // item的内容水平居中时，title与image的距离
    private var itemContentHorizontalCenterSpacing: CGFloat = 0.0

    // 数字样式的badge相关属性
    private var numberBadgeMarginTop: CGFloat = 2.0
    private var numberBadgeCenterMarginRight: CGFloat = 30.0
    private var numberBadgeTitleHorizonalSpace: CGFloat = 8.0
    private var numberBadgeTitleVerticalSpace: CGFloat = 2.0

    // 小圆点样式的badge相关属性
    private var dotBadgeMarginTop: CGFloat = 5.0
    private var dotBadgeCenterMarginRight: CGFloat = 25.0
    private var dotBadgeSideLength: CGFloat = 10.0

    // 分割线相关属性
    private var separatorLayers: NSMutableArray?
    private var itemSeparatorColor: UIColor?
    private var itemSeparatorThickness: CGFloat = 0.0
    private var itemSeparatorLeading: CGFloat = 0.0
    private var itemSeparatorTrailing: CGFloat = 0.0
    
    private var isVertical: Bool = false
    

    private var _items: [HTabItem]?
    /**
    *  TabItems，提供给HTabBarController使用，一般不手动设置此属性
    */
    var items: [HTabItem]? {
        get {
            return _items
        }
        set {
            selectedItemIndex = NSNotFound
            
            // 将老的item从superview上删除
            if _items != nil {
                for item in _items! {
                    item.removeFromSuperview()
                }
            }
            _items = newValue
            
            // 初始化每一个item
            for item in _items! {
                
                item.titleColor = self.itemTitleColor
                item.titleSelectedColor = self.itemTitleSelectedColor
                item.titleFont = self.itemTitleFont
                
                item.setContentHorizontalCenterWithVerticalOffset(5, spacing: 5)
                
                item.badgeTitleFont = self.badgeTitleFont
                item.badgeTitleColor = self.badgeTitleColor
                item.badgeBackgroundColor = self.badgeBackgroundColor
                item.badgeBackgroundImage = self.badgeBackgroundImage
                
                item.setNumberBadgeMarginTop(self.numberBadgeMarginTop,
                                             centerMarginRight: self.numberBadgeCenterMarginRight,
                                             titleHorizonalSpace: self.numberBadgeTitleHorizonalSpace,
                                             titleVerticalSpace: self.numberBadgeTitleVerticalSpace)

                item.setDotBadgeMarginTop(self.dotBadgeMarginTop,
                                          centerMarginRight: self.dotBadgeCenterMarginRight,
                                          sideLength: self.dotBadgeSideLength)

                item.addTarget(self, action: #selector(tabItemClicked(_:)), for: .touchUpInside)
                self.scrollView.addSubview(item)
            
                // 更新item的大小缩放
                self.updateItemsScaleIfNeeded()
                self.updateAllUI()
            }
        }
    }

    /// item指示器颜色
    var indicatorColor: UIColor? {
        didSet {
            indicatorImageView.backgroundColor = indicatorColor
        }
    }
    
    /// item指示器图像
    var indicatorImage: UIImage? {
        didSet {
            indicatorImageView.image = indicatorImage
        }
    }
    
    /// item指示器圆角
    var indicatorCornerRadius: CGFloat = 0.0 {
        didSet {
            indicatorImageView.clipsToBounds = true
            indicatorImageView.layer.cornerRadius = indicatorCornerRadius
        }
    }
    
    var indicatorAnimationStyle: HTabBarIndicatorAnimationStyle = .default

    /// 标题颜色
    var itemTitleColor: UIColor = .white {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.titleColor = itemTitleColor
                }
            }
        }
    }
    
    /// 选中时标题的颜色
    var itemTitleSelectedColor: UIColor = .black {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.titleSelectedColor = itemTitleSelectedColor
                }
            }
        }
    }
    
    private var _itemTitleFont: UIFont = UIFont.systemFont(ofSize: 10)
    /// 标题字体
    var itemTitleFont: UIFont {
        get {
            return _itemTitleFont
        }
        set {
            _itemTitleFont = newValue
            if self.isItemFontChangeFollowContentScroll {
                // item字体支持平滑切换，更新每个item的scale
                self.updateItemsScaleIfNeeded()
            } else {
                // item字体不支持平滑切换，更新item的字体
                if self.itemTitleSelectedFont != nil {
                    // 设置了选中字体，则只更新未选中的item
                    for item in self.items! {
                        if item.isSelected == false {
                            item.titleFont = newValue
                        }
                    }
                } else {
                    // 未设置选中字体，更新所有item
                    if self.items != nil && self.items!.count > 0 {
                        for item in self.items! {
                            item.titleFont = newValue
                        }
                    }
                }
            }
            if self.itemFitTextWidth {
                // 如果item的宽度是匹配文字的，更新item的位置
                self.updateItemsFrame()
            }
            self.updateIndicatorFrameWithIndex(self.selectedItemIndex)
        }
    }
    
    /// 选中时标题的字体
    var itemTitleSelectedFont: UIFont? {
        didSet {
            selectedItem?.titleFont = itemTitleSelectedFont
            updateItemsScaleIfNeeded()
        }
    }
    
    /// Badge背景颜色
    var badgeBackgroundColor: UIColor? {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.badgeBackgroundColor = badgeBackgroundColor
                }
            }
        }
    }
    
    /// Badge背景图像
    var badgeBackgroundImage: UIImage? {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.badgeBackgroundImage = badgeBackgroundImage
                }
            }
        }
    }
    
    /// Badge标题颜色
    var badgeTitleColor: UIColor = .white {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.badgeTitleColor = badgeTitleColor
                }
            }
        }
    }
    
    /// Badge标题字体
    var badgeTitleFont: UIFont = .systemFont(ofSize: 10) {
        didSet {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.badgeTitleFont = badgeTitleFont
                }
            }
        }
    }
    
    /// 第一个item与左边或者上边的距离
    var leadingSpace: CGFloat = 0.0 {
        didSet {
            updateAllUI()
        }
    }
    
    /// 最后一个item与右边或者下边的距离
    var trailingSpace: CGFloat = 0.0 {
        didSet {
            updateAllUI()
        }
    }
    
    private var _selectedItemIndex: Int = NSNotFound
    /// 选中某一个item
    var selectedItemIndex: Int {
        get {
            return _selectedItemIndex
        }
        set {
            if newValue == _selectedItemIndex ||
                newValue >= self.items!.count ||
                self.items!.count == 0 {
                if newValue == _selectedItemIndex {
                    let selector = #selector(self.delegate!.h_tabBar(_:reSelectedTabAtIndex:))
                    if self.delegate != nil && self.delegate!.responds(to: selector) {
                        self.delegate?.h_tabBar!(self, reSelectedTabAtIndex: newValue)
                    }
                }
                return
            }
            
            let selector = #selector(self.delegate!.h_tabBar(_:shouldSelectItemAtIndex:))
            if self.delegate != nil && self.delegate!.responds(to: selector) {
                let should: Bool = self.delegate!.h_tabBar!(self, shouldSelectItemAtIndex: newValue)
                if !should {
                    return
                }
            }
            
            let selector2 = #selector(self.delegate!.h_tabBar(_:willSelectItemAtIndex:))
            if self.delegate != nil && self.delegate!.responds(to: selector2) {
                self.delegate!.h_tabBar!(self, willSelectItemAtIndex: newValue)
            }
            
            if _selectedItemIndex != NSNotFound {
                let oldSelectedItem = self.items![_selectedItemIndex]
                oldSelectedItem.isSelected = false
                if self.isItemFontChangeFollowContentScroll {
                    // 如果支持字体平滑渐变切换，则设置item的scale
                    oldSelectedItem.transform = CGAffineTransform(scaleX: self.itemTitleUnselectedFontScale,
                                                                  y: self.itemTitleUnselectedFontScale)
                } else {
                    // 如果支持字体平滑渐变切换，则直接设置字体
                    oldSelectedItem.titleFont = self.itemTitleFont
                }
            }
            
            let newSelectedItem = self.items![newValue]
            newSelectedItem.isSelected = true
            if self.isItemFontChangeFollowContentScroll {
                // 如果支持字体平滑渐变切换，则设置item的scale
                newSelectedItem.transform = CGAffineTransform(scaleX: 1, y: 1)
            } else {
                // 如果支持字体平滑渐变切换，则直接设置字体
                if self.itemTitleSelectedFont != nil {
                    newSelectedItem.titleFont = self.itemTitleSelectedFont
                }
            }
            
            if self.indicatorSwitchAnimated && _selectedItemIndex != NSNotFound {
                UIView.animate(withDuration: 0.25) {
                    self.updateIndicatorFrameWithIndex(newValue)
                }
            } else {
                self.updateIndicatorFrameWithIndex(newValue)
            }
            
            _selectedItemIndex = newValue
            
            // 如果tabbar支持滚动，将选中的item放到tabbar的中央
            self.setSelectedItemCenter()
            
            let selector3 = #selector(self.delegate!.h_tabBar(_:didSelectedItemAtIndex:))
            if self.delegate != nil && self.delegate!.responds(to: selector3) {
                self.delegate!.h_tabBar?(self, didSelectedItemAtIndex: newValue)
            }
            if self.tabbardSelectedBlock != nil {
                self.tabbardSelectedBlock!(newValue)
            }
        }
    }
    
    var tabbardSelectedBlock: HTabbardSelectedBlock?

    private var _isItemColorChangeFollowContentScroll: Bool = true
    /**
    *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为true
    */
    var isItemColorChangeFollowContentScroll: Bool {
        return _isItemColorChangeFollowContentScroll
    }

    /**
    *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
    */
    var isItemFontChangeFollowContentScroll: Bool = false {
        didSet {
            updateItemsScaleIfNeeded()
        }
    }

    /**
    *  TabItem的选中背景是否随contentView滑动而移动
    */
    var isIndicatorScrollFollowContent: Bool = false

    /**
    *  将Image和Title设置为水平居中，默认为true
    */
    var isItemContentHorizontalCenter: Bool = true {
        didSet {
            if isItemContentHorizontalCenter {
                self.setItemContentHorizontalCenterWithVerticalOffset(5, spacing:5)
            } else {
                self.itemContentHorizontalCenterVerticalOffset = 0
                self.itemContentHorizontalCenterSpacing = 0
                for item in self.items! {
                    item.isContentHorizontalCenter = false
                }
            }
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        self._setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self._setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self._setup()
    }

    private func _setup() {
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true

        badgeBackgroundColor = BADGE_BG_COLOR_DEFAULT
        
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        scrollView.addSubview(indicatorImageView)
    }

    override var clipsToBounds: Bool {
        get { return super.clipsToBounds }
        set {
            super.clipsToBounds = newValue
            self.scrollView.clipsToBounds = newValue
        }
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            var resize: Bool = false
            if newValue.size != super.frame.size { resize = true }
            super.frame = newValue
            if resize {
                self.scrollView.frame = self.bounds
                self.updateAllUI()
            }
        }
    }
    
    weak var delegate: HTabBarDelegate?
    
    /**
    *  返回已选中的item
    */
    var selectedItem: HTabItem? {
        if self.selectedItemIndex != NSNotFound {
            return self.items?[self.selectedItemIndex] as? HTabItem
        }
        return nil
    }

    /**
    *  根据titles创建item
    */
    var titles: [String]? {
        didSet {
            var items = [HTabItem]()
            for title in titles! {
                let item = HTabItem()
                item.title = title
                items.append(item)
            }
            self.items = items
        }
    }

    private func updateAllUI() {
        self.updateItemsFrame()
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrameWithIndex(self.selectedItemIndex)
        self.updateSeperators()
    }

    private func updateItemsFrame() {
        
        if self.items == nil || self.items!.count == 0 {
            return
        }
        
        if self.isVertical {
            // 支持滚动
            var y: CGFloat = self.leadingSpace
            if !self.scrollView.isScrollEnabled {
                self.itemHeight = CGFloat(ceilf(Float((self.frame.size.height - self.leadingSpace - self.trailingSpace) / CGFloat(self.items!.count))))
            }
            for index in 0..<self.items!.count {
                let item = self.items![index]
                item.frame = CGRect(x: 0, y: y, width: self.frame.size.width, height: self.itemHeight)
                item.index = index
                y += self.itemHeight
            }
            self.scrollView.h_contentSize = CGSize(width: self.scrollView.frame.size.width, height: max(y + self.trailingSpace, self.scrollView.frame.size.height))
        } else {
            if self.scrollView.isScrollEnabled {
                // 支持滚动
                var x: CGFloat = self.leadingSpace
                for index in 0..<self.items!.count {
                    let item = self.items![index]
                    var width: CGFloat = 0
                    // item的宽度为一个固定值
                    if self.itemWidth > 0 {
                        width = self.itemWidth
                    }
                    // item的宽度为根据字体大小和spacing进行适配
                    if self.itemFitTextWidth {
                        width = max(item.titleWidth + self.itemFitTextWidthSpacing, self.itemMinWidth)
                    }
                    item.frame = CGRect(x: x, y: 0, width: width, height: self.frame.size.height)
                    item.index = index
                    x += width
                }
                self.scrollView.h_contentSize = CGSize(width: max(x + self.trailingSpace, self.scrollView.frame.size.width),
                                                       height: self.scrollView.frame.size.height)
            } else {
                // 不支持滚动
                
                var x: CGFloat = self.leadingSpace
                let allItemsWidth: CGFloat = self.frame.size.width - self.leadingSpace - self.trailingSpace
                if self.specialItem != nil && self.specialItem!.frame.size.width != 0 {
                    self.itemWidth = (allItemsWidth - self.specialItem!.frame.size.width) / CGFloat(self.items!.count)
                } else {
                    self.itemWidth = allItemsWidth / CGFloat(self.items!.count)
                }
                
                // 四舍五入，取整，防止字体模糊
                self.itemWidth = CGFloat(floorf(Float(self.itemWidth + 0.5)))
                
                for index in 0..<self.items!.count {
                    let item = self.items![index]
                    item.frame = CGRect(x: x, y: 0, width: self.itemWidth, height: self.frame.size.height)
                    item.index = index
                    
                    x += self.itemWidth
                    
                    // 如果有特殊的单独item，设置其位置
                    if self.specialItem != nil && self.specialItem!.index == index {
                        var width: CGFloat = self.specialItem!.frame.size.width
                        // 如果宽度为0，将其宽度设置为itemWidth
                        if width == 0 {
                            width = self.itemWidth
                        }
                        var height: CGFloat = self.specialItem!.frame.size.height
                        // 如果高度为0，将其宽度设置为tabBar的高度
                        if height == 0 {
                            height = self.frame.size.height
                        }
                        self.specialItem!.frame = CGRect(x: x, y: self.frame.size.height - height, width: width, height: height)
                        x += width
                    }
                }
                self.scrollView.h_contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
            }
        }
    }

    /**
     *  更新选中背景的frame
     */
    private func updateIndicatorFrameWithIndex(_ index: Int) {
        if self.items?.count == 0 || index == NSNotFound {
            self.indicatorImageView.frame = CGRect.zero
            return
        }
        if let items = self.items {
            let item = items[index]
            self.indicatorImageView.frame = item.indicatorFrame
        }
    }
    
    /**
    *  设置tabBar为竖向且支持滚动，tabItem的高度根据tabBar高度和leadingSpace、trailingSpace属性计算
    *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
    */
    func layoutTabItemsVertical() {
        self.isVertical = true
        if self.items?.count == 0 {
            return
        }
        self.updateAllUI()
    }
    
    /**
    *  设置tabBar为竖向且支持滚动，一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
    *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
    *
    *  @param height 单个tabItem的高度
    */
    func layoutTabItemsVerticalWithItemHeight(_ height: CGFloat) {
        self.isVertical = true
        if self.items?.count == 0 {
            return
        }
        self.scrollView.isScrollEnabled = true
        self.itemHeight = height
        self.updateAllUI()
    }
    
    /**
    *  设置tabItem的选中背景，这个背景可以是一个横条。
    *  此方法与setIndicatorWidthFixTextWithTop方法互斥，后调用者生效
    *
    *  @param insets       选中背景的insets
    *  @param animated     点击item进行背景切换的时候，是否支持动画
    */
    func setIndicatorInsets(_ insets: UIEdgeInsets, tapSwitchAnimated animated: Bool) {
        self.indicatorStyle = .fitItem
        self.indicatorSwitchAnimated = animated
        self.indicatorInsets = insets
        
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrameWithIndex(self.selectedItemIndex)
    }
    
    /**
    *  设置指示器的宽度根据title宽度来匹配
    *  此方法与setIndicatorInsets方法互斥，后调用者生效
    
    *  @param top 指示器与tabItem顶部的距离
    *  @param bottom 指示器与tabItem底部的距离
    *  @param additional 指示器与文字宽度匹配后额外增加或减少的长度，0表示相等，正数表示较长，负数表示较短
    *  @param animated 点击item进行背景切换的时候，是否支持动画
    */
    func setIndicatorWidthFitTextAndMarginTop(_ top: CGFloat, marginBottom bottom: CGFloat, widthAdditional additional: CGFloat, tapSwitchAnimated animated: Bool) {
        self.indicatorStyle = .fitTitle
        self.indicatorSwitchAnimated = animated
        self.indicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        self.indicatorWidthFixTitleAdditional = additional
        
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrameWithIndex(self.selectedItemIndex)
    }
    
    /**
    *  设置指示器固定宽度
    
    *  @param width 指示器宽度，如果kua
    *  @param top 指示器与tabItem顶部的距离
    *  @param bottom 指示器与tabItem底部的距离
    *  @param animated 点击item进行背景切换的时候，是否支持动画
    */
    func setIndicatorWidth(_ width: CGFloat, marginTop top: CGFloat, marginBottom bottom: CGFloat, tapSwitchAnimated animated: Bool) {
        self.indicatorStyle = .fixedWidth
        self.indicatorSwitchAnimated = animated
        self.indicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        self.indicatorWidth = width
        
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrameWithIndex(self.selectedItemIndex)
    }

    /**
    *  设置tabBar可以左右滑动
    *  此方法与setScrollEnabledAndItemFitTextWidthWithSpacing这个方法是两种模式，哪个后调用哪个生效
    *
    *  @param width 每个tabItem的宽度
    */
    func setScrollEnabledAndItemWidth(_ width: CGFloat) {
        self.scrollView.isScrollEnabled = true
        self.itemWidth = width
        self.itemFitTextWidth = false
        self.itemFitTextWidthSpacing = 0
        self.itemMinWidth = 0
        self.updateItemsFrame()
    }

    func setScrollEnabledAndItemFitTextWidthWithSpacing(_ spacing: CGFloat) {
        self.setScrollEnabledAndItemFitTextWidthWithSpacing(spacing, minWidth: 0)
    }

    /**
    *  设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
    *  此方法与setScrollEnabledAndItemWidth这个方法是两种模式，哪个后调用哪个生效
    *
    *  @param spacing item的宽度 = 文字宽度 + spacing
    *  @param minWidth item的最小宽度
    */
    func setScrollEnabledAndItemFitTextWidthWithSpacing(_ spacing: CGFloat, minWidth: CGFloat) {
        self.scrollView.isScrollEnabled = true
        self.itemFitTextWidth = true
        self.itemFitTextWidthSpacing = spacing
        self.itemWidth = 0
        self.itemMinWidth = minWidth
        self.updateItemsFrame()
    }
    
    /**
    *  将tabItem的image和title设置为居中，并且调整其在竖直方向的位置
    *
    *  @param verticalOffset  竖直方向的偏移量
    *  @param spacing         image和title的距离
    */
    func setItemContentHorizontalCenterWithVerticalOffset(_ verticalOffset: CGFloat, spacing: CGFloat) {
        isItemContentHorizontalCenter = true
        self.itemContentHorizontalCenterVerticalOffset = verticalOffset
        self.itemContentHorizontalCenterSpacing = spacing
        for item in self.items! {
            item.setContentHorizontalCenterWithVerticalOffset(verticalOffset, spacing: spacing)
        }
    }
    
    /**
    *  设置数字Badge的位置与大小。
    *  默认marginTop = 2，centerMarginRight = 30，titleHorizonalSpace = 8，titleVerticalSpace = 2。
    *
    *  @param marginTop            与TabItem顶部的距离，默认为：2
    *  @param centerMarginRight    中心与TabItem右侧的距离，默认为：30
    *  @param titleHorizonalSpace  标题水平方向的空间，默认为：8
    *  @param titleVerticalSpace   标题竖直方向的空间，默认为：2
    */
    func setNumberBadgeMarginTop(_ marginTop: CGFloat, centerMarginRight: CGFloat, titleHorizonalSpace: CGFloat, titleVerticalSpace: CGFloat) {
        self.numberBadgeMarginTop = marginTop
        self.numberBadgeCenterMarginRight = centerMarginRight
        self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace
        self.numberBadgeTitleVerticalSpace = titleVerticalSpace
        
        for item in self.items! {
            item.setNumberBadgeMarginTop(marginTop, centerMarginRight: centerMarginRight, titleHorizonalSpace: titleHorizonalSpace, titleVerticalSpace: titleVerticalSpace)
        }
    }
    
    /**
    *  设置小圆点Badge的位置与大小。
    *  默认marginTop = 5，centerMarginRight = 25，sideLength = 10。
    *
    *  @param marginTop            与TabItem顶部的距离，默认为：5
    *  @param centerMarginRight    中心与TabItem右侧的距离，默认为：25
    *  @param sideLength           小圆点的边长，默认为：10
    */
    func setDotBadgeMarginTop(_ marginTop: CGFloat, centerMarginRight: CGFloat, sideLength: CGFloat) {
        self.dotBadgeMarginTop = marginTop
        self.dotBadgeCenterMarginRight = centerMarginRight
        self.dotBadgeSideLength = sideLength
        
        for item in self.items! {
            item.setDotBadgeMarginTop(marginTop, centerMarginRight: centerMarginRight, sideLength: sideLength)
        }
    }
    
    /**
    *  设置分割线
    *
    *  @param itemSeparatorColor   分割线颜色
    *  @param thickness            分割线的粗细
    *  @param leading              与tabBar顶部或者左侧的距离
    *  @param trailing             与tabBar底部或者右侧距离
    */
    func setItemSeparatorColor(_ itemSeparatorColor: UIColor, thickness: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.itemSeparatorColor = itemSeparatorColor
        self.itemSeparatorThickness = thickness
        self.itemSeparatorLeading = leading
        self.itemSeparatorTrailing = trailing
        self.updateSeperators()
    }

    func setItemSeparatorColor(_ itemSeparatorColor: UIColor, leading: CGFloat, trailing: CGFloat) {
        var onePixel: CGFloat = 0.0
        if UIScreen.main.responds(to: #selector(getter: UIScreen.main.nativeScale)) {
            onePixel = 1.0 / UIScreen.main.nativeScale
        }else {
            onePixel = 1.0 / UIScreen.main.scale
        }
        self.setItemSeparatorColor(itemSeparatorColor, thickness: onePixel, leading: leading, trailing: trailing)
    }
    
    /**
    *  添加一个特殊的HTabItem到tabBar上，此TabItem不包含在tabBar的items数组里
    *  主要用于有的项目需要在tabBar的中间放置一个单独的按钮，类似于新浪微博等。
    *  此方法仅适用于不可滚动类型的tabBar
    *
    *  @param item    HTabItem对象
    *  @param index   将其放在此index的item后面
    *  @param handler 点击事件回调
    */
    func setSpecialItem(_ item: HTabItem, afterItemWithIndex index: Int, tapHandler handler: @escaping (_ item: HTabItem) -> Void) {
        self.specialItem = item
        self.specialItem?.index = index
        self.specialItem?.addTarget(self, action: #selector(specialItemClicked(_:)), for: .touchUpInside)
        self.scrollView.addSubview(item)
        self.updateItemsFrame()
        
        self.specialItemHandler = handler
        self.clipsToBounds = false
    }
    
    /**
    *  当HTabBar所属的HTabBarController内容视图支持拖动切换时，
    *  此方法用于同步内容视图scrollView拖动的偏移量，以此来改变HTabBar内控件的状态
    */
    func updateSubViewsWhenParentScrollViewScroll(_ scrollView: UIScrollView) {

        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.size.width
        
        let leftIndex: Int = Int(offsetX / scrollViewWidth)
        let rightIndex: Int = leftIndex + 1
        
        let leftItem = self.items![leftIndex]
        if rightIndex >= self.items!.count { return }
        let rightItem: HTabItem = self.items![rightIndex]
        
        // 计算右边按钮偏移量
        var rightScale: CGFloat = offsetX / scrollViewWidth
        // 只想要 0~1
        rightScale = rightScale - CGFloat(leftIndex)
        let leftScale: CGFloat = 1 - rightScale
        
        if self.isItemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0 {
            // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
            
            // 计算字体大小的差值
            let diff: CGFloat = self.itemTitleUnselectedFontScale - 1
            // 根据偏移量和差值，计算缩放值
            leftItem.transform = CGAffineTransform(scaleX: rightScale * diff + 1, y: rightScale * diff + 1)
            rightItem.transform = CGAffineTransform(scaleX: leftScale * diff + 1, y: leftScale * diff + 1)
        }
        
        if self.isItemColorChangeFollowContentScroll {
            var normalRed: CGFloat  = 0.0
            var normalGreen: CGFloat = 0.0
            var normalBlue: CGFloat = 0.0
            var normalAlpha: CGFloat = 0.0
            
            var selectedRed: CGFloat  = 0.0
            var selectedGreen: CGFloat = 0.0
            var selectedBlue: CGFloat = 0.0
            var selectedAlpha: CGFloat = 0.0
            
            self.itemTitleColor.getRed(&normalRed, green: &normalGreen, blue: &normalBlue, alpha: &normalAlpha)
            self.itemTitleSelectedColor.getRed(&selectedRed, green: &selectedGreen, blue: &selectedBlue, alpha: &selectedAlpha)

            // 获取选中和未选中状态的颜色差值
            let redDiff: CGFloat = selectedRed - normalRed
            let greenDiff: CGFloat = selectedGreen - normalGreen
            let blueDiff: CGFloat = selectedBlue - normalBlue
            let alphaDiff: CGFloat = selectedAlpha - normalAlpha
            // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
            leftItem.titleLabel?.textColor = UIColor(red: leftScale * redDiff + normalRed,
                                                     green: leftScale * greenDiff + normalGreen,
                                                     blue: leftScale * blueDiff + normalBlue,
                                                     alpha: leftScale * alphaDiff + normalAlpha)
            rightItem.titleLabel?.textColor = UIColor(red: rightScale * redDiff + normalRed,
                                                     green: rightScale * greenDiff + normalGreen,
                                                     blue: rightScale * blueDiff + normalBlue,
                                                     alpha: rightScale * alphaDiff + normalAlpha)
        }
        
        // 计算背景的frame
        if self.isIndicatorScrollFollowContent {
            
            if self.indicatorAnimationStyle == .default {
                var frame: CGRect = self.indicatorImageView.frame
                let xDiff: CGFloat = rightItem.indicatorFrame.origin.x - leftItem.indicatorFrame.origin.x
                
                frame.origin.x = rightScale * xDiff + leftItem.indicatorFrame.origin.x
                
                let widthDiff: CGFloat = rightItem.indicatorFrame.size.width - leftItem.indicatorFrame.size.width
                frame.size.width = rightScale * widthDiff + leftItem.indicatorFrame.size.width
                
                self.indicatorImageView.frame = frame
            } else if self.indicatorAnimationStyle == .style1 {
                let page: Int = Int(offsetX / scrollViewWidth)
                
                var currentIndex: Int = 0
                var targetIndex: Int = 0
                
                var scale: CGFloat = offsetX / scrollViewWidth - CGFloat(page)
                if _scrollViewLastOffsetX < offsetX {
                    currentIndex = page
                    targetIndex = page + 1
                    scale = scale * 2
                } else if _scrollViewLastOffsetX > offsetX {
                    currentIndex = page + 1
                    targetIndex = page
                    scale = (1 - scale) * 2
                } else {
                    return
                }
                if targetIndex >= self.items!.count {
                    return
                }
                
                let currentItem = self.items![currentIndex]
                let targetItem = self.items![targetIndex]
                
                let currentItemWidth: CGFloat = currentItem.frameWithOutTransform.size.width
                let targetItemWidth: CGFloat = targetItem.frameWithOutTransform.size.width
                
                // 设置滑动过程中，指示器的位置
                if targetIndex > currentIndex {
                    if scale < 1 {
                        let addition: CGFloat = scale * (targetItem.indicatorFrame.maxX - currentItem.indicatorFrame.maxX)
                        // 小于半个屏幕距离
                        self.setIndicatorX(currentItem.indicatorFrame.origin.x,
                                           width: addition + currentItem.indicatorFrame.size.width)
                    } else if scale > 1 {
                        // 大于等于半个屏幕距离
                        scale = scale - 1
                        let addition: CGFloat = scale * (targetItem.indicatorFrame.origin.x - currentItem.indicatorFrame.origin.x)
                        self.setIndicatorX(currentItem.indicatorFrame.origin.x + addition,
                                           width: targetItemWidth + currentItemWidth - addition - currentItem.indicatorInsets.left - targetItem.indicatorInsets.right)
                    }
                } else {
                    if scale < 1 {
                        let addition: CGFloat = scale * (currentItem.indicatorFrame.origin.x - targetItem.indicatorFrame.origin.x)
                        self.setIndicatorX(currentItem.indicatorFrame.origin.x - addition,
                                           width: addition + currentItem.indicatorFrame.size.width)
                    } else if scale > 1 {
                        scale = scale - 1
                        let addition: CGFloat = (1 - scale) * (currentItem.indicatorFrame.maxX - targetItem.indicatorFrame.maxX)
                        self.setIndicatorX(targetItem.indicatorFrame.origin.x,
                                           width: targetItem.indicatorFrame.size.width + addition)
                    }
                }
            }
        }
        _scrollViewLastOffsetX = offsetX
    }

    private func setSelectedItemCenter() {

        if !self.scrollView.isScrollEnabled || self.isVertical {
            return
        }
        // 修改偏移量
        var offsetX: CGFloat = (self.selectedItem?.center.x)! - self.scrollView.frame.size.width * 0.5
        
        // 处理最小滚动偏移量
        if offsetX < 0 {
            offsetX = 0
        }
        
        // 处理最大滚动偏移量
        let maxOffsetX: CGFloat = self.scrollView.h_contentSize.width - self.scrollView.frame.size.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    /**
     *  获取未选中字体与选中字体大小的比例
     */
    private var itemTitleUnselectedFontScale: CGFloat {
        if let itemTitleSelectedFont = self.itemTitleSelectedFont {
            return itemTitleFont.pointSize / itemTitleSelectedFont.pointSize
        }
        return 1.0
    }

    @objc
    private func tabItemClicked(_ item: HTabItem) {
        self.selectedItemIndex = item.index
    }

    @objc
    private func specialItemClicked(_ item: HTabItem) {
        if let specialItemHandler = self.specialItemHandler {
            specialItemHandler(item)
        }
    }

    private func updateItemIndicatorInsets() {
        
        if self.items == nil || self.items!.count == 0 {
            return
        }
        
        for tmpItem in self.items! {
            let item = tmpItem
            if self.indicatorStyle == .fitTitle {
                let frame: CGRect = item.frameWithOutTransform
                let space: CGFloat = (frame.size.width - item.titleWidth - self.indicatorWidthFixTitleAdditional) / 2
                item.indicatorInsets = UIEdgeInsets(top: self.indicatorInsets.top, left: space, bottom: self.indicatorInsets.bottom, right: space)
            } else if self.indicatorStyle == .fixedWidth {
                for tmpItem in self.items! {
                    let item = tmpItem
                    let frame: CGRect = item.frameWithOutTransform
                    let space:CGFloat = (frame.size.width - self.indicatorWidth) / 2
                    item.indicatorInsets = UIEdgeInsets(top: self.indicatorInsets.top, left: space, bottom: self.indicatorInsets.bottom, right: space)
                }
            } else if self.indicatorStyle == .fitItem {
                for tmpItem in self.items! {
                    let item = tmpItem
                    item.indicatorInsets = self.indicatorInsets
                }
            }
        }
    }

    private func updateItemsScaleIfNeeded() {
        if self.itemTitleSelectedFont != nil &&
            self.isItemFontChangeFollowContentScroll &&
            self.itemTitleSelectedFont?.pointSize != self.itemTitleFont.pointSize {
            if let items = self.items, items.count > 0 {
                for item in items {
                    item.titleFont = self.itemTitleSelectedFont
                    if item.isSelected == false {
                        item.transform = CGAffineTransform(scaleX: self.itemTitleUnselectedFontScale, y: self.itemTitleUnselectedFontScale)
                    }
                }
            }
        }
    }

    private func updateSeperators() {
        if self.itemSeparatorColor != nil {
            if self.separatorLayers == nil {
                self.separatorLayers = NSMutableArray()
            }
            if self.separatorLayers!.count > 0 {
                for item in self.separatorLayers! {
                    let layer = item as! CALayer
                    layer.removeFromSuperlayer()
                }
                self.separatorLayers!.removeAllObjects()
            }
            if let items = self.items, items.count > 0 {
                for item in items {
                    let layer: CALayer = CALayer()
                    layer.backgroundColor = self.itemSeparatorColor!.cgColor
                    if self.isVertical {
                        layer.frame = CGRect(x: self.itemSeparatorLeading,
                                             y: item.frame.origin.y - self.itemSeparatorThickness / 2,
                                             width: self.bounds.size.width - self.itemSeparatorLeading - self.itemSeparatorTrailing,
                                             height: self.itemSeparatorThickness)
                    } else {
                        layer.frame = CGRect(x: item.frame.origin.x - self.itemSeparatorThickness / 2,
                                             y: self.itemSeparatorLeading,
                                             width: self.itemSeparatorThickness,
                                             height: self.bounds.size.height - self.itemSeparatorLeading - self.itemSeparatorTrailing)
                    }
                    self.scrollView.layer.addSublayer(layer)
                    self.separatorLayers!.add(layer)
                }
            }
        } else {
            if self.separatorLayers != nil && self.separatorLayers!.count > 0 {
                for item in self.separatorLayers! {
                    let view = item as! UIView
                    view.removeFromSuperview()
                }
                self.separatorLayers!.removeAllObjects()
            }
            self.separatorLayers = nil
        }
    }

    // 设置指示器的frame
    private func setIndicatorX(_ x: CGFloat, width: CGFloat) {
        var frame: CGRect = self.indicatorImageView.frame
        frame.origin.x = x
        frame.size.width = width
        self.indicatorImageView.frame = frame
    }
    
    /// 让specialItem超出父视图的部分能响应事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if let specialItem = self.specialItem, view == nil {
            let tp = specialItem.convert(point, from: self)
            if specialItem.bounds.contains(tp) {
                view = specialItem
            }
        }
        return view
    }

}

