//
//  HTabItem.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/29.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/**
 *  Badge样式
 */
enum HTabItemBadgeStyle: Int {
    case number = 0 // 数字样式
    case dot = 1 // 小圆点
}

class HTabItem : UIButton {
    
    private var badgeButton: UIButton = UIButton(type: .custom)
    private var doubleTapView: UIView?
    private var verticalOffset: CGFloat = 0.0
    private var spacing: CGFloat = 0.0
    
    private var numberBadgeMarginTop: CGFloat = 0.0
    private var numberBadgeCenterMarginRight: CGFloat = 0.0
    private var numberBadgeTitleHorizonalSpace: CGFloat = 0.0
    private var numberBadgeTitleVerticalSpace: CGFloat = 0.0
    
    private var dotBadgeMarginTop: CGFloat = 0.0
    private var dotBadgeCenterMarginRight: CGFloat = 0.0
    private var dotBadgeSideLength: CGFloat = 0.0
    
    private typealias HDoubleTapHandler = () -> Void

    /**
     *  item在tabBar中的index，此属性不能手动设置
     */
    var index: Int = 0

    private var _frameWithOutTransform: CGRect = CGRect.zero
    /**
     *  用于记录tabItem在缩放前的frame，
     *  在HTabBar的属性itemFontChangeFollowContentScroll == YES时会用到
     */
    var frameWithOutTransform: CGRect {
        return _frameWithOutTransform
    }
    
    private var _title: String?
    /// Title
    var title: String? {
        get {
            return _title
        }
        set {
            _title = newValue
            self.setTitle(newValue, for: .normal)
            self.calculateTitleWidth()
        }
    }

