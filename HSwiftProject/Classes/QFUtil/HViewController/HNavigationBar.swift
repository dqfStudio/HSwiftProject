//
//  HNavigationBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/10.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HNavigationBar: UIStackView, HTupleViewDelegate {

    // Spacing between left and right buttons of the navigation bar and the screen
    private var edgeSpace: CGFloat = UIScreen.width > 414 ? 20.0 : 16.0
    // Spacing between left button and middle title of the navigation bar
    private var titleSpace: CGFloat = 5.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.tupleView.delegate = self
        self.addArrangedSubview(self.tupleView)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Navigation bar
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.tupleFrame {
            return .zero
        } mode: {
            return .block
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        tupleView.backgroundColor = .clear
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()

    // Left button of the navigation bar
    lazy var leftItem: HNavigationItem = {
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .left
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = UIColor.black
        buttonView.refreshBlock = {
            self.tupleView.reloadTupleData()
        }
        buttonView.addTarget(self, action: #selector(leftItemPressed))
        return buttonView
    }()
    
    // Left button width of the navigation bar
    private var leftItemWidth: CGFloat {
        // Round up and compare size with 44
        return max(ceil(self.leftItem.intrinsicContentSize.width), 44)
    }

    @objc
    private func leftItemPressed() {
        leftItem.pressedBlock?()
    }


    // Middle title of the navigation bar
    lazy var titleItem: UILabel = {
        let labelView = UILabel(frame: .zero)
        labelView.font = UIFont.font(ofSize: 17, weight: .medium)
        labelView.textColor = UIColor.black
        labelView.textAlignment = .center
        return labelView
    }()
    

    // Right button of the navigation bar
    lazy var rightItem: HNavigationItem = {
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .right
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = UIColor.black
        buttonView.refreshBlock = {
            self.tupleView.reloadTupleData()
        }
        buttonView.addTarget(self, action: #selector(rightItemPressed))
        return buttonView
    }()
    
    // Right button width of the navigation bar
    private var rightItemWidth: CGFloat {
        // Round up and compare size with 44
        return max(ceil(self.rightItem.intrinsicContentSize.width), 44)
    }

    @objc
    private func rightItemPressed() {
        rightItem.pressedBlock?()
    }
    
    // Navigation bottom line bar background color
    var lineBarColor: UIColor = .clear {
        didSet {
            if lineBarColor != oldValue {
                self.setBottomLine(withColor: lineBarColor)
            }
        }
    }
    
    // Hidden method
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            if super.isHidden != newValue {
                super.isHidden = newValue
                if !newValue {
                    self.tupleView.reloadTupleData()
                }
            }
        }
    }
    
    deinit {
        self.leftItem.refreshBlock = nil
        self.leftItem.pressedBlock = nil
        
        self.rightItem.refreshBlock = nil
        self.rightItem.pressedBlock = nil

        self.tupleView.releaseTupleBlock()
    }

}

extension HNavigationBar {
    
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: UIScreen.statusBarHeight, left: edgeSpace, bottom: 0, right: edgeSpace)
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 5
    }
    
    func attributeForItemAtIndexPath(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //左边返回按钮
            let attribute = tuple.attribute(HTupleLayoutCell.self, nil, true, indexPath)
            let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
            attribute.size = CGSize(width: itemWidth, height: UIScreen.naviBarHeight)
            attribute.cellBlock = { (tuple, baseCell) in
                let cell = baseCell as! HTupleLayoutCell
                if self.leftItem.superview == nil {
                    cell.layoutView.addSubview(self.leftItem)
                }
                // Reset frame
                var frame = cell.layoutViewBounds
                frame.width = self.leftItemWidth
                self.leftItem.frame = frame
            }
        case 1: //左边间隔
            let attribute = tuple.attribute(HTupleBaseCell.self, nil, true, indexPath)
            attribute.size = CGSize(width: self.titleSpace, height: UIScreen.naviBarHeight)
        case 2: //中间标题按钮
            let attribute = tuple.attribute(HTupleLayoutCell.self, nil, true, indexPath)
            let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
            var titleWidth = self.width - self.edgeSpace * 2 - self.titleSpace * 2 - itemWidth * 2
            titleWidth = max(titleWidth, 1)
            attribute.size = CGSize(width: titleWidth, height: UIScreen.naviBarHeight)
            attribute.cellBlock = { (tuple, baseCell) in
                let cell = baseCell as! HTupleLayoutCell
                if self.titleItem.superview == nil {
                    cell.layoutView.addSubview(self.titleItem)
                }
                // Reset frame
                self.titleItem.frame = cell.layoutViewBounds
            }
        case 3: //右边间隔
            let attribute = tuple.attribute(HTupleBaseCell.self, nil, true, indexPath)
            attribute.size = CGSize(width: self.titleSpace, height: UIScreen.naviBarHeight)
        case 4: //右边按钮
            let attribute = tuple.attribute(HTupleLayoutCell.self, nil, true, indexPath)
            let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
            attribute.size = CGSize(width: itemWidth, height: UIScreen.naviBarHeight)
            attribute.cellBlock = { (tuple, baseCell) in
                let cell = baseCell as! HTupleLayoutCell
                if self.rightItem.superview == nil {
                    cell.layoutView.addSubview(self.rightItem)
                }
                // Reset frame
                var frame = cell.layoutViewBounds
                frame.x = frame.width - self.rightItemWidth
                frame.width = self.rightItemWidth
                self.rightItem.frame = frame
            }
        default:
            break
        }
    }

}


// This is a custom UIButton class that is used as a navigation item
// It has two blocks that can be set to be executed when the button is pressed or hidden
// It also has a disableColor property that can be set to change the background color when the button is disabled

typealias HNavigationItemBlock = () -> Void

// This is a custom UIButton class that is used as a navigation item
class HNavigationItem: UIButton {
    // It has two blocks that can be set to be executed when the button is pressed or hidden
    var refreshBlock: HNavigationItemBlock?
    var pressedBlock: HNavigationItemBlock?

    // It also has a disableColor property that can be set to change the background color when the button is disabled
    var disableColor: UIColor?

    var title: String? {
        get { return self.title(for: .normal) }
        set {
            self.setTitle(newValue, for: .normal)
            self.setTitle(newValue, for: .highlighted)
            self.setImage(nil, for: .normal)
            self.setImage(nil, for: .highlighted)
        }
    }

    override var image: UIImage? {
        get { return self.image(for: .normal) }
        set {
            self.setTitle(nil, for: .normal)
            self.setTitle(nil, for: .highlighted)
            self.setImage(newValue, for: .normal)
            self.setImage(newValue, for: .highlighted)
        }
    }

    // If the button is disabled, change the background color to the disableColor property
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? backgroundColor : disableColor ?? backgroundColor
            isUserInteractionEnabled = isEnabled
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        refreshBlock?()
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        refreshBlock?()
    }

}
