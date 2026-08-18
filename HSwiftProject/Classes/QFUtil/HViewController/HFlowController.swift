//
//  HFlowController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import MJRefresh

class HFlowController: HViewController, HFlowViewDelegate {

    lazy var flowView: HFlowView = {
        return HFlowView(frame: .zero)
    }()

    /// 是否在 `viewWillLayoutSubviews` 里自动摆 `flowView`。默认 YES。
    var autoLayout: Bool = true
    /// 是否为导航栏留出顶部空间。默认 YES。
    var topExtendedLayout: Bool = true
    /// 额外扣掉的底部高度。默认 0。
    var bottomExtendedHeight: CGFloat = 0.0
    /// 额外 contentInset。不要整份覆盖 MJRefresh 正在改的 `top`。
    var extendedInset: UIEdgeInsets = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.isIPhoneX {
            extendedInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.bottomBarHeight, right: 0)
        }
        flowView.delegate = self
        view.addSubview(flowView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            flowView.releaseFlowBlock()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard autoLayout else { return }

        var frame = view.bounds
        if topExtendedLayout {
            frame.origin.y += UIScreen.topBarHeight
            frame.size.height -= UIScreen.topBarHeight
        }
        frame.size.height -= bottomExtendedHeight
        flowView.frame = frame

        guard extendedInset != .zero else { return }
        // 不要整份覆盖 contentInset：MJRefresh 刷新时会改 top，下一帧 layout 会把刷新头踩掉。
        var inset = flowView.contentInset
        inset.left = extendedInset.left
        inset.right = extendedInset.right
        inset.bottom = extendedInset.bottom
        if flowView.mj_header == nil {
            inset.top = extendedInset.top
        }
        if flowView.contentInset != inset {
            flowView.contentInset = inset
        }
    }
}
