//
//  HNavigationBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/2.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

@objc protocol HNavigationBarProtocol: NSObjectProtocol {
    @objc
    func navigationBarLeftItemPressed(_ leftItem: UIButton?)
    @objc
    func navigationBarRightItemPressed(_ rightItem: UIButton?)
}

class HNavigationBar: UIView, HTupleViewDelegate {
    
    // Spacing between left and right buttons of the navigation bar and the screen
    var edgeSpace: CGFloat = 10.0
    // Spacing between left button and middle title of the navigation bar
    var titleSpace: CGFloat = 10.0


    // Width of the left button of the navigation bar
    var leftItemWidth: CGFloat = 50.0
    // Width of the right button of the navigation bar
    var rightItemWidth: CGFloat = 50.0

    // Navigation bar delegate
    var delegate: HNavigationBarProtocol?


    // Left button of the navigation bar
    lazy var leftItem: UIButton = {
        let buttonView = UIButton(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .medium)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .left
        buttonView.backgroundColor = UIColor.clear
        buttonView.addTarget(self, action: #selector(leftItemPressed))
        return buttonView
    }()
    
    // Middle title of the navigation bar
    lazy var titleItem: UILabel = {
        let labelView = UILabel(frame: .zero)
        labelView.font = UIFont.font(ofSize: 16, weight: .medium)
        labelView.textColor = UIColor.black
        labelView.textAlignment = .center
        return labelView
    }()
    
    // Right button of the navigation bar
    lazy var rightItem: UIButton = {
        let buttonView = UIButton(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .medium)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .right
        buttonView.backgroundColor = UIColor.clear
        buttonView.isHidden = true
        buttonView.addTarget(self, action: #selector(rightItemPressed))
        return buttonView
    }()
    

    // Color of the spacing line of the navigation bar
    var lineBarColor: UIColor = UIColor(hex: 0xe5e5e5) {
        didSet {
            if lineBarColor != oldValue {
                self.tupleView.reloadTupleData()
            }
        }
    }
    // Whether the spacing line of the navigation bar is hidden
    var isLineBarHidden: Bool = true {
        didSet {
            if isLineBarHidden != oldValue {
                self.tupleView.reloadTupleData()
            }
        }
    }
    
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.backgroundColor = UIColor.clear
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            guard newValue != super.frame else { return }
            super.frame = newValue
            self.tupleView.frame = newValue
        }
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    // Left button click event of the navigation bar
    @objc
    private func leftItemPressed() {
        self.delegate?.navigationBarLeftItemPressed(leftItem)
    }

    // Right button click event of the navigation bar
    @objc
    private func rightItemPressed() {
        self.delegate?.navigationBarRightItemPressed(rightItem)
    }
    
}

extension HNavigationBar {
    
    func numberOfSectionsInTupleView() -> Any {
        return 3
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        switch (section as! Int) {
        case 0: return 1 // Status bar
        case 1: return 7 // Navigation bar
        case 2: return 1 // Separator line
        default:break
        }
        return 1
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.section {
        case 0: // Status bar
            return CGSize(width: self.tupleView.width, height: UIScreen.statusBarHeight)
        case 1: // Navigation bar
            let naviBarHeight = UIScreen.naviBarHeight - 1
            let itemWidth = max(leftItemWidth, rightItemWidth)
            switch (indexPath.row) {
            case 0: return CGSize(width: edgeSpace, height: naviBarHeight)
            case 1: return CGSize(width: itemWidth, height: naviBarHeight)
            case 2: return CGSize(width: titleSpace, height: naviBarHeight)
            case 3:
                var titleWidth = self.tupleView.width - edgeSpace * 2 - titleSpace * 2 - itemWidth * 2
                titleWidth = max(titleWidth, 1)
                return CGSize(width: titleWidth, height: naviBarHeight)
            case 4: return CGSize(width: titleSpace, height: naviBarHeight)
            case 5: return CGSize(width: itemWidth, height: naviBarHeight)
            case 6: return CGSize(width: edgeSpace, height: naviBarHeight)
            default:break
            }
        case 2: // Separator line
            return CGSize(width: self.tupleView.width, height: 1)
        default:
            break
        }
        return CGSize.zero
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        switch indexPath.section {
        case 0: // Status bar
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = UIColor.clear
        case 1: // Navigation bar
            switch indexPath.row {
            case 0:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                break
            case 1:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                if self.leftItem.superview == nil {
                    cell.addSubview(self.leftItem)
                }
                // Reset frame
                var frame = cell.layoutViewBounds
                frame.width = leftItemWidth
                self.leftItem.frame = frame
                break
            case 2:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                break
            case 3:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                if self.titleItem.superview == nil {
                    cell.addSubview(self.titleItem)
                }
                // Reset frame
                self.titleItem.frame = cell.layoutViewBounds
                break
            case 4:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                break
            case 5:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                if self.rightItem.superview == nil {
                    cell.addSubview(self.rightItem)
                }
                // Reset frame
                var frame = cell.layoutViewBounds
                frame.x = frame.width - rightItemWidth
                frame.width = rightItemWidth
                self.rightItem.frame = frame
                break
            case 6:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor.clear
                break
            default:
                break
            }
        case 2: // Separator line
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = isLineBarHidden ? UIColor.clear : lineBarColor
        default:
            break
        }
        
    }
    
}