    private var _titleColor: UIColor?
    var titleColor: UIColor? {
        get {
            return _titleColor
        }
        set {
            _titleColor = newValue
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    private var _titleSelectedColor: UIColor?
    var titleSelectedColor: UIColor? {
        get {
            return _titleSelectedColor
        }
        set {
            _titleSelectedColor = newValue
            self.setTitleColor(newValue, for: .selected)
        }
    }

    private var _titleFont: UIFont?
    var titleFont: UIFont? {
        get {
            return _titleFont
        }
        set {
            _titleFont = newValue
            if #available(iOS 8.0, *) {
                self.titleLabel?.font = newValue
            }
            self.calculateTitleWidth()
        }
    }
    
    private var _image: UIImage?
    /// Image
    override var image: UIImage? {
        get {
            return _image
        }
        set {
            _image = newValue
            self.setImage(newValue, for: .normal)
        }
    }

    private var _selectedImage: UIImage?
    var selectedImage: UIImage? {
        get {
            return _selectedImage
        }
        set {
            _selectedImage = newValue
            self.setImage(newValue, for: .selected)
        }
    }
    
    private var _titleWidth: CGFloat = 0
    var titleWidth: CGFloat {
        return _titleWidth
    }

    private var _indicatorInsets: UIEdgeInsets = UIEdgeInsetsZero
    /// indicator
    var indicatorInsets: UIEdgeInsets {
        get {
            return _indicatorInsets
        }
        set {
            _indicatorInsets = newValue
            self.calculateIndicatorFrame()
        }
    }
    
    private var _indicatorFrame: CGRect = CGRect.zero
    var indicatorFrame: CGRect {
        return _indicatorFrame
    }
    
    private var _badge: Int = 0
    /**
    *  当badgeStyle == HTabItemBadgeStyleNumber时，可以设置此属性，显示badge数值
    *  badge > 99，显示99+
    *  badge <= 99 && badge > -99，显示具体数值
    *  badge < -99，显示-99+
    */
    var badge: Int {
        get {
            return _badge
        }
        set {
            _badge = newValue
            self.updateBadge()
        }
    }

    private var _badgeStyle: HTabItemBadgeStyle = .number
    /**
    *  badge的样式，支持数字样式和小圆点
    */
    var badgeStyle: HTabItemBadgeStyle {
        get {
            return _badgeStyle
        }
        set {
            _badgeStyle = newValue
            self.updateBadge()
        }
    }
    
    private var _badgeBackgroundColor: UIColor?
    /**
    *  badge的背景颜色
    */
    var badgeBackgroundColor: UIColor? {
        get {
            return _badgeBackgroundColor
        }
        set {
            _badgeBackgroundColor = newValue
            self.badgeButton.backgroundColor = badgeBackgroundColor
        }
    }
    
    private var _badgeBackgroundImage: UIImage?
    /**
    *  badge的背景图片
    */
    var badgeBackgroundImage: UIImage? {
        get {
            return _badgeBackgroundImage
        }
        set {
            _badgeBackgroundImage = newValue
            self.badgeButton.setBackgroundImage(newValue, for: .normal)
        }
    }

    private var _badgeTitleColor: UIColor?
    /**
    *  badge的标题颜色
    */
    var badgeTitleColor: UIColor? {
        get {
            return _badgeTitleColor
        }
        set {
            _badgeTitleColor = newValue
            self.badgeButton.setTitleColor(newValue, for: .normal)
        }
    }

    

    private var _badgeTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    /**
    *  badge的标题字体，默认13号
    */
    var badgeTitleFont: UIFont {
        get {
            return _badgeTitleFont
        }
        set {
            _badgeTitleFont = newValue
            self.badgeButton.titleLabel?.font = newValue
            self.updateBadge()
        }
    }
    
    private var _isContentHorizontalCenter: Bool = false
    /**
    *  设置Image和Title水平居中
    */
    var isContentHorizontalCenter: Bool {
        get {
            return _isContentHorizontalCenter
        }
        set {
            _isContentHorizontalCenter = newValue
            if _isContentHorizontalCenter == false {
                self.verticalOffset = 0
                self.spacing = 0
            }
            if self.superview != nil {
                self.layoutSubviews()
            }
        }
    }
    
    /**
    *  设置Image和Title水平居中
    *
    *  @param verticalOffset   竖直方向的偏移量
    *  @param spacing          Image与Title的间距
    */
    func setContentHorizontalCenterWithVerticalOffset(_ verticalOffset: CGFloat, spacing: CGFloat) {
        self.verticalOffset = verticalOffset
        self.spacing = spacing
        self.isContentHorizontalCenter = true
    }
    
    private var _doubleTapHandler: HDoubleTapHandler?
    /**
    *  添加双击事件回调
    */
    private var doubleTapHandler: HDoubleTapHandler? {
        get {
            return _doubleTapHandler
        }
        set {
            _doubleTapHandler = newValue
            if self.doubleTapView == nil {
                self.doubleTapView = UIView(frame: self.bounds)
                self.addSubview(self.doubleTapView!)
                let doubleRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
                doubleRecognizer.numberOfTapsRequired = 2
                self.doubleTapView!.addGestureRecognizer(doubleRecognizer)
            }
        }
    }

    @objc
    private func doubleTapped(_ recognizer: UITapGestureRecognizer) {
        if self.doubleTapHandler != nil {
            self.doubleTapHandler!()
        }
    }
    
    /**
    *  设置数字Badge的位置
    *
    *  @param marginTop            与TabItem顶部的距离
    *  @param centerMarginRight    中心与TabItem右侧的距离
    *  @param titleHorizonalSpace  标题水平方向的空间
    *  @param titleVerticalSpace   标题竖直方向的空间
    */
    func setNumberBadgeMarginTop(_ marginTop: CGFloat, centerMarginRight: CGFloat, titleHorizonalSpace: CGFloat, titleVerticalSpace: CGFloat) {
        self.numberBadgeMarginTop = marginTop
        self.numberBadgeCenterMarginRight = centerMarginRight
        self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace
        self.numberBadgeTitleVerticalSpace = titleVerticalSpace
        self.updateBadge()
    }
    
    /**
    *  设置小圆点Badge的位置
    *
    *  @param marginTop            与TabItem顶部的距离
    *  @param centerMarginRight    中心与TabItem右侧的距离
    *  @param sideLength           小圆点的边长
    */
    func setDotBadgeMarginTop(_ marginTop: CGFloat, centerMarginRight: CGFloat, sideLength: CGFloat) {
        self.dotBadgeMarginTop = marginTop
        self.dotBadgeCenterMarginRight = centerMarginRight
        self.dotBadgeSideLength = sideLength
        self.updateBadge()
    }
    
    required init() {
        super.init(frame: CGRect.zero)
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
        self.badgeButton.isUserInteractionEnabled = false
        self.badgeButton.clipsToBounds = true
        self.addSubview(self.badgeButton)
        self.adjustsImageWhenHighlighted = false
    }

    /**
     *  覆盖父类的setHighlighted:方法，按下HTabItem时，不高亮该item
     */
    override var isHighlighted: Bool {
        get {
            super.isHighlighted
        }
        set {
            if self.adjustsImageWhenHighlighted {
                super.isHighlighted = newValue
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.image(for: .normal) != nil && self.isContentHorizontalCenter {
            var titleSize: CGSize = self.titleLabel?.frame.size ?? CGSize.zero
            let imageSize: CGSize = self.imageView?.frame.size ?? CGSize.zero
            titleSize = CGSize(width: CGFloat(ceilf(Float(titleSize.width))), height: CGFloat(ceilf(Float(titleSize.height))))
            let totalHeight: CGFloat = (imageSize.height + titleSize.height + self.spacing)
            self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height - self.verticalOffset), left: 0, bottom: 0, right: -titleSize.width)
            self.titleEdgeInsets = UIEdgeInsets(top: self.verticalOffset, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0)
        }else {
            self.imageEdgeInsets = UIEdgeInsets.zero
            self.titleEdgeInsets = UIEdgeInsets.zero
        }
    }

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            if self.doubleTapView != nil {
                self.doubleTapView!.isHidden = !newValue
            }
        }
    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            _frameWithOutTransform = frame
            if newValue != CGRect.zero {
                if self.doubleTapView != nil {
                    self.doubleTapView!.frame = self.bounds
                }
                self.updateBadge()
                self.calculateIndicatorFrame()
            }
        }
    }

    private func calculateTitleWidth() {
        if self.title == nil || self.title!.isEmpty || self.titleFont == nil {
            _titleWidth = 0
            return
        }
        let tmpTitle: NSString = self.title! as NSString
        let size = tmpTitle.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                        attributes: [.font : self.titleFont!],
                                        context: nil).size
        _titleWidth = CGFloat(ceilf(Float(size.width)))
    }

    private func calculateIndicatorFrame() {
        let frame: CGRect = self.frameWithOutTransform
        let insets: UIEdgeInsets = self.indicatorInsets
        _indicatorFrame = CGRect(x: frame.origin.x + insets.left,
                                 y: frame.origin.y + insets.top,
                                 width: frame.size.width - insets.left - insets.right,
                                 height: frame.size.height - insets.top - insets.bottom)
    }

    private func updateBadge() {
        if self.badgeStyle == .number {
            if self.badge == 0 {
                self.badgeButton.isHidden = true
            } else {
                var badgeStr: String = "\(self.badge)"
                if self.badge > 99 {
                    badgeStr = "99+"
                } else if self.badge < -99 {
                    badgeStr = "-99+"
                }
                
                // 计算badgeStr的size
                let tmpBadgeStr: NSString = badgeStr as NSString
                let size = tmpBadgeStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                attributes: [.font : self.badgeButton.titleLabel!.font as Any],
                                                context: nil).size
                // 计算badgeButton的宽度和高度
                var width: CGFloat = CGFloat(ceilf(Float(size.width))) + self.numberBadgeTitleHorizonalSpace
                let height: CGFloat = CGFloat(ceilf(Float(size.height))) + self.numberBadgeTitleVerticalSpace
                
                // 宽度取width和height的较大值，使badge为个位数时，badgeButton为圆形
                width = max(width, height)
                
                // 设置badgeButton的frame
                self.badgeButton.frame = CGRect(x: self.bounds.size.width - width / 2 - self.numberBadgeCenterMarginRight,
                                                y: self.numberBadgeMarginTop,
                                                width: width,
                                                height: height)
                self.badgeButton.layer.cornerRadius = self.badgeButton.bounds.size.height / 2
                self.badgeButton.setTitle(badgeStr, for: .normal)
                self.badgeButton.isHidden = false
            }
        } else if self.badgeStyle == .dot {
            self.badgeButton.setTitle(nil, for: .normal)
            self.badgeButton.frame = CGRect(x: self.bounds.size.width - self.dotBadgeCenterMarginRight - self.dotBadgeSideLength,
                                            y: self.dotBadgeMarginTop,
                                            width: self.dotBadgeSideLength,
                                            height: self.dotBadgeSideLength)
            self.badgeButton.layer.cornerRadius = self.badgeButton.bounds.size.height / 2
            self.badgeButton.isHidden = false
        }
    }

}
