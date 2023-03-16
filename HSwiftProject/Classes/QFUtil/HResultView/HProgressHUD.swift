////
////  HProgressHUD.swift
////  HSwiftProject
////
////  Created by owner on 2023/3/9.
////  Copyright © 2023 wind. All rights reserved.
////
//
//import UIKit
//
//enum HProgressHUDMode: Int {
//    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
//    case indeterminate
//    /** Progress is shown using a round, pie-chart like, progress view. */
//    case determinate
//    /** Progress is shown using a horizontal progress bar */
//    case determinateHorizontalBar
//    /** Progress is shown using a ring-shaped progress view. */
//    case annularDeterminate
//    /** Shows a custom view */
//    case customView
//    /** Shows only labels */
//    case modeText
//}
//
//enum HProgressHUDAnimation: Int {
//    /** Opacity animation */
//    case fade
//    /** Opacity + scale animation */
//    case zoom
////    case zoomOut = HProgressHUDAnimation.zoom
//    case zoomOut
//    case zoomIn
//}
//
//typealias HProgressHUDCompletionBlock = () -> Void
//
///**
// * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
// *
// * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
// * The HProgressHUD window spans over the entire space given to it by the initWithFrame constructor and catches all
// * user input on this region, thereby preventing the user operations on components below the view. The HUD itself is
// * drawn centered as a rounded semi-transparent view which resizes depending on the user specified content.
// *
// * This view supports four modes of operation:
// * - indeterminate - shows a UIActivityIndicatorView
// * - determinate - shows a custom round progress indicator
// * - annularDeterminate - shows a custom annular progress indicator
// * - customView - shows an arbitrary, user specified view (@see customView)
// *
// * All three modes can have optional labels assigned:
// * - If the labelText property is set and non-empty then a label containing the provided content is placed below the
// *   indicator view.
// * - If also the detailsLabelText property is set then another label is placed below the first label.
// */
//class HProgressHUD : UIView {
//    
//    static let kPadding: CGFloat = 4
//    static let kLabelFontSize: CGFloat = 16
//    static let kDetailsLabelFontSize: CGFloat = 12
//    
//    private var indicator: UIView?
//    private var showStarted: Date?
//    private var showSize: CGSize?
//
//    private var useAnimation: Bool
//    private var methodForExecution: Selector?
//    private var targetForExecution: AnyObject?
//    private var objectForExecution: AnyObject?
//    private var label: UILabel?
//    private var detailsLabel: UILabel?
//    private var isFinished: Bool
//    private var rotationTransform: CGAffineTransform?
//    
//    /**
//     * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
//     *
//     * @param view The view that the HUD will be added to
//     * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
//     * animations while appearing.
//     * @return A reference to the created HUD.
//     *
//     * @see hideHUDForView:animated:
//     * @see animationType
//     */
//    static func showHUDAddedTo(_ view: UIView, animated: Bool) -> HProgressHUD {
//        let hud = HProgressHUD(view: view)
//        view.addSubview(hud)
//        hud.show(animated)
//        return hud
//    }
//    
//    /**
//     * Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
//     *
//     * @param view The view that is going to be searched for a HUD subview.
//     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
//     * animations while disappearing.
//     * @return YES if a HUD was found and removed, NO otherwise.
//     *
//     * @see showHUDAddedTo:animated:
//     * @see animationType
//     */
//    static func hideHUDForView(_ view: UIView, animated: Bool) -> Bool {
//        let hud = self.HUDForView(view)
//        if hud != nil {
//            hud?.removeFromSuperViewOnHide = true
//            hud?.hide(animated)
//            return true
//        }
//        return false
//    }
//    
//    /**
//     * Finds all the HUD subviews and hides them.
//     *
//     * @param view The view that is going to be searched for HUD subviews.
//     * @param animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use
//     * animations while disappearing.
//     * @return the number of HUDs found and removed.
//     *
//     * @see hideHUDForView:animated:
//     * @see animationType
//     */
//    static func hideAllHUDsForView(_ view: UIView, animated: Bool) -> UInt {
//        let huds = HProgressHUD.allHUDsForView(view)
//        for tmpHud in huds {
//            let hud = tmpHud as! HProgressHUD
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(animated)
//        }
//        return UInt(huds.count)
//    }
//    
//    /**
//     * Finds the top-most HUD subview and returns it.
//     *
//     * @param view The view that is going to be searched.
//     * @return A reference to the last HUD subview discovered.
//     */
//    static func HUDForView(_ view: UIView) -> HProgressHUD? {
//        for subview in view.subviews.reversed() {
//            if subview.isKind(of: HProgressHUD.self) {
//                return subview as? HProgressHUD
//            }
//        }
//        return nil
//    }
//    
//    /**
//     * Finds all HUD subviews and returns them.
//     *
//     * @param view The view that is going to be searched.
//     * @return All found HUD views (array of HProgressHUD objects).
//     */
//    static func allHUDsForView(_ view: UIView) -> NSArray {
//        let huds = NSMutableArray()
//        let subviews = view.subviews
//        for aView in subviews {
//            if aView.isKind(of: HProgressHUD.self) {
//                huds.add(aView)
//            }
//        }
//        return NSArray(array: huds)
//    }
//    
//    /**
//     * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
//     * window.bounds as the parameter.
//     *
//     * @param window The window instance that will provide the bounds for the HUD. Should be the same instance as
//     * the HUD's superview (i.e., the window that the HUD will be added to).
//     */
//    init(window: UIWindow) {
//        super.init(frame: window.bounds)
//    }
//    
//    /**
//     * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
//     * view.bounds as the parameter
//     *
//     * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
//     * the HUD's superview (i.e., the view that the HUD will be added to).
//     */
//    init(view: UIView) {
//        super.init(frame: view.bounds)
//    }
//    
//    /**
//     * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
//     * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
//     * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
//     *
//     * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
//     * animations while appearing.
//     *
//     * @see animationType
//     */
//    func show(_ animated: Bool) {
//        useAnimation = animated
//        // If the grace time is set postpone the HUD display
//        if self.graceTime > 0.0 {
//            Timer.scheduledTimerWithTimeInterval(self.graceTime, times: 1, block: { timer in
//                if self.taskInProgress {
//                    self.setNeedsDisplay()
//                    self.showUsingAnimation(self.useAnimation)
//                }
//            })
//        }
//        // ... otherwise show the HUD imediately
//        else {
//            self.setNeedsDisplay()
//            self.showUsingAnimation(useAnimation)
//        }
//    }
//    
//    /**
//     * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
//     * hide the HUD when your task completes.
//     *
//     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
//     * animations while disappearing.
//     *
//     * @see animationType
//     */
//    func hide(_ animated: Bool) {
//        useAnimation = animated;
//        // If the minShow time is set, calculate how long the hud was shown,
//        // and pospone the hiding operation if necessary
//        if self.minShowTime > 0.0, showStarted != nil {
//            let interv: TimeInterval = NSDate().timeIntervalSince(showStarted!)
//            if interv < self.minShowTime {
//                Timer.scheduledTimerWithTimeInterval(self.minShowTime - interv, times: 1) { timer in
//                    self.hideUsingAnimation(self.useAnimation)
//                }
//                return
//            }
//        }
//        // ... otherwise hide the HUD immediately
//        self.hideUsingAnimation(useAnimation)
//    }
//    
//    /**
//     * Hide the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
//     * hide the HUD when your task completes.
//     *
//     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
//     * animations while disappearing.
//     * @param delay Delay in seconds until the HUD is hidden.
//     *
//     * @see animationType
//     */
//    func hide(_ animated: Bool, afterDelay delay: TimeInterval) {
//        self.perform(#selector(hideDelayed(_:)), with: NSNumber(value: animated), afterDelay: delay)
//    }
//    
//    /**
//     * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
//     *
//     * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
//     * pool.
//     *
//     * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
//     * @param target The object that the target method belongs to.
//     * @param object An optional object to be passed to the method.
//     * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
//     * animations while (dis)appearing.
//     */
//    func showWhileExecuting(_ method: Selector, onTarget target: AnyObject, withObject object: AnyObject, animated: Bool) {
//        methodForExecution = method
//        targetForExecution = target
//        objectForExecution = object
//        // Launch execution in new thread
//        self.taskInProgress = true
//        Thread.detachNewThreadSelector(#selector(launchExecution), toTarget: self, with: nil)
//        // Show HUD view
//        self.show(animated)
//    }
//    
//    /**
//     * Shows the HUD while a block is executing on a background queue, then hides the HUD.
//     *
//     * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
//     */
//    func showAnimated(_ animated: Bool, whileExecutingBlock block: MinCallback) {
//        self.showAnimated(animated, whileExecutingBlock: block)
//    }
//    
//    /**
//     * Shows the HUD while a block is executing on the specified dispatch queue, executes completion block on the main queue, and then hides the HUD.
//     *
//     * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will
//     * not use animations while (dis)appearing.
//     * @param block The block to be executed while the HUD is shown.
//     * @param queue The dispatch queue on which the block should be executed.
//     * @param completion The block to be executed on completion.
//     *
//     * @see completionBlock
//     */
//    func showAnimated(_ animated: Bool, whileExecutingBlock block: MinCallback, completionBlock completion: @escaping HProgressHUDCompletionBlock) {
//        self.taskInProgress = true
//        self.completionBlock = completion
//        DispatchQueue.global().async {
//            block()
//            DispatchQueue.main.async {
//                self.cleanUp()
//            }
//        }
//        self.show(animated)
//    }
//    
//    /**
//     * A block that gets called after the HUD was completely hidden.
//     */
//    var completionBlock: HProgressHUDCompletionBlock?
//    
//    
//    /**
//     * HProgressHUD operation mode. The default is indeterminate.
//     *
//     * @see HProgressHUDMode
//     */
//    var mode: HProgressHUDMode?
//    
//    /**
//     * The animation type that should be used when the HUD is shown and hidden.
//     *
//     * @see HProgressHUDAnimation
//     */
//    var animationType: HProgressHUDAnimation?
//    
//    /**
//     * The UIView (e.g., a UIImageView) to be shown when the HUD is in customView.
//     * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
//     */
//    var customView: UIView?
//    
//    /**
//     * The HUD delegate object.
//     *
//     * @see HProgressHUDDelegate
//     */
//    var delegate: HProgressHUDDelegate?
//    
//    /**
//     * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
//     * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
//     * set to @"", then no message is displayed.
//     */
//    var labelText: String?
//    
//    /**
//     * An optional details message displayed below the labelText message. This message is displayed only if the labelText
//     * property is also set and is different from an empty string (@""). The details text can span multiple lines.
//     */
//    var detailsLabelText: String?
//    
//    /**
//     * The opacity of the HUD window. Defaults to 0.8 (80% opacity).
//     */
//    var opacity: CGFloat
//    
//    /**
//     * The color of the HUD window. Defaults to black. If this property is set, color is set using
//     * this UIColor and the opacity property is not used.  using retain because performing copy on
//     * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
//     */
//    var color: UIColor?
//    
//    /**
//     * The x-axis offset of the HUD relative to the centre of the superview.
//     */
//    var xOffset: CGFloat
//    
//    /**
//     * The y-axis offset of the HUD relative to the centre of the superview.
//     */
//    var yOffset: CGFloat
//    
//    /**
//     * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
//     * Defaults to 20.0
//     */
//    var margin: CGFloat
//    
//    /**
//     * Cover the HUD background view with a radial gradient.
//     */
//    var dimBackground: Bool
//    
//    /*
//     * Grace period is the time (in seconds) that the invoked method may be run without
//     * showing the HUD. If the task finishes before the grace time runs out, the HUD will
//     * not be shown at all.
//     * This may be used to prevent HUD display for very short tasks.
//     * Defaults to 0 (no grace time).
//     * Grace time functionality is only supported when the task status is known!
//     * @see taskInProgress
//     */
//    var graceTime: CGFloat
//    
//    /**
//     * The minimum time (in seconds) that the HUD is shown.
//     * This avoids the problem of the HUD being shown and than instantly hidden.
//     * Defaults to 0 (no minimum show time).
//     */
//    var minShowTime: CGFloat
//    
//    /**
//     * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
//     * If you don't set a graceTime (different than 0.0) this does nothing.
//     * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
//     * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
//     * you need to set this property when your task starts and completes in order to have normal graceTime
//     * functionality.
//     */
//    var taskInProgress: Bool
//    
//    /**
//     * Removes the HUD from its parent view when hidden.
//     * Defaults to NO.
//     */
//    var removeFromSuperViewOnHide: Bool
//    
//    /**
//     * Font to be used for the main label. Set this property if the default is not adequate.
//     */
//    var labelFont: UIFont?
//    
//    /**
//     * Font to be used for the details label. Set this property if the default is not adequate.
//     */
//    var detailsLabelFont: UIFont?
//    
//    /**
//     * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
//     */
//    var progress: CGFloat
//    
//    /**
//     * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
//     */
//    var minSize: CGSize
//    
//    /**
//     * Force the HUD dimensions to be equal if possible.
//     */
//    var square: Bool
//    
//    
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // Set default values for properties
//        self.animationType = .fade
//        self.mode = .indeterminate
//        self.labelText = nil
//        self.detailsLabelText = nil
//        self.opacity = 0.8
//        self.color = nil
//        self.labelFont = UIFont.boldSystemFont(ofSize: HProgressHUD.kLabelFontSize)
//        self.detailsLabelFont = UIFont.boldSystemFont(ofSize: HProgressHUD.kDetailsLabelFontSize)
//        self.xOffset = 0.0
//        self.yOffset = 0.0
//        self.dimBackground = false
//        self.margin = 20.0
//        self.graceTime = 0.0
//        self.minShowTime = 0.0
//        self.removeFromSuperViewOnHide = false
//        self.minSize = CGSize.zero
//        self.square = false
//        
//        self.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
//        
//        // Transparent background
//        self.isOpaque = false
//        self.backgroundColor = UIColor.clear
//        // Make it invisible for now
//        self.alpha = 0.0
//        
//        taskInProgress = false
//        rotationTransform = CGAffineTransformIdentity
//        
//        self.setupLabels()
//        self.updateIndicators()
//        self.registerForKVO()
//        self.registerForNotifications()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        self.unregisterFromNotifications()
//        self.unregisterFromKVO()
//    }
//    
//    @objc private func hideDelayed(_ animated: NSNumber) {
//        self.hide(animated.boolValue)
//    }
//    
//    //#pragma mark - Timer callbacks
//    
////        private func handleGraceTimer(_ theTimer: NSTimer) {
////            // Show the HUD only if the task is still running
////            if (taskInProgress) {
////                [self setNeedsDisplay];
////                [self showUsingAnimation:useAnimation];
////            }
////        }
//    
////        private func handleMinShowTimer(_ theTimer: NSTimer) {
////            [self hideUsingAnimation:useAnimation];
////        }
//    
////        #pragma mark - View Hierrarchy
//    
//    override func didMoveToSuperview() {
//        // We need to take care of rotation ourselfs if we're adding the HUD to a window
//        if self.superview != nil, self.superview!.isKind(of: UIWindow.self) {
//            self.setTransformForCurrentOrientation(false)
//        }
//    }
//    
//    /// Internal show & hide operations
//    private func showUsingAnimation(_ animated: Bool) {
//        if animated && animationType == .zoomIn {
//            self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(0.5, 0.5))
//        } else if animated && animationType == .zoomOut {
//            self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(1.5, 1.5))
//        }
//            self.showStarted = Date()
//        // Fade in
//        if animated {
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.3)
//            self.alpha = 1.0
//            if animationType == .zoomIn || animationType == .zoomOut {
//                self.transform = rotationTransform!
//            }
//            UIView.commitAnimations()
//        }
//        else {
//            self.alpha = 1.0
//        }
//    }
//    
//    private func hideUsingAnimation(_ animated: Bool) {
//        // Fade out
//        if animated, showStarted != nil {
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.3)
//            UIView.setAnimationDelegate(self)
////            UIView.setAnimationDidStop(#selector(animationFinished:finished:context:))
//            UIView.setAnimationDidStop(#selector(animationFinished(_, finished:_, context:_)))
////                [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
//            // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
//            // in the done method
//            if animationType == .zoomIn {
//                self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(1.5, 1.5))
//            }else if animationType == .zoomOut {
//                self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(0.5, 0.5))
//            }
//            
//            self.alpha = 0.02
//            UIView.commitAnimations()
//        }
//        else {
//            self.alpha = 0.0
//            self.done()
//        }
//        self.showStarted = nil
//    }
//    
//    @objc func animationFinished(_ animationID: NSString, finished: Bool, context: Any) {
//        self.done()
//    }
//    
//    private func done() {
//        isFinished = true
//        self.alpha = 0.0
//        if removeFromSuperViewOnHide {
//            self.removeFromSuperview()
//        }
//        if self.completionBlock != nil {
//            self.completionBlock!()
//            self.completionBlock = nil
//        }
//        if delegate.responds(to: #selector(hudWasHidden(_:))) {
//            delegate?.performSelector(#selector(hudWasHidden(_:)), withObject: self)
//        }
//    }
//    
//    //#pragma mark - Threading
//    
//    //- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
//    //    methodForExecution = method;
//    //    targetForExecution = MB_RETAIN(target);
//    //    objectForExecution = MB_RETAIN(object);
//    //    // Launch execution in new thread
//    //    self.taskInProgress = YES;
//    //    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
//    //    // Show HUD view
//    //    [self show:animated];
//    //}
//    
//    //- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
//    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //    [self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
//    //}
//    
//    //- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)(void))completion {
//    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //    [self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
//    //}
//    
//    //- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
//    //    [self showAnimated:animated whileExecutingBlock:block onQueue:queue    completionBlock:NULL];
//    //}
//    
//    //- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
//    //     completionBlock:(HProgressHUDCompletionBlock)completion {
//    //    self.taskInProgress = YES;
//    //    self.completionBlock = completion;
//    //    dispatch_async(queue, ^(void) {
//    //        block();
//    //        dispatch_async(dispatch_get_main_queue(), ^(void) {
//    //            [self cleanUp];
//    //        });
//    //    });
//    //  [self show:animated];
//    //}
//    
//    @objc private func launchExecution() {
//        targetForExecution?.perform(methodForExecution, withObject: objectForExecution)
//        self.perform(#selector(cleanUp), with: nil, afterDelay: 0)
//    }
//    
//    @objc private func cleanUp() {
//        taskInProgress = false
//        targetForExecution = nil
//        objectForExecution = nil
//        self.hide(useAnimation)
//    }
//    
//    /// UI
//    private func setupLabels() {
//        label = UILabel(frame: self.bounds)
//        label!.adjustsFontSizeToFitWidth = false
//        label!.textAlignment = .center
//        label!.isOpaque = false
//        label!.backgroundColor = UIColor.clear
//        label!.textColor = UIColor.white
//        label!.font = self.labelFont
//        label!.text = self.labelText
//        self.addSubview(label!)
//        
//        detailsLabel = UILabel(frame: self.bounds)
//        detailsLabel!.font = self.detailsLabelFont
//        detailsLabel!.adjustsFontSizeToFitWidth = false
//        detailsLabel!.textAlignment = .center
//        detailsLabel!.isOpaque = false
//        detailsLabel!.backgroundColor = UIColor.clear
//        detailsLabel!.textColor = UIColor.white
//        detailsLabel!.numberOfLines = 0
//        detailsLabel!.font = self.detailsLabelFont
//        detailsLabel!.text = self.detailsLabelText
//        self.addSubview(detailsLabel!)
//    }
//    
//    private func updateIndicators() {
//        
//        let isActivityIndicator = indicator!.isKind(of: UIActivityIndicatorView.self)
//        let isRoundIndicator = indicator!.isKind(of: MBRoundProgressView.self)
//        
//        if mode == .indeterminate && !isActivityIndicator {
//            // Update to indeterminate indicator
//            indicator?.removeFromSuperview()
//            self.indicator = UIActivityIndicatorView(style: .whiteLarge)
//            (indicator! as! UIActivityIndicatorView).startAnimating()
//            self.addSubview(indicator!)
//        }
//        else if mode == .determinateHorizontalBar {
//            // Update to bar determinate indicator
//            indicator?.removeFromSuperview()
//            self.indicator = MBBarProgressView()
//            self.addSubview(indicator!)
//        }
//        else if mode == .determinate || mode == .annularDeterminate {
//            if !isRoundIndicator {
//                // Update to determinante indicator
//                indicator!.removeFromSuperview()
//                self.indicator = MBRoundProgressView()
//                self.addSubview(indicator!)
//            }
//            if mode == .annularDeterminate {
//                (indicator! as! MBRoundProgressView).annular = true
//            }
//        }
//        else if mode == .customView && customView != indicator {
//            // Update custom view indicator
//            indicator?.removeFromSuperview()
//            self.indicator = customView
//            self.addSubview(indicator!)
//        } else if mode == .modeText {
//            indicator!.removeFromSuperview()
//            self.indicator = nil
//        }
//    }
//    
//    /// Layout
//    override func layoutSubviews() {
//        
//        // Entirely cover the parent view
//        let parent = self.superview
//        if parent != nil {
//            self.frame = parent!.bounds
//        }
//        let bounds = self.bounds
//        
//        // Determine the total widt and height needed
//        let maxWidth = bounds.size.width - 4 * margin
//        var totalSize = CGSizeZero
//        
//        var indicatorF = indicator!.bounds
//        indicatorF.size.width = min(indicatorF.size.width, maxWidth)
//        totalSize.width = max(totalSize.width, indicatorF.size.width)
//        totalSize.height += indicatorF.size.height
//        
//        let msgSize = label!.text!.size(withAttributes: [NSAttributedString.Key.font: label!.font!])
//        var labelSize = label!.text!.length > 0 ? msgSize : CGSize.zero
//        labelSize.width = min(labelSize.width, maxWidth)
//        totalSize.width = max(totalSize.width, labelSize.width)
//        totalSize.height += labelSize.height
//        if (labelSize.height > 0 && indicatorF.size.height > 0) {
//            totalSize.height += HProgressHUD.kPadding
//        }
//        
//        let remainingHeight = bounds.size.height - totalSize.height - HProgressHUD.kPadding - 4 * margin
//        let maxSize = CGSizeMake(maxWidth, remainingHeight)
//        let detailsSize = detailsLabel!.text!.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: detailsLabel!.font], context: nil).size
//        var detailsLabelSize = detailsLabel!.text!.length > 0 ? detailsSize : CGSize.zero
//        totalSize.width = max(totalSize.width, detailsLabelSize.width)
//        totalSize.height += detailsLabelSize.height
//        if (detailsLabelSize.height > 0 && (indicatorF.size.height > 0 || labelSize.height > 0)) {
//            totalSize.height += HProgressHUD.kPadding
//        }
//        
//        totalSize.width += 2 * margin
//        totalSize.height += 2 * margin
//        
//        // Position elements
//        var yPos = CGFloat(roundf((Float((bounds.size.height - totalSize.height)) / 2))) + margin + yOffset
//        let xPos = xOffset
//        indicatorF.origin.y = yPos
//        indicatorF.origin.x = CGFloat(roundf(Float((bounds.size.width - indicatorF.size.width)) / 2)) + xPos
//        indicator!.frame = indicatorF
//        yPos += indicatorF.size.height
//        
//        if (labelSize.height > 0 && indicatorF.size.height > 0) {
//            yPos += HProgressHUD.kPadding
//        }
//        var labelF: CGRect
//        labelF.origin.y = yPos
//        labelF.origin.x = CGFloat(roundf(Float((bounds.size.width - labelSize.width)) / 2)) + xPos
//        labelF.size = labelSize
//        label!.frame = labelF
//        yPos += labelF.size.height
//        
//        if (detailsLabelSize.height > 0 && (indicatorF.size.height > 0 || labelSize.height > 0)) {
//            yPos += HProgressHUD.kPadding
//        }
//        var detailsLabelF: CGRect
//        detailsLabelF.origin.y = yPos
//        detailsLabelF.origin.x = CGFloat(roundf(Float((bounds.size.width - detailsLabelSize.width)) / 2)) + xPos
//        detailsLabelF.size = detailsLabelSize
//        detailsLabel!.frame = detailsLabelF
//        
//        // Enforce minsize and quare rules
//        if (square) {
//            let max = max(totalSize.width, totalSize.height)
//            if (max <= bounds.size.width - 2 * margin) {
//                totalSize.width = max
//            }
//            if (max <= bounds.size.height - 2 * margin) {
//                totalSize.height = max
//            }
//        }
//        if (totalSize.width < minSize.width) {
//            totalSize.width = minSize.width
//        }
//        if (totalSize.height < minSize.height) {
//            totalSize.height = minSize.height
//        }
//        
//        self.showSize = totalSize
//    }
//    
//    override func draw(_ rect: CGRect) {
//        
//        let context = UIGraphicsGetCurrentContext()
//        UIGraphicsPushContext(context!)
//        
//        if (self.dimBackground) {
//            //Gradient colours
//            let gradLocationsNum = 2
//            let gradLocations = [0.0, 1.0]
//            let gradColors = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75]
//            let colorSpace = CGColorSpaceCreateDeviceRGB()
//            let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum)
////            CGColorSpaceRelease(colorSpace)
//            //Gradient center
//            let gradCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
//            //Gradient radius
//            let gradRadius = min(self.bounds.size.width , self.bounds.size.height)
//            //Gradient draw
//            CGContextDrawRadialGradient (context, gradient, gradCenter,
//                                         0, gradCenter, gradRadius,
//                                         kCGGradientDrawsAfterEndLocation)
//            CGGradientRelease(gradient)
//        }
//        
//        // Set background rect color
//        if self.color != nil {
//            context!.setFillColor(self.color!.cgColor)
//        }else {
//            context!.setFillColor(gray: 0.0, alpha: self.opacity)
//        }
//        
//        
//        // Center HUD
//        let allRect = self.bounds
//        // Draw rounded HUD backgroud rect
//        let boxRect = CGRectMake(CGFloat(roundf(Float((allRect.size.width - showSize!.width)) / 2)) + self.xOffset,
//                                 CGFloat(roundf(Float((allRect.size.height - showSize!.height)) / 2)) + self.yOffset, showSize!.width, showSize!.height)
//        let radius = 10.0
//        context!.beginPath()
//        CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect))
//        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * CGFloat(M_PI) / 2, 0, 0)
//        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, CGFloat(M_PI) / 2, 0)
//        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, CGFloat(M_PI) / 2, CGFloat(M_PI), 0)
//        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(M_PI), 3 * CGFloat(M_PI) / 2, 0)
//        context!.closePath()
//        context!.fillPath()
//        
//        UIGraphicsPopContext()
//    }
//    
//    private func registerForKVO() {
//        for keyPath in self.observableKeypaths() {
//            self.addObserver(self, forKeyPath: keyPath as! String, options: .new, context: nil)
//        }
//    }
//    
//    private func unregisterFromKVO() {
//        for keyPath in self.observableKeypaths() {
//            self.removeObserver(self, forKeyPath: keyPath as! String)
//        }
//    }
//    
//    private func observableKeypaths() -> NSArray {
//        return ["mode", "customView", "labelText", "labelFont", "detailsLabelText", "detailsLabelFont", "progress"]
//    }
//    
//    func observeValueForKeyPath(_ keyPath: String, ofObject object: AnyObject, change: NSDictionary, context: Any) {
//        if !Thread.isMainThread {
//            self.perform(#selector(updateUIForKeypath(_:)), with: keyPath, afterDelay: 0)
////                [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
//        }else {
//            self.updateUIForKeypath(keyPath)
//        }
//    }
//    
//    @objc private func updateUIForKeypath(_ keyPath: String) {
//        if keyPath.isEqual("mode") || keyPath.isEqual("customView") {
//            self.updateIndicators()
//        } else if keyPath.isEqual("labelText") {
//            label!.text = self.labelText;
//        } else if keyPath.isEqual("labelFont") {
//            label!.font = self.labelFont;
//        } else if keyPath.isEqual("detailsLabelText") {
//            detailsLabel!.text = self.detailsLabelText;
//        } else if keyPath.isEqual("detailsLabelFont") {
//            detailsLabel!.font = self.detailsLabelFont;
//        } else if keyPath.isEqual("progress") {
//            if indicator!.responds(toSelector: #selector(setProgress(_:))) {
//                indicator!.progress = progress
//            }
//            return
//        }
//        self.setNeedsLayout()
//        self.setNeedsDisplay()
//    }
//    
//    private func registerForNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIScreen.capturedDidChangeNotification, object: nil)
//    }
//    
//    private func unregisterFromNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    @objc private func deviceOrientationDidChange(_ notification: NSNotification) {
//        let superview = self.superview
//        if superview == nil {
//            return
//        }else if superview != nil, superview!.isKind(of: UIWindow.self) {
//            self.transformForCurrentOrientation = true
//        }else {
//            self.bounds = self.superview!.bounds
//            self.setNeedsDisplay()
//        }
//    }
//        
//    private func setTransformForCurrentOrientation(_ animated: Bool) {
//        // Stay in sync with the superview
//        if self.superview != nil {
//            self.bounds = self.superview!.bounds
//            self.setNeedsDisplay()
//        }
//        
//        let orientation = UIApplication.shared.statusBarOrientation
//        var radians: CGFloat = 0
//
//        if orientation.isLandscape {
//            if (orientation == UIInterfaceOrientation.landscapeLeft) { radians = -CGFloat(M_PI_2) }
//            else { radians = CGFloat(M_PI_2) }
//            // Window coordinates differ!
//            self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width)
//        }else {
//            if (orientation == UIInterfaceOrientation.portraitUpsideDown) { radians = CGFloat(M_PI) }
//            else { radians = 0 }
//        }
//        rotationTransform = CGAffineTransformMakeRotation(CGFloat(radians))
//        
//        if (animated) {
//            UIView.beginAnimations(nil, context: nil)
//        }
//        self.transform = rotationTransform!
//        if animated {
//            UIView.commitAnimations()
//        }
//    }
//
//}
//
//@objc protocol HProgressHUDDelegate: NSObjectProtocol {
// 
//    @objc optional
//            
//    /**
//    * Called after the HUD was fully hidden from the screen.
//    */
//    func hudWasHidden(_ hud: HProgressHUD)
// 
//}
//
///**
//* A progress view for showing definite progress by filling up a circle (pie chart).
//*/
//class MBRoundProgressView: UIView {
//
//    /**
//    * Progress (0.0 to 1.0)
//    */
//    var progress: CGFloat
//
//    //        @property (nonatomic, assign) float progress;
//
//    /**
//    * Indicator progress color.
//    * Defaults to white [UIColor whiteColor]
//    */
//    var progressTintColor: UIColor?
//
//    //        @property (nonatomic, H_STRONG) UIColor *progressTintColor;
//
//    /**
//    * Indicator background (non-progress) color.
//    * Defaults to translucent white (alpha 0.1)
//    */
//    var backgroundTintColor: UIColor?
//
//    //        @property (nonatomic, H_STRONG) UIColor *backgroundTintColor;
//
//    /*
//    * Display mode - NO = round or YES = annular. Defaults to round.
//    */
//    var annular: Bool
//
//    //        @property (nonatomic, assign, getter = isAnnular) BOOL annular;
//                    
////    override init() {
////        self(frame:CGRect(x: 0, y: 0, width: 37, height: 37))
////    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//        self.isOpaque = false
//        progress = 0
//        annular = false
//                
//        progressTintColor = UIColor(white: 1, alpha: 1)
//        backgroundTintColor = UIColor(white: 1, alpha: 1)
//        self.registerForKVO()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        self.unregisterFromKVO()
//    }
//
////    #pragma mark - Drawing
//
//    override func draw(_ rect: CGRect) {
//        
//        let allRect = self.bounds
//        let circleRect = CGRectInset(allRect, 2.0, 2.0)
//        let context = UIGraphicsGetCurrentContext()
//        
//        if annular {
//            // Draw background
//            let lineWidth: CGFloat = 5
//            let processBackgroundPath: UIBezierPath = UIBezierPath.bezierPath()
//            processBackgroundPath.lineWidth = lineWidth
//            processBackgroundPath.lineCapStyle = kCGLineCapRound
//            let center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
//            let radius = (self.bounds.size.width - lineWidth)/2
//            let startAngle = -(CGFloat(M_PI) / 2) // 90 degrees
//            let endAngle = (2 * CGFloat(M_PI)) + startAngle
//            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//            _backgroundTintColor.set()
//            processBackgroundPath.stroke()
//            // Draw progress
//            let processPath: UIBezierPath = UIBezierPath.bezierPath
//            processPath.lineCapStyle = kCGLineCapRound
//            processPath.lineWidth = lineWidth
//            endAngle = (self.progress * 2 * CGFloat(M_PI)) + startAngle
//            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//            _progressTintColor.set()
//            processPath.stroke()
//        }else {
//            // Draw background
//            _progressTintColor.setStroke()
//            _backgroundTintColor.setFill()
//            CGContextSetLineWidth(context, 2.0)
//            CGContextFillEllipseInRect(context, circleRect)
//            CGContextStrokeEllipseInRect(context, circleRect)
//            // Draw progress
//            let center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2)
//            let radius = (allRect.size.width - 4) / 2
//            let startAngle = -(CGFloat(M_PI) / 2) // 90 degrees
//            let endAngle = (self.progress * 2 * CGFloat(M_PI)) + startAngle
//            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0) // white
//            CGContextMoveToPoint(context, center.x, center.y)
//            CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
//            CGContextClosePath(context)
//            CGContextFillPath(context)
//        }
//    }
//
//    //    #pragma mark - KVO
//
//    func registerForKVO() {
//        for let keyPath: NSString in self.observableKeypaths() {
//            self.addObserver(self, forKeyPath: KeyPath, options: .new, context: nil)
//        }
//    }
//
//    func unregisterFromKVO() {
//        for let keyPath: NSString in self.observableKeypaths() {
//            self.removeObserver(self, forKeyPath: KeyPath)
//        }
//    }
//
//    func observableKeypaths() -> NSArray {
//        return ["progressTintColor", "backgroundTintColor", "progress", "annular"]
//    }
//
//    func observeValueForKeyPath(_ keyPath: NSString, ofObject object: AnyObject, change change: NSDictionary, context context: Any) {
//        self.setNeedsDisplay()
//    }
// 
//}
//
//
///**
//* A flat bar progress view.
//*/
//class MBBarProgressView: UIView {
// 
//    /**
//    * Progress (0.0 to 1.0)
//    */
//    var progress: CGFloat
//
//    //        @property (nonatomic, assign) float progress;
//
//    /**
//    * Bar border line color.
//    * Defaults to white [UIColor whiteColor].
//    */
//    var lineColor: UIColor?
//
//    //        @property (nonatomic, H_STRONG) UIColor *lineColor;
//
//    /**
//    * Bar background color.
//    * Defaults to clear [UIColor clearColor];
//    */
//    var progressRemainingColor: UIColor?
//
//    //        @property (nonatomic, H_STRONG) UIColor *progressRemainingColor;
//
//    /**
//    * Bar progress color.
//    * Defaults to white [UIColor whiteColor].
//    */
//    var progressColor: UIColor?
//    //        @property (nonatomic, H_STRONG) UIColor *progressColor;
//                
////    @implementation MBBarProgressView
//
//    //#pragma mark - Lifecycle
//
//    required init() {
//        return self(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        _progress = 0
//        _lineColor = UIColor.white
//        _progressColor = UIColor.white
//        _progressRemainingColor = UIColor.clear
//        self.backgroundColor = UIColor.clear
//        self.opaque = false
//        self.registerForKVO()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        self.unregisterFromKVO()
//    }
//
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        
//        // setup properties
//        CGContextSetLineWidth(context, 2)
//        CGContextSetStrokeColorWithColor(context,[_lineColor CGColor])
//        CGContextSetFillColorWithColor(context, [_progressRemainingColor CGColor])
//        
//        // draw line border
//        var radius = (rect.size.height / 2) - 2
//        CGContextMoveToPoint(context, 2, rect.size.height/2)
//        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius)
//        CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2)
//        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius)
//        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius)
//        CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2)
//        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius)
//        CGContextFillPath(context)
//        
//        // draw progress background
//        CGContextMoveToPoint(context, 2, rect.size.height/2)
//        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius)
//        CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2)
//        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius)
//        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius)
//        CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2)
//        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius)
//        CGContextStrokePath(context)
//        
//        // setup to draw progress color
//        CGContextSetFillColorWithColor(context, [_progressColor CGColor])
//        radius = radius - 2
//        let amount = self.progress *rect.size.width
//        
//        // if progress is in the middle area
//        if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
//            // top
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            CGContextAddLineToPoint(context, amount, 4)
//            CGContextAddLineToPoint(context, amount, radius + 4)
//            
//            // bottom
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            CGContextAddLineToPoint(context, amount, rect.size.height - 4)
//            CGContextAddLineToPoint(context, amount, radius + 4)
//            
//            CGContextFillPath(context)
//        }
//        
//        // progress is in the right arc
//        else if (amount > radius + 4) {
//            let x = amount - (rect.size.width - radius - 4)
//            
//            // top
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4)
//            var angle = -acos(x/radius)
//            if (isnan(angle)) angle = 0
//            CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, M_PI, angle, 0)
//            CGContextAddLineToPoint(context, amount, rect.size.height/2)
//            
//            // bottom
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4)
//            angle = acos(x/radius)
//            if (isnan(angle)) angle = 0
//            CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -M_PI, angle, 1)
//            CGContextAddLineToPoint(context, amount, rect.size.height/2)
//            
//            CGContextFillPath(context)
//        }
//        
//        // progress is in the left arc
//        else if (amount < radius + 4 && amount > 0) {
//            // top
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            CGContextAddLineToPoint(context, radius + 4, rect.size.height/2)
//            
//            // bottom
//            CGContextMoveToPoint(context, 4, rect.size.height/2)
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            CGContextAddLineToPoint(context, radius + 4, rect.size.height/2)
//            
//            CGContextFillPath(context)
//        }
//    }
//
//    //#pragma mark - KVO
//
//    func registerForKVO() {
//        for let keyPath: NSString in self.observableKeypaths() {
//            self.addObserver(self, forKeyPath: KeyPath, options: .new, context: nil)
//        }
//    }
//
//    func unregisterFromKVO() {
//        for let keyPath: NSString in self.observableKeypaths() {
//            self.removeObserver(self, forKeyPath: KeyPath)
//        }
//    }
//
//    func observableKeypaths() -> NSArray {
//        return ["lineColor", "progressRemainingColor", "progressColor", "progress"]
//    }
//
//    func observeValueForKeyPath(_ keyPath: NSString, ofObject object: AnyObject, change change: NSDictionary, context context: Any) {
//        self.setNeedsDisplay()
//    }
// 
//}
