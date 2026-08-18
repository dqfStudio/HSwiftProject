//
//  HFlowController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import MJRefresh

/// 带自定义导航栏的 `HFlowView` 列表页，基于 `HCusViewController`。
///
/// 子类实现 `HFlowViewDelegate` 的数量 / 高度 / `flowRow` 等回调。
/// 隐藏导航栏时请同时把 `topExtendedLayout` 设为 `false`，否则仍会留出导航栏高度。
class HFlowController: HCusViewController, HFlowViewDelegate {

    /// 列表。外部把 `delegate` 设为自身后，实际保存在 `HFlowView.flowDelegate`。
    lazy var flowView: HFlowView = {
        return HFlowView(frame: .zero)
    }()

    /// 是否在 `viewWillLayoutSubviews` 里自动摆 `flowView`。默认 YES。
    var autoLayout: Bool = true {
        didSet {
            guard isViewLoaded, oldValue != autoLayout else { return }
            view.setNeedsLayout()
        }
    }
    /// 是否为导航栏留出顶部空间。默认 YES。与 `prefersNavigationBarHidden` 相互独立。
    var topExtendedLayout: Bool = true {
        didSet {
            guard isViewLoaded, oldValue != topExtendedLayout else { return }
            view.setNeedsLayout()
        }
    }
    /// 额外扣掉的底部高度。默认 0。用于 TabBar 等系统 safe area 覆盖不到的遮挡。
    var bottomExtendedHeight: CGFloat = 0.0 {
        didSet {
            guard isViewLoaded, oldValue != bottomExtendedHeight else { return }
            view.setNeedsLayout()
        }
    }
    /// 额外 contentInset。不要整份覆盖 MJRefresh 正在改的 `top` / `bottom`。
    var extendedInset: UIEdgeInsets = .zero {
        didSet {
            guard isViewLoaded, oldValue != extendedInset else { return }
            view.setNeedsLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        flowView.delegate = self
        HFlowViewHost.install(flowView, on: self)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        super.vcWillDisappear(type)
        HFlowViewHost.releaseIfNeeded(flowView, isViewLoaded: isViewLoaded, type: type)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        HFlowViewHost.layout(
            flowView,
            in: view,
            autoLayout: autoLayout,
            topExtendedLayout: topExtendedLayout,
            bottomExtendedHeight: bottomExtendedHeight,
            extendedInset: extendedInset
        )
    }
}

/// 带自定义导航栏和 ViewModel 绑定的 `HFlowView` 列表页，基于 `HCusBindableController`。
///
/// 使用 `init(viewModel:)` 创建。列表布局规则与 `HFlowController` 相同。
/// pop / dismiss 时先释放列表 block，再走绑定基类的 `destroy()`。
class HFlowBindableController<VM: HBaseViewModel>: HCusBindableController<VM>, HFlowViewDelegate {

    /// 列表。外部把 `delegate` 设为自身后，实际保存在 `HFlowView.flowDelegate`。
    lazy var flowView: HFlowView = {
        return HFlowView(frame: .zero)
    }()

    /// 是否在 `viewWillLayoutSubviews` 里自动摆 `flowView`。默认 YES。
    var autoLayout: Bool = true {
        didSet {
            guard isViewLoaded, oldValue != autoLayout else { return }
            view.setNeedsLayout()
        }
    }
    /// 是否为导航栏留出顶部空间。默认 YES。与 `prefersNavigationBarHidden` 相互独立。
    var topExtendedLayout: Bool = true {
        didSet {
            guard isViewLoaded, oldValue != topExtendedLayout else { return }
            view.setNeedsLayout()
        }
    }
    /// 额外扣掉的底部高度。默认 0。用于 TabBar 等系统 safe area 覆盖不到的遮挡。
    var bottomExtendedHeight: CGFloat = 0.0 {
        didSet {
            guard isViewLoaded, oldValue != bottomExtendedHeight else { return }
            view.setNeedsLayout()
        }
    }
    /// 额外 contentInset。不要整份覆盖 MJRefresh 正在改的 `top` / `bottom`。
    var extendedInset: UIEdgeInsets = .zero {
        didSet {
            guard isViewLoaded, oldValue != extendedInset else { return }
            view.setNeedsLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        flowView.delegate = self
        HFlowViewHost.install(flowView, on: self)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        // 先释放列表再 destroy ViewModel，避免绑定还在写 cell。
        HFlowViewHost.releaseIfNeeded(flowView, isViewLoaded: isViewLoaded, type: type)
        super.vcWillDisappear(type)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        HFlowViewHost.layout(
            flowView,
            in: view,
            autoLayout: autoLayout,
            topExtendedLayout: topExtendedLayout,
            bottomExtendedHeight: bottomExtendedHeight,
            extendedInset: extendedInset
        )
    }
}

/// `HFlowController` 与 `HFlowBindableController` 共用的安装、释放和布局。
private enum HFlowViewHost {

    /// 插到自定义导航栏下面，避免首帧盖住导航栏。
    static func install(_ flowView: HFlowView, on controller: HCusViewController) {
        if let navContainer = controller.navigationBar.superview, navContainer.superview === controller.view {
            controller.view.insertSubview(flowView, belowSubview: navContainer)
        } else {
            controller.view.addSubview(flowView)
        }
    }

    /// 仅在 pop / dismiss 且 view 已加载时释放，避免未 load 时懒加载出 `flowView`。
    static func releaseIfNeeded(_ flowView: HFlowView, isViewLoaded: Bool, type: HVCDisappearType) {
        guard isViewLoaded else { return }
        if type == .pop || type == .dismiss {
            flowView.releaseFlowBlock()
        }
    }

    /// 按本页 safe area 摆 frame；`contentInset` 只写 MJRefresh 没在管的边。
    static func layout(
        _ flowView: HFlowView,
        in view: UIView,
        autoLayout: Bool,
        topExtendedLayout: Bool,
        bottomExtendedHeight: CGFloat,
        extendedInset: UIEdgeInsets
    ) {
        guard autoLayout else { return }

        var frame = view.bounds
        if topExtendedLayout {
            // 首帧尚未进窗口时 safeAreaInsets.top 可能是 0，回退到状态栏高度。
            let topInset = view.safeAreaInsets.top > 0 ? view.safeAreaInsets.top : UIScreen.statusBarHeight
            let top = topInset + UIScreen.naviBarHeight
            frame.origin.y += top
            frame.size.height -= top
        }
        frame.size.height -= bottomExtendedHeight
        // 与 home indicator 的重叠从 frame 扣掉，不走 contentInset，避免和 mj_footer 抢 bottom。
        let safeBottomY = view.bounds.maxY - view.safeAreaInsets.bottom
        frame.size.height -= max(0, frame.maxY - safeBottomY)
        if frame.size.height < 0 {
            frame.size.height = 0
        }
        if flowView.frame != frame {
            flowView.frame = frame
        }

        // 不要整份覆盖 contentInset：MJRefresh 刷新时会改 top / bottom。
        var inset = flowView.contentInset
        inset.left = extendedInset.left
        inset.right = extendedInset.right
        if flowView.mj_header == nil {
            inset.top = extendedInset.top
        }
        if flowView.mj_footer == nil {
            inset.bottom = extendedInset.bottom
        }
        if flowView.contentInset != inset {
            flowView.contentInset = inset
        }
    }
}
