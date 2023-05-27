//
//  HNavigationBar2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/10.
//  Copyright © 2023 wind. All rights reserved.
//

//import UIKit
//
//class HNavigationBar: UIStackView, HTupleViewDelegate {
//
//    // Spacing between left and right buttons of the navigation bar and the screen
//    var edgeSpace: CGFloat = 16.0
//    // Spacing between left button and middle title of the navigation bar
//    var titleSpace: CGFloat = 5.0
//
//
//    // Width of the left button of the navigation bar
//    var leftItemWidth: CGFloat = 60.0
//    // Width of the right button of the navigation bar
//    var rightItemWidth: CGFloat = 60.0
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    @available(*, unavailable)
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override var frame: CGRect {
//        get { return super.frame }
//        set {
//            guard newValue != super.frame else { return }
//            super.frame = newValue
//            self.navigationBar.frame = super.bounds
//        }
//    }
//
//    // Status bar
//    lazy var statusBar: UIView = {
//        return UIView()
//    }()
//
//    // Navigation bar
//    private lazy var navigationBar: HTupleView = {
//        let tupleView = HTupleView(frame: .zero)
//        tupleView.backgroundColor = UIColor.clear
//        tupleView.isScrollEnabled = false
//        tupleView.tupleStatus = .block
//        tupleView.disableBounce()
//        return tupleView
//    }()
//
//    // Separator line
//    lazy var lineBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hex: 0xe5e5e5)
//        view.isHidden = true
//        return view
//    }()
//
//    // Left button of the navigation bar
//    lazy var leftItem: HNavigationItem = {
//        let buttonView = HNavigationItem(frame: .zero)
//        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
//        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
//        buttonView.imageView?.contentMode = .scaleAspectFit
//        buttonView.contentHorizontalAlignment = .left
//        buttonView.backgroundColor = UIColor.clear
//        buttonView.textColor = .black
//        buttonView.addTarget(self, action: #selector(leftItemPressed))
//        return buttonView
//    }()
//
//    @objc
//    private func leftItemPressed() {
//        leftItem.pressedBlock?()
//    }
//
//
//    // Middle title of the navigation bar
//    lazy var titleItem: UILabel = {
//        let labelView = UILabel(frame: .zero)
//        labelView.font = UIFont.font(ofSize: 17, weight: .medium)
//        labelView.textColor = UIColor.black
//        labelView.textAlignment = .center
//        return labelView
//    }()
//
//    // Right button of the navigation bar
//    lazy var rightItem: HNavigationItem = {
//        let buttonView = HNavigationItem(frame: .zero)
//        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
//        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
//        buttonView.imageView?.contentMode = .scaleAspectFit
//        buttonView.contentHorizontalAlignment = .right
//        buttonView.backgroundColor = UIColor.clear
//        buttonView.textColor = .black
//        buttonView.isHidden = true
//        buttonView.addTarget(self, action: #selector(rightItemPressed))
//        return buttonView
//    }()
//
//    @objc
//    private func rightItemPressed() {
//        rightItem.pressedBlock?()
//    }
//
//    private func setup() {
//        self.backgroundColor = .white
//        self.navigationBar.delegate = self
//        self.addSubview(self.navigationBar)
//    }
//
//    func reloadData() {
//        self.navigationBar.reloadTupleData()
//    }
//
//}
//
//extension HNavigationBar {
//
//    func numberOfSectionsInTupleView() -> Any {
//        return 3
//    }
//
//    func numberOfItemsInSection(_ section: Any) -> Any {
//        switch (section as! Int) {
//        case 0: return 1 // Status bar
//        case 1: return 7 // Navigation bar
//        case 2: return 1 // Separator line
//        default:break
//        }
//        return 1
//    }
//
//    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
//        let itemBlock = itemBlock as! HTupleItem
//        switch indexPath.section {
//        case 0: // Status bar
//            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//            cell.backgroundColor = UIColor.clear
//            cell.sizeBlock = {
//                return CGSize(width: self.width, height: UIScreen.statusBarHeight)
//            }
//            cell.cellBlock = {
//                if self.statusBar.superview == nil {
//                    cell.layoutView.addSubview(self.statusBar)
//                }
//                self.statusBar.frame = cell.layoutViewBounds
//            }
//        case 1: // Navigation bar
//            let naviBarHeight = UIScreen.naviBarHeight - UIScreen.onePixel
//            switch indexPath.row {
//            case 0:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    return CGSize(width: self.edgeSpace, height: naviBarHeight)
//                }
//                break
//            case 1:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
//                    return CGSize(width: itemWidth, height: naviBarHeight)
//                }
//                cell.cellBlock = {
//                    if self.leftItem.superview == nil {
//                        cell.layoutView.addSubview(self.leftItem)
//                    }
//                    // Reset frame
//                    var frame = cell.layoutViewBounds
//                    frame.width = self.leftItemWidth
//                    self.leftItem.frame = frame
//                }
//                break
//            case 2:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    return CGSize(width: self.titleSpace, height: naviBarHeight)
//                }
//                break
//            case 3:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
//                    var titleWidth = self.width - self.edgeSpace * 2 - self.titleSpace * 2 - itemWidth * 2
//                    titleWidth = max(titleWidth, 1)
//                    return CGSize(width: titleWidth, height: naviBarHeight)
//                }
//                cell.cellBlock = {
//                    if self.titleItem.superview == nil {
//                        cell.layoutView.addSubview(self.titleItem)
//                    }
//                    // Reset frame
//                    self.titleItem.frame = cell.layoutViewBounds
//                }
//                break
//            case 4:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    return CGSize(width: self.titleSpace, height: naviBarHeight)
//                }
//                break
//            case 5:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    let itemWidth = max(self.leftItemWidth, self.rightItemWidth)
//                    return CGSize(width: itemWidth, height: naviBarHeight)
//                }
//                cell.cellBlock = {
//                    if self.rightItem.superview == nil {
//                        cell.layoutView.addSubview(self.rightItem)
//                    }
//                    // Reset frame
//                    var frame = cell.layoutViewBounds
//                    frame.x = frame.width - self.rightItemWidth
//                    frame.width = self.rightItemWidth
//                    self.rightItem.frame = frame
//                }
//                break
//            case 6:
//                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//                cell.backgroundColor = UIColor.clear
//                cell.sizeBlock = {
//                    return CGSize(width: self.edgeSpace, height: naviBarHeight)
//                }
//                break
//            default:
//                break
//            }
//        case 2: // Separator line
//            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
//            cell.sizeBlock = {
//                return CGSize(width: self.width, height: UIScreen.onePixel)
//            }
//            cell.cellBlock = {
//                if self.lineBar.superview == nil {
//                    cell.layoutView.addSubview(self.lineBar)
//                }
//                self.statusBar.frame = cell.layoutViewBounds
//            }
//        default:
//            break
//        }
//
//    }
//
//}
//
//
//// This is a custom UIButton class that is used as a navigation item
//// It has two blocks that can be set to be executed when the button is pressed or hidden
//// It also has a disableColor property that can be set to change the background color when the button is disabled
//
//typealias HNavigationItemBlock = () -> Void
//
//// This is a custom UIButton class that is used as a navigation item
//class HNavigationItem: UIButton {
//    // It has two blocks that can be set to be executed when the button is pressed or hidden
////    var hiddenBlock: HNavigationItemBlock?
//    var pressedBlock: HNavigationItemBlock?
//
//    // It also has a disableColor property that can be set to change the background color when the button is disabled
//    var disableColor: UIColor?
//
//    var title: String? {
//        get { return self.title(for: .normal) }
//        set {
//            self.setTitle(newValue, for: .normal)
//            self.setTitle(newValue, for: .highlighted)
//            self.setImage(nil, for: .normal)
//            self.setImage(nil, for: .highlighted)
//        }
//    }
//
//    override var image: UIImage? {
//        get { return self.image(for: .normal) }
//        set {
//            self.setTitle(nil, for: .normal)
//            self.setTitle(nil, for: .highlighted)
//            self.setImage(newValue, for: .normal)
//            self.setImage(newValue, for: .highlighted)
//        }
//    }
//
//    // If the button is disabled, change the background color to the disableColor property
//    override var isEnabled: Bool {
//        didSet {
//            backgroundColor = isEnabled ? backgroundColor : disableColor ?? backgroundColor
//            isUserInteractionEnabled = isEnabled
//        }
//    }
//
//}
