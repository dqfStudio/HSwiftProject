//
//  HScrollbar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/15.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HScrollbarBlock = (_ index: Int) -> Void

// A custom UIStackView that displays a horizontal list of items with a selected item indicator
class HScrollbar: UIStackView, HTupleViewDelegate {
    
    // A lazy-loaded HTupleView instance
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero, scrollDirection: .horizontal)
        tupleView.tupleStatus = .block
        return tupleView
    }()
    
    // Indicator bar
    private lazy var indicatorBar: UIView = {
        let originX = abs(indicatorBarWidth - itemWidth) / 2
        return UIView(frame: CGRect(x: originX, y: self.height - indicatorBarHeight, width: indicatorBarWidth, height: indicatorBarHeight))
    }()
    
    // Indicator bar color
    var indicatorBarColor: UIColor = .red {
        didSet {
            indicatorBar.backgroundColor = indicatorBarColor
        }
    }
    
    // Indicator bar width
    private var _indicatorBarWidth: CGFloat = 100.0
    var indicatorBarWidth: CGFloat {
        get {
            return _indicatorBarWidth
        }
        set {
            if _indicatorBarWidth != newValue {
                _indicatorBarWidth = min(newValue, itemWidth)
                let originX = abs(_indicatorBarWidth - itemWidth) / 2
                let frame = CGRect(x: originX, y: self.height - indicatorBarHeight, width: _indicatorBarWidth, height: indicatorBarHeight)
                indicatorBar.frame = frame
            }
        }
    }
    
    // Indicator bar height
    var indicatorBarHeight: CGFloat = 3.0 {
        didSet {
            if indicatorBarHeight != oldValue {
                let originX = abs(indicatorBarWidth - itemWidth) / 2
                let frame = CGRect(x: originX, y: self.height - indicatorBarHeight, width: indicatorBarWidth, height: indicatorBarHeight)
                indicatorBar.frame = frame
            }
        }
    }
    
    // The index of the currently selected item
    var selectedIndex: Int = 0 {
        didSet {
            let originX = abs(indicatorBarWidth - itemWidth) / 2
            indicatorBar.x = originX + itemWidth * CGFloat(selectedIndex)
        }
    }
    
    // Define a variable to hold the selected block in the scrollbar
    var selectedBlock: HScrollbarBlock?
    
    // An array of strings representing the items to be displayed
    var items: [String]?
    
    // Item width
    var itemWidth: CGFloat = 100.0 {
        didSet {
            indicatorBarWidth = itemWidth
        }
    }
    
    // The font and color of the unselected item titles
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var titleColor: UIColor = .black
    var titleBGColor: UIColor = .white
    
    // The font and color of the selected item title
    var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 14)
    var titleSelectedColor: UIColor = .black
    var titleSelectedBGColor: UIColor = .white
    
    override var backgroundColor: UIColor? {
        get { return nil }
        set { _ = newValue }
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            tupleView.isScrollEnabled = isScrollEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set the stack view properties
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        
        // Set the delegate of the tuple view to self and add it as a subview
        tupleView.delegate = self
        self.addArrangedSubview(tupleView)
        
        // Add indicatorBar
        indicatorBar.backgroundColor = indicatorBarColor
        tupleView.addSubview(indicatorBar)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Returns the number of items in the section
    func numberOfItemsInSection(_ section: Any) -> Any {
        return items?.count ?? 0
    }

    // Configures the tuple item at the specified index path
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.sizeBlock = {
            return CGSize(width: self.itemWidth, height: self.height)
        }
        cell.cellBlock = {
            let bounds = cell.layoutViewBounds
            let labelFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - self.indicatorBarHeight)
            
            let item = self.items?[indexPath.row]
            cell.label.frame = labelFrame
            cell.label.textAlignment = .center
            cell.label.text = item
            
            // Set the font and color of the title based on whether it is selected or not
            if self.selectedIndex == indexPath.row {
                cell.label.font = self.titleSelectedFont
                cell.label.textColor = self.titleSelectedColor
                cell.backgroundColor = self.titleSelectedBGColor
            } else {
                cell.label.font = self.titleFont
                cell.label.textColor = self.titleColor
                cell.backgroundColor = self.titleBGColor
            }
        }
        cell.selectBlock = {
            self.selectedIndex = indexPath.row
            self.selectedBlock?(indexPath.row)
            self.tupleView.reloadTupleData()            
            // Scroll item
            let items = self.tupleView.numberOfItems(inSection: indexPath.section)
            var row = indexPath.row + 1
            if row >= items { row = items - 1 }
            let indexPath = IndexPath(row: row, section: indexPath.section)
            self.tupleView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: true)
        }

    }
    
}

