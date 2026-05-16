//
//  HCollView+Scroll.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Scroll Management
extension HCollView {
    /// Whether the header and footer are sticky
    var sectionHeadersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionHeadersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionHeadersPinToVisibleBounds = newValue }
    }

    var sectionFootersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionFootersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionFootersPinToVisibleBounds = newValue }
    }

    /// Bounce method
    func enableHorizontalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
    }

    func enableVerticalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
    }

    func enableBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }

    func disableBounce() {
        self.bounces = false
    }
    
    /// Scroll to top with animation option
    func scrollToTop(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }
    
    /// Scroll to specified section
    /// - Parameters:
    ///   - section: Section index
    ///   - animated: Whether to animate the scroll
    func scrollToSection(_ section: Int, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            guard section >= 0 && section < sections else { return }
            
            let indexPath = IndexPath(row: 0, section: section)
            self.scrollToItem(at: indexPath, at: .top, animated: animated)
        }
    }
    
    /// Scroll to specified item
    /// - Parameters:
    ///   - indexPath: IndexPath of the item
    ///   - position: Scroll position
    ///   - animated: Whether to animate the scroll
    func scrollToItemSafely(at indexPath: IndexPath, at position: UICollectionView.ScrollPosition, animated: Bool) {
        let sections = self.numberOfSections
        guard indexPath.section >= 0 && indexPath.section < sections else { return }
        
        let items = self.numberOfItems(inSection: indexPath.section)
        guard indexPath.item >= 0 && indexPath.item < items else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollToItem(at: indexPath, at: position, animated: animated)
        }
    }
    
    /// Smooth scroll to specified content offset
    /// - Parameters:
    ///   - contentOffset: Target content offset
    ///   - duration: Animation duration
    func smoothScroll(to contentOffset: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.contentOffset = contentOffset
        }
    }
    
    /// Enable or disable scrolling
    /// - Parameter enabled: Whether scrolling is enabled
    func setScrollEnabled(_ enabled: Bool) {
        isScrollEnabled = enabled
    }
    
    /// Get current scroll position
    var currentScrollPosition: CGPoint {
        return contentOffset
    }

    /// Scroll to bottom with animation option
    func scrollsToBottom(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            guard sections > 0 else { return }
            
            let lastSection = sections - 1
            let items = self.numberOfItems(inSection: lastSection)
            guard items > 0 else { return }
            
            let indexPath = IndexPath(row: items - 1, section: lastSection)
            self.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
