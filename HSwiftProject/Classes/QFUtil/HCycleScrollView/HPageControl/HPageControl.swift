//
//  HPageControl.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

/**
 *  Default number of pages for initialization
 */
private let kHDefaultNumberOfPages = 0

/**
 *  Default current page for initialization
 */
private let kHDefaultCurrentPage = 0

/**
 *  Default setting for hide for single page feature. For initialization
 */
private let kHDefaultHideForSinglePage = false

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
private let kHDefaultShouldResizeFromCenter = true

/**
 *  Default spacing between dots
 */
private let kHDefaultSpacingBetweenDots = 8

/**
 *  Default dot size
 */
private let kHDefaultDotSize = CGSize(width: 8, height: 8)


@objc protocol HPageControlDelegate : NSObjectProtocol {
    @objc optional
    func HPageControl(_ pageControl: HPageControl, didSelectPageAtIndex index: Int)
}


class HPageControl: UIControl {
    
    /**
     *  Array of dot views for reusability and touch events.
     */
    private var dots = NSMutableArray()
    
    
    private var _dotImage: UIImage?
    /**
     *  UIImage to represent a dot.
     */
    var dotImage: UIImage? {
        get {
            return _dotImage
        }
        set {
            _dotImage = newValue
            self.resetDotViews()
        }
    }


    private var _currentDotImage: UIImage?
    /**
     *  UIImage to represent current page dot.
     */
    var currentDotImage: UIImage? {
        get {
            return _currentDotImage
        }
        set {
            _currentDotImage = newValue
            self.resetDotViews()
        }
    }


    private var _dotSize: CGSize = CGSize.zero
    /**
     *  Dot size for dot views. Default is 8 by 8.
     */
    var dotSize: CGSize {
        get {
            // Dot size logic depending on the source of the dot view
            if (self.dotImage != nil && _dotSize == CGSize.zero) {
                _dotSize = self.dotImage!.size
            }else if (_dotSize == CGSize.zero) {
                _dotSize = kHDefaultDotSize
                return _dotSize
            }
            return _dotSize
        }
        set {
            _dotSize = newValue
        }
    }


    var dotColor: UIColor?

    private var _spacingBetweenDots: NSInteger = 0
    /**
     *  Spacing between two dot views. Default is 8.
     */
    var spacingBetweenDots: NSInteger {
        get {
            return _spacingBetweenDots
        }
        set {
            _spacingBetweenDots = newValue
            self.resetDotViews()
        }
    }


    /**
     * Page control setup properties
     */


    /**
     * Delegate for HPageControl
     */
    weak var delegate: HPageControlDelegate?


    private var _numberOfPages: NSInteger = 0
    /**
     *  Number of pages for control. Default is 0.
     */
    var numberOfPages: NSInteger {
        get {
            return _numberOfPages
        }
        set {
            _numberOfPages = newValue
            // Update dot position to fit new number of pages
            self.resetDotViews()
        }
    }

    private var _currentPage: NSInteger = 0
    /**
     *  Current page on which control is active. Default is 0.
     */
    var currentPage: NSInteger {
        get {
            return _currentPage
        }
        set {
            // If no pages, no current page to treat.
            if (_numberOfPages == 0 || newValue == _currentPage) {
                _currentPage = newValue
                return
            }
            
            // Pre set
            self.changeActivity(false, atIndex: _currentPage)
            _currentPage = newValue
            // Post set
            self.changeActivity(true, atIndex: _currentPage)
        }
    }


    /**
     *  Hide the control if there is only one page. Default is false.
     */
    var hidesForSinglePage: Bool = false


    /**
     *  Let the control know if should grow bigger by keeping center, or just get longer (right side expanding). By default true.
     */
    var shouldResizeFromCenter: Bool = true


