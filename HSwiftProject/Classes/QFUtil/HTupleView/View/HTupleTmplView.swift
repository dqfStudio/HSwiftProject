//
//  HTupleTmplView.swift
//  HSwiftProject
//
//  Created by owner on 2024/9/27.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

private var kTupleDesignKey = "tuple"
private var kTupleExaDesignKey = "tupleExa"

private var kTupleStateKey: Void?
private var kTupleSignalKey: Void?
private var kTupleStateSourceKey: Void?

@objc protocol HTupleTmplViewDelegate: UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInTupleView() -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any

    @objc
    optional func sizeForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func sizeForFooterInSection(_ section: Any) -> Any
    @objc
    optional func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func edgeInsetsForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForFooterInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumLineSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any

    @objc
    optional func insetForSection(_ section: Any) -> Any
    
    @objc
    optional func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath)
    @objc
    optional func tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath)
    @objc
    optional func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath)
    
    @objc
    optional func didSelectCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath)
}

class HTupleTmplView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var flowLayout: UICollectionViewFlowLayout?

    // tuple style
    private var tupleStyle: HTupleStyle = .tuple
    
    // tuple align
    var tupleAlign: HTupleAlign = .default
    
    // split design
    var tupleState: Int = 0

    private var sectionPaths = NSArray()
    private var allReuseIdentifiers = NSMutableSet()
    private var allSectionInsets = NSMapTable<NSString, NSString>.strongToStrongObjects()
    private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Default scrolling direction is vertical
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: HTupleViewLayout(.vertical, .manual))
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }

    static func splitFrame(_ frame: () -> CGRect, exclusiveSections sections: () -> NSArray, layout: () -> UICollectionViewFlowLayout) -> HTupleTmplView {
        return HTupleTmplView(frame(), style: .split, exclusiveSections: sections(), layout: layout())
    }
    
    static func tupleFrame(_ frame: () -> CGRect, layout: () -> UICollectionViewFlowLayout) -> HTupleTmplView {
        return HTupleTmplView(frame(), style: .tuple, exclusiveSections: [], layout: layout())
    }

    private convenience init(_ frame: CGRect, style: HTupleStyle, exclusiveSections sectionPaths: NSArray, layout: UICollectionViewFlowLayout) {
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: layout)
        self.sectionPaths = sectionPaths
        self.tupleStyle = style
    }

    private weak var tupleDelegate: HTupleViewDelegate?
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { tupleDelegate = newValue as? HTupleViewDelegate }
    }
    weak override var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }

    override var frame: CGRect {
        get { return super.frame }
        set {
            let frame = UIRectIntegral(newValue)
            guard frame != super.frame else { return }
            super.frame = frame
            self.reloadData()
        }
    }

    private func setup() {
        self.isScrollEnabled = false
        self.backgroundColor = .clear
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        super.delegate = self
        super.dataSource = self
    }
    
    @objc
    func reloadTupleData() {
        DispatchQueue.mainAsync { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseTupleBlock() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.allReuseCells.objectEnumerator()?.allObjects.forEach {
                ($0 as? HTupleBaseCell)?.selectBlock = nil
                ($0 as? HTupleBaseCell)?.willDisplayBlock = nil
            }

            DispatchQueue.main.async { [weak self] in
                self?.tupleDelegate = nil
            }
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    /// Register class
    @discardableResult
    func reuseHeader(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! HTupleBaseApex
        cell.indexPath = indexPath
        cell.isHeader = true
        cell.tuple = self
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }

    @discardableResult
    func reuseFooter(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! HTupleBaseApex
        cell.indexPath = indexPath
        cell.isHeader = false
        cell.tuple = self
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }
    
    @discardableResult
    func reuseCell(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HTupleBaseCell
        cell.indexPath = indexPath
        cell.tuple = self
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector = #selector(delegate.edgeInsetsForItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }

    /// UICollectionViewDatasource  & delegate
    func tupleSplitPrefix(_ section: Int) -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            if self.sectionPaths.contains(section) {
                let idx = self.sectionPaths.index(of: section)
                prefix = kTupleExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = kTupleDesignKey + "\(self.tupleState)" + "_"
            }
        }
        return prefix
    }

    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        self.allSectionInsets.removeAllObjects()
        // tuple Style
        var sections = 1
        switch self.tupleStyle {
        case .tuple:
            if let delegate = self.tupleDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInTupleView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
        case .split:
            if let delegate = self.tupleDelegate {
                let prefix = kTupleDesignKey + "\(self.tupleState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInTupleView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
        }
        return sections
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tupleDelegate {
            // Get the number of items
            let prefix = self.tupleSplitPrefix(section)
            let itemSelector: Selector = #selector(delegate.numberOfItemsInSection(_:))
            if delegate.responds(to: itemSelector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section, withPre: prefix) as! Int
            }

            // Get the edgeInsets of the section
            var edgeInsets: UIEdgeInsets = .zero
            let insetSelector = #selector(delegate.insetForSection(_:))
            if delegate.responds(to: insetSelector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(insetSelector, with: section, withPre: prefix) as! UIEdgeInsets
            }
            self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets), forKey: "\(section)" as NSString)

            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(section)
            let selector = #selector(delegate.minimumLineSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
        }
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(section)
            let selector = #selector(delegate.minimumInteritemSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
        }
        return 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //Get the edgeInsets of the section
        var edgeInsets: UIEdgeInsets = .zero
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
           edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
        }
        return edgeInsets
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(section)
            let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForHeaderInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
                }
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(section)
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForFooterInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
                }
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //item size cannot be zero, otherwise it will crash
        var size = CGSize(width: 1.0, height: 1.0)
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector = #selector(delegate.sizeForItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                size = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGSize
            }
            // Prevent negative size
            if size.width <= 0 { size.width = 1.0 }
            if size.height <= 0 { size.height = 1.0 }
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Call delegate method
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector: Selector = #selector(delegate.tupleItem(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.performWithUnretainedValue(selector, with: self, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        if let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell {
            // Update layout
            if cell.responds(to: #selector(cell.relayoutSubviews)) {
                cell.relayoutSubviews()
            }
            return cell
        }
        self.register(HTupleBaseCell.self, forCellWithReuseIdentifier: HTupleBaseCell.className)
        return self.dequeueReusableCell(withReuseIdentifier: HTupleBaseCell.className, for: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let prefix = self.tupleSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = "HeaderSpaceCell" + self.addressValue + "\(indexPath.section)-\(indexPath.row)" + "\(self.tupleState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.tupleHeader(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex {
                // Update layout
                if cell.responds(to: #selector(cell.relayoutSubviews)) {
                    cell.relayoutSubviews()
                }
                return cell
            }
            self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HTupleBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HTupleBaseApex.className, for: indexPath)
        }else {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let prefix = self.tupleSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = "FooterSpaceCell" + self.addressValue + "\(indexPath.section)-\(indexPath.row)" + "\(self.tupleState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.tupleFooter(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex {
                // Update layout
                if cell.responds(to: #selector(cell.relayoutSubviews)) {
                    cell.relayoutSubviews()
                }
                return cell
            }
            self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HTupleBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HTupleBaseApex.className, for: indexPath)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        if let willDisplayBlock = cell?.willDisplayBlock {
            willDisplayBlock()
        }else if let delegate = self.tupleDelegate, let cell = cell {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        if let selectBlock = cell?.selectBlock {
            selectBlock()
        }else if let delegate = self.tupleDelegate, let cell = cell {
            let prefix = self.tupleSplitPrefix(indexPath.section)
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

}
