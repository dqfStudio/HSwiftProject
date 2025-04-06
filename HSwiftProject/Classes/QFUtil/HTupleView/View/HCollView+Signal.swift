//
//  HCollView+Signal.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

extension HCollView {

    /// The signal block held by collView
    var signalBlock: HCollCellSignalBlock? {
        get { return self.getAssociatedValueForKey(&kCollSignalKey) as? HCollCellSignalBlock }
        set { self.setAssociateCopyValue(newValue, key: &kCollSignalKey) }
    }

    /// Send signal to collView
    func signalToCollView(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    /// Send signals to all items, items under a certain section, or a single item individually
    func signalToAllItems(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let colls = self?.allReuseCells.objectEnumerator()?.allObjects.compactMap { $0 as? HCollBaseCell }
            colls?.forEach { cell in
                DispatchQueue.main.async { [weak cell] in
                    guard let cell = cell else { return }
                    cell.signalBlock?(cell, signal)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HCollSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        let items = self.numberOfItems(inSection: section)
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: items) { [weak self] i in
                let cell = self?.allReuseCells.object(forKey: IndexPath.nsStringValue(i, section)) as? HCollBaseCell
                if let cell = cell, let signalBlock = cell.signalBlock {
                    DispatchQueue.main.async(group: group) { [weak cell] in
                        guard let cell = cell else { return }
                        signalBlock(cell, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HCollSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section)) as? HCollBaseCell
        if let cell = cell, let signalBlock = cell.signalBlock {
            signalBlock(cell, signal)
        }
        completion()
    }

    /// Send signals to all headers or a single header individually
    func signalToAllHeader(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                let header = self?.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, i)) as? HCollBaseApex
                if let header = header, let signalBlock = header.signalBlock {
                    DispatchQueue.main.async(group: group) { [weak header] in
                        guard let header = header else { return }
                        signalBlock(header, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HCollSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section)) as? HCollBaseApex
        if let header = header, let signalBlock = header.signalBlock {
            signalBlock(header, signal)
        }
        completion()
    }

    /// Send signals to all footers or a single footer individually
    func signalToAllFooter(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                let footer = self?.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, i)) as? HCollBaseApex
                if let footer = footer, let signalBlock = footer.signalBlock {
                    DispatchQueue.main.async(group: group) { [weak footer] in
                        guard let footer = footer else { return }
                        signalBlock(footer, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HCollSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section)) as? HCollBaseApex
        if let footer = footer, let signalBlock = footer.signalBlock {
            signalBlock(footer, signal)
        }
        completion()
    }

    /// Release all signal blocks
    func releaseAllSignal() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.signalBlock = nil
            //release all cell
            self.allReuseCells.objectEnumerator()?.allObjects.forEach {
                ($0 as? HCollBaseCell)?.signalBlock = nil
                ($0 as? HCollBaseCell)?.selectBlock = nil
                ($0 as? HCollBaseCell)?.willDisplayBlock = nil
            }
            //release all header
            self.allReuseHeaders.objectEnumerator()?.allObjects.forEach {
                ($0 as? HCollBaseApex)?.signalBlock = nil
            }
            //release all footer
            self.allReuseFooters.objectEnumerator()?.allObjects.forEach {
                ($0 as? HCollBaseApex)?.signalBlock = nil
            }
        }
    }

    /// Get cell based on the given row and section
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }
    
    func cell(for indexPath: IndexPath) -> AnyObject? {
        return self.allReuseCells.object(forKey: indexPath.nsStringValue)
    }
    
    func header(for section: Int) -> AnyObject? {
        return self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section))
    }
    
    func footer(for section: Int) -> AnyObject? {
        return self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section))
    }

    /// Get the width, height, and size of a certain section
    func width(forSection section: Int) -> CGFloat {
        var width: CGFloat = self.width
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            width -= edgeInsets.left + edgeInsets.right
            width = max(width, 0) // Ensure width is not less than 0
        }
        return width
    }

    func heigh(forSection section: Int) -> CGFloat {
        var height: CGFloat = self.height
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            height -= edgeInsets.top + edgeInsets.bottom
            height = max(height, 0) // Ensure width is not less than 0
        }
        return height
    }

    func size(forSection section: Int) -> CGSize {
        var size: CGSize = self.size
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            size.width -= edgeInsets.left + edgeInsets.right
            size.height -= edgeInsets.top + edgeInsets.bottom
            size.width = max(size.width, 0) // Ensure that the width is not less than 0
            size.height = max(size.height, 0) // Ensure that the height is not less than 0
        }
        return size
    }

    /// Calculate the width of the item based on the number and index passed in
    func fixSlit(withWidth width: CGFloat, colCount: Int, index: Int) -> CGFloat {
        let itemWidth: CGFloat = width / CGFloat(colCount)
        let realItemWidth: CGFloat = itemWidth.rounded(.down)
        if index == colCount - 1 {
            return width - realItemWidth * CGFloat(index)
        }
        return realItemWidth
    }

}
