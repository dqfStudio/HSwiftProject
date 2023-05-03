//
//  HAlertController.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

enum HAlertControllerStyle: Int {
    case alert = 0
    case actionSheet = 1
}

class HAlertController : HViewController, HTupleViewDelegate {
    
    // 标题
    private var _title: String?
    // 消息
    private var _message: String?
    // 消息高度
    private var _messageHeight: CGFloat = 0.0
    // alert类型
    private var alertStyle: HAlertControllerStyle = .alert
    // 动作类型
    private var actions: [HAlertAction] = [HAlertAction]()
    

    init(title: String?, message: String?, preferredStyle: HAlertControllerStyle) {
        _title = title
        _message = message
        // 测量文字高度
        _messageHeight = _message?.heightWithFont(UIFont.systemFont(ofSize: 12), constrainedToWidth: UIScreen.width - 30) ?? 0
        // 高度不小于35
        _messageHeight = max(_messageHeight, 35)
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
        return CGSize(width: 270, height: 42.5 + _messageHeight + 1 + 42.5)
    }
    
    override var presetType: HTransitionStyle {
        return .alert
    }

    private lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: blur)
    }()

    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.backgroundColor = UIColor.clear
        tupleView.layer.cornerRadius = 10 //默认系统弹框圆角为10.f
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    // 添加动作类型
    func addAction(_ action: HAlertAction) {
        actions.append(action)
    }

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
        
        // 设置frame
        self.visualView.frame.size = self.containerSize
        self.tupleView.frame.size = self.containerSize
        
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

    func numberOfSectionsInTupleView() -> Any {
        return 3
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return actions.count == 2 ? 5 : 4
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case HCell0:
            return CGSize(width: self.tupleView.width, height: 42.5)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: _messageHeight)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 1)
        case HCell3:
            if actions.count == 1 {
                return CGSize(width: self.tupleView.width, height: 42.5)
            } else if actions.count == 2 {
                return CGSize(width: self.tupleView.width / 2, height: 42.5)
            }
        case HCell4:
            return CGSize(width: self.tupleView.width / 2, height: 42.5)
        default:
            break
        }
        return CGSize.zero
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsets(top: 0, left: 15, bottom: 2.5, right: 15)
        case HCell1:
            return UIEdgeInsets(top: 2.5, left: 15, bottom: 0, right: 15)
        case HCell2, HCell3, HCell4:
            return UIEdgeInsets.zero
        default:
            break
        }
        return UIEdgeInsets.zero
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        // 判断执行Cell顺序
        var row = indexPath.row
        if row == HCell3, actions.count == 1, let action = actions.first {
            if action.style == .cancel {
                row = HCell3
            } else if action.style == .confirm {
                row = HCell4
            }
        }
        
        switch row {
        case HCell0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#0B0A0C")
            cell.label.text = _title
        case HCell1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#070507")
            cell.label.text = _message
        case HCell2:
            let cell = itemBlock(nil, HTupleBlankCell.self, nil, true) as! HTupleBlankCell
            cell.blank.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        case HCell3:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            var bounds = cell.layoutViewBounds
            bounds = CGRect(x: bounds.width - 1, y: 0, width: 1, height: bounds.height)
            cell.label.addSubLayer(withFrame: bounds, color: UIColor(white: 0.1, alpha: 0.2))
            cell.label.textColor = HColorHex("#3184DD")
            if let cancelAction = actions.first(where: { $0.style == .cancel }) {
                cell.label.text = cancelAction.title
            }
        case HCell4:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#3184DD")
            if let confirmAction = actions.first(where: { $0.style == .confirm }) {
                cell.label.text = confirmAction.title
            }
        default:
            break
        }
    }
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        
        // 判断执行Cell顺序
        var row = indexPath.row
        if row == HCell3, actions.count == 1, let action = actions.first {
            if action.style == .cancel {
                row = HCell3
            } else if action.style == .confirm {
                row = HCell4
            }
        }
        
        // 调用相关方法
        if row == HCell3, let cancelAction = actions.first(where: { $0.style == .cancel }) {
            cancelAction.handler?(.cancel)
        } else if row == HCell4, let confirmAction = actions.first(where: { $0.style == .confirm }) {
            confirmAction.handler?(.confirm)
        }
    }

}