    /**
     *  Return the minimum size required to display control properly for the given page count.
     *
     *  @param pageCount Number of dots that will require display
     *
     *  @return The CGSize being the minimum size required.
     */
    func sizeForNumberOfPages(_ pageCount: Int) -> CGSize {
        return CGSize(width: (self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(pageCount) - CGFloat(self.spacingBetweenDots), height: self.dotSize.height)
    }

    /// Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }


    /**
     *  Default setup when initiating control
     */
    private func initialization() {
        self.spacingBetweenDots    = kHDefaultSpacingBetweenDots
        self.numberOfPages         = kHDefaultNumberOfPages
        self.currentPage           = kHDefaultCurrentPage
        self.hidesForSinglePage    = kHDefaultHideForSinglePage
        self.shouldResizeFromCenter = kHDefaultShouldResizeFromCenter
    }


    /// Touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t = touch as! UITouch
            if (t.view != self) {
                let index = self.dots.index(of: t.view!)
                if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.HPageControl(_:didSelectPageAtIndex:))) {
                    self.delegate!.HPageControl?(self, didSelectPageAtIndex: index)
                }
            }
        }
    }

    /// Layout


    /**
     *  Resizes and moves the receiver view so it just encloses its subviews.
     */
    override func sizeToFit() {
        self.updateFrame(true)
    }


    /**
     *  Will update dots display and frame. Reuse existing views or instantiate one if required. Update their position in case frame changed.
     */
    private func updateDots() {
        if self.numberOfPages == 0 {
            return
        }
        
        for i in 0..<self.numberOfPages {
            var dot: UIView
            if i < self.dots.count {
                dot = self.dots.object(at: i) as! UIView
            } else {
                dot = self.generateDotView()
            }
            self.updateDotFrame(dot, atIndex: i)
        }
        self.changeActivity(true, atIndex: self.currentPage)
        self.hideForSinglePage()
    }


    /**
     *  Update frame control to fit current number of pages. It will apply required size if authorize and required.
     *
     *  @param overrideExistingFrame BOOL to allow frame to be overriden. Meaning the required size will be apply no mattter what.
     */
    private func updateFrame(_ overrideExistingFrame: Bool) {
        let center: CGPoint = self.center
        let requiredSize: CGSize = self.sizeForNumberOfPages(self.numberOfPages)
        
        // We apply requiredSize only if authorize to and necessary
        if (overrideExistingFrame || ((self.frame.width < requiredSize.width || self.frame.height < requiredSize.height) && !overrideExistingFrame)) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: requiredSize.width, height: requiredSize.height)
            if (self.shouldResizeFromCenter) {
                self.center = center
            }
        }
        
        self.resetDotViews()
    }


    /**
     *  Update the frame of a specific dot at a specific index
     *
     *  @param dot   Dot view
     *  @param index Page index of dot
     */
    private func updateDotFrame(_ dot: UIView, atIndex index: Int) {
        // Dots are always centered within view
        let xx = (self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(index)
        let jj = (self.frame.width - self.sizeForNumberOfPages(self.numberOfPages).width) / 2
        let x: CGFloat = xx + jj
        let y: CGFloat = (self.frame.height - self.dotSize.height) / 2
        
        dot.frame = CGRect(x: x, y: y, width: self.dotSize.width, height: self.dotSize.height)
    }


    /// Utils


    /**
     *  Generate a dot view and add it to the collection
     *
     *  @return The UIView object representing a dot
     */
    private func generateDotView() -> UIView {

        var dotView: UIView?
        
        if self.dotImage != nil {
            dotView = UIImageView(image: self.dotImage)
            dotView!.frame = CGRect(x: 0, y: 0, width: self.dotSize.width, height: self.dotSize.height)
        }else {
            dotView = HAnimatedDotView()
            dotView!.frame = CGRect(x: 0, y: 0, width: self.dotSize.width, height: self.dotSize.height)
            if (self.dotColor != nil) {
                (dotView! as! HAnimatedDotView).dotColor = self.dotColor
            }
        }
        
        if dotView != nil {
            self.addSubview(dotView!)
            self.dots.add(dotView!)
        }
        
        dotView!.isUserInteractionEnabled = true
        return dotView!
    }


    /**
     *  Change activity state of a dot view. Current/not currrent.
     *
     *  @param active Active state to apply
     *  @param index  Index of dot for state update
     */
    private func changeActivity(_ active: Bool, atIndex index: Int) {
        if (self.dotImage != nil && self.currentDotImage != nil) {
            let dotView = self.dots.object(at: index) as! UIImageView
            dotView.image = (active) ? self.currentDotImage : self.dotImage
        }else {
            let abstractDotView = self.dots.object(at: index) as! HAbstractDotView
            if abstractDotView.responds(to: #selector(abstractDotView.changeActivityState(_:))) {
                abstractDotView.changeActivityState(active)
            }
        }
    }


    private func resetDotViews() {
        for dotView in self.dots {
            (dotView as! UIView).removeFromSuperview()
        }
        self.dots.removeAllObjects()
        self.updateDots()
    }


    private func hideForSinglePage() {
        if (self.dots.count == 1 && self.hidesForSinglePage) {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }

}
