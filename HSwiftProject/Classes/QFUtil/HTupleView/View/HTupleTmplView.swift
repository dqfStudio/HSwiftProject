//
//  HTupleTmplView.swift
//  HSwiftProject
//
//  Created by owner on 2024/9/27.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

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
            //release all cell
            self?.allReuseCells.objectEnumerator()?.allObjects.forEach {
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
        identifier += idx ? indexPath.stringValue : ""
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
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section) as! UIEdgeInsets
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
        identifier += idx ? indexPath.stringValue : ""
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
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section) as! UIEdgeInsets
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
        identifier += idx ? indexPath.stringValue : ""
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
            let selector = #selector(delegate.edgeInsetsForItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }

    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        self.allSectionInsets.removeAllObjects()
        var sections = 1
        if let delegate = self.tupleDelegate {
            let prefix = ""
            let selector = #selector(delegate.numberOfSectionsInTupleView)
            if delegate.responds(to: selector, withPre: prefix) {
                sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
            }
            // Prevents quantity from being less than 1
            sections = max(sections, 1)
        }
        return sections
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tupleDelegate {
            // Get the number of items
            let itemSelector: Selector = #selector(delegate.numberOfItemsInSection(_:))
            if delegate.responds(to: itemSelector) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section) as! Int
            }

            // Get the edgeInsets of the section
            var edgeInsets: UIEdgeInsets = .zero
            let insetSelector = #selector(delegate.insetForSection(_:))
            if delegate.responds(to: insetSelector) {
                edgeInsets = delegate.performWithUnretainedValue(insetSelector, with: section) as! UIEdgeInsets
            }
            self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets), forKey: "\(section)" as NSString)

            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.tupleDelegate {
            let selector = #selector(delegate.minimumLineSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
        }
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.tupleDelegate {
            let selector = #selector(delegate.minimumInteritemSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
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
            let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForHeaderInSection(_:))
                if delegate.responds(to: selector) {
                    size = delegate.performWithUnretainedValue(selector, with: section) as! CGSize
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
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForFooterInSection(_:))
                if delegate.responds(to: selector) {
                    size = delegate.performWithUnretainedValue(selector, with: section) as! CGSize
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
            let selector = #selector(delegate.sizeForItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                size = delegate.performWithUnretainedValue(selector, with: indexPath) as! CGSize
            }
            // Prevent negative size
            if size.width <= 0 { size.width = 1.0 }
            if size.height <= 0 { size.height = 1.0 }
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let delegate = self.tupleDelegate {
            let selector: Selector = #selector(delegate.tupleItem(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.performWithUnretainedValue(selector, with: self, with: indexPath)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell!
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell: HTupleBaseApex?
        if kind == UICollectionView.elementKindSectionHeader {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
                if delegate.responds(to: selector) {
                    // Unique identifier
                    let identifier = "HeaderSpaceCell" + self.addressValue + indexPath.stringValue
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.tupleHeader(_:atIndexPath:))
                    if delegate.responds(to: selector) {
                        delegate.perform(selector, with: self, with: indexPath)
                    }
                }
            }
            // Call cell
            cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex
        }else if (kind == UICollectionView.elementKindSectionFooter) {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
                if delegate.responds(to: selector) {
                    // Unique identifier
                    let identifier = "FooterSpaceCell" + self.addressValue + indexPath.stringValue
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HTupleBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.tupleFooter(_:atIndexPath:))
                    if delegate.responds(to: selector) {
                        delegate.perform(selector, with: self, with: indexPath)
                    }
                }
            }
            // Call cell
            cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex
        }
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell!
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        if let willDisplayBlock = cell?.willDisplayBlock {
            willDisplayBlock()
        }else if let delegate = self.tupleDelegate, let cell = cell {
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        if let selectBlock = cell?.selectBlock {
            selectBlock()
        }else if let delegate = self.tupleDelegate, let cell = cell {
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

}
