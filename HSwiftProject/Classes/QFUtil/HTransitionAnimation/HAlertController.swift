//
//  HAlertController.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

enum HAlertControllerStyle: Int {
    case style0 = 0 // 内容、一个操作按钮
    case style1 = 1 // 内容、两个操作按钮
    case style2 = 2 // 标题、内容、一个操作按钮
    case style3 = 3 // 标题、内容、两个操作按钮
}

typealias HAlertActionBlock = () -> Void

class HAlertController : HViewController, HTupleViewDelegate {
    
    // container高度
    private var containerHeight: CGFloat = 0.0
    // alert类型
    private var alertStyle: HAlertControllerStyle = .style0 {
        didSet {
            switch alertStyle {
            case .style0, .style1, .style2, .style3:
                containerHeight = 150
            }
        }
    }
    // 动作类型
    var alertModel: HAlertModel
    // 取消回调
    var cancelBlock: HAlertActionBlock?
    // 确认回调
    var confirmBlock: HAlertActionBlock?
    
    init(model: HAlertModel, preferredStyle: HAlertControllerStyle) {
        alertModel = model
        // alert类型
        alertStyle = preferredStyle
        // 父类初始化方法
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var containerSize: CGSize {
        return CGSize(width: 291, height: containerHeight)
    }
    
    override var presetType: HTransitionStyle {
        return .alert
    }
    
    private lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blur)
        var frame = CGRect.zero
        frame.size = self.containerSize
        visualView.frame = frame
        return visualView
    }()

    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.tupleFrame({
            var frame = CGRect.zero
            frame.size = self.containerSize
            return frame
        }, exclusiveSections: {
            return []
        })
        tupleView.backgroundColor = UIColor.clear
        tupleView.layer.cornerRadius = 14.0 //默认系统弹框圆角为10.f
        tupleView.isScrollEnabled = false
        tupleView.tupleStatus = .block
        tupleView.disableBounce()
        return tupleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.isHidden = true
        
        //是否隐藏视觉展示效果，如毛玻璃效果
        if self.hideVisualView {
            self.tupleView.backgroundColor = UIColor.white
            self.view.addSubview(self.tupleView)
        } else {
            self.visualView.contentView.addSubview(self.tupleView)
            self.view.addSubview(self.visualView)
        }
        
        // 设置代理
        self.tupleView.delegate = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.hideVisualView {
            self.visualView.subviews.forEach {
                $0.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }

}
