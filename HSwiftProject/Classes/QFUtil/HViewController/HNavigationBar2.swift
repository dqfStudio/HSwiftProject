//
//  HNavigationBar2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/10.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HNavigationBar2: UIStackView, HTupleViewDelegate {

    // Spacing between left and right buttons of the navigation bar and the screen
    private var edgeSpace: CGFloat = UIScreen.width > 414 ? 20.0 : 16.0
    // Spacing between left button and middle title of the navigation bar
    private var titleSpace: CGFloat = 5.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.tupleView.delegate = self
        self.addArrangedSubview(self.tupleView)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Navigation bar
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.backgroundColor = .clear
        tupleView.isScrollEnabled = false
        tupleView.tupleStatus = .block
        tupleView.disableBounce()
        return tupleView
    }()

    // Left button of the navigation bar
    lazy var leftItem: HNavigationItem2 = {
        let buttonView = HNavigationItem2(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .left
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = .black
        buttonView.refreshBlock = {
            self.tupleView.reloadTupleData()
        }
        buttonView.addTarget(self, action: #selector(leftItemPressed))
        return buttonView
    }()
    
    private var leftItemWidth: CGFloat {
        return max(self.leftItem.intrinsicContentSize.width, 44)
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
    lazy var rightItem: HNavigationItem2 = {
        let buttonView = HNavigationItem2(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .right
        buttonView.backgroundColor = UIColor.clear
        buttonView.textColor = .black
        buttonView.refreshBlock = {
            self.tupleView.reloadTupleData()
        }
        buttonView.addTarget(self, action: #selector(rightItemPressed))
        return buttonView
    }()
    
    private var rightItemWidth: CGFloat {
        return max(self.rightItem.intrinsicContentSize.width, 44)
    }

    @objc
    private func rightItemPressed() {
        rightItem.pressedBlock?()
    }
    
    deinit {
        self.leftItem.refreshBlock = nil
        self.leftItem.pressedBlock = nil
        
        self.rightItem.refreshBlock = nil
        self.rightItem.pressedBlock = nil

        self.tupleView.releaseTupleBlock()
    }

}

extension HNavigationBar2 {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 5
    }
    
    func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any {
        return UIScreen.statusBarHeight
    }
    
//    func minimumFooterSpacingForSectionAt(_ section: Any) -> Any {
//        return UIScreen.onePixel
//    }
    
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        //let naviBarHeight = UIScreen.naviBarHeight - UIScreen.onePixel
        let naviBarHeight = UIScreen.naviBarHeight
        switch indexPath.row {
        case 0:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.sizeBlock = {
                let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
                return CGSize(width: itemWidth, height: naviBarHeight)
            }
            cell.cellBlock = {
                if self.leftItem.superview == nil {
                    cell.layoutView.addSubview(self.leftItem)
                }
                // Reset frame
                var frame = CGRect(origin: .zero, size: cell.sizeBlock!())
                frame.width = self.leftItemWidth
                self.leftItem.frame = frame
            }
            break
        case 1:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.sizeBlock = {
                return CGSize(width: self.titleSpace, height: naviBarHeight)
            }
            break
        case 2:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.sizeBlock = {
                let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
                var titleWidth = self.width - self.edgeSpace * 2 - self.titleSpace * 2 - itemWidth * 2
                titleWidth = max(titleWidth, 1)
                return CGSize(width: titleWidth, height: naviBarHeight)
            }
            cell.cellBlock = {
                if self.titleItem.superview == nil {
                    cell.layoutView.addSubview(self.titleItem)
                }
                // Reset frame
                self.titleItem.frame = CGRect(origin: .zero, size: cell.sizeBlock!())
            }
            break
        case 3:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.sizeBlock = {
                return CGSize(width: self.titleSpace, height: naviBarHeight)
            }
            break
        case 4:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.sizeBlock = {
                let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
                return CGSize(width: itemWidth, height: naviBarHeight)
            }
            cell.cellBlock = {
                if self.rightItem.superview == nil {
                    cell.layoutView.addSubview(self.rightItem)
                }
                // Reset frame
                var frame = CGRect(origin: .zero, size: cell.sizeBlock!())
                frame.x = frame.width - self.rightItemWidth
                frame.width = self.rightItemWidth
                self.rightItem.frame = frame
            }
            break
        default:
            break
        }

    }

}


// This is a custom UIButton class that is used as a navigation item
// It has two blocks that can be set to be executed when the button is pressed or hidden
// It also has a disableColor property that can be set to change the background color when the button is disabled

typealias HNavigationItemBlock2 = () -> Void

// This is a custom UIButton class that is used as a navigation item
class HNavigationItem2: UIButton {
    // It has two blocks that can be set to be executed when the button is pressed or hidden
    var refreshBlock: HNavigationItemBlock2?
    var pressedBlock: HNavigationItemBlock2?

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
