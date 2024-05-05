//
//  HAlertController2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

//import UIKit
//
//enum HAlertControllerStyle: Int {
//    case alert = 0
//    case actionSheet = 1
//}
//
//class HAlertController: HViewController, HTupleViewDelegate {
//
//    // 标题
//    private var _title: String?
//    // 消息
//    private var _message: String?
//    // 消息高度
//    private var _messageHeight: CGFloat = 0.0
//    // alert类型
//    private var alertStyle: HAlertControllerStyle = .alert
//    // 动作类型
//    private var actions: [HAlertAction] = [HAlertAction]()
//
//
//    init(title: String?, message: String?, preferredStyle: HAlertControllerStyle) {
//        _title = title
//        _message = message
//        // 测量文字高度
//        _messageHeight = _message?.heightWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToWidth: UIScreen.width - 48) ?? 0
//        // 高度不小于24
//        _messageHeight = max(_messageHeight, 24)
//        // alert类型
//        alertStyle = preferredStyle
//        // 父类初始化方法
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override var containerSize: CGSize {
//        let titleHeight = 24 + 24 + 12
//        let messageHeight = 12 + _messageHeight + 24
//        return CGSize(width: 291, height: titleHeight + Int(messageHeight) + 1 + 48)
//    }
//
//    override var presentType: HTransitionStyle {
//        return .alert
//    }
//
//    private lazy var visualView: UIVisualEffectView = {
//        let blur = UIBlurEffect(style: .light)
//        return UIVisualEffectView(effect: blur)
//    }()
//
//    private lazy var tupleView: HTupleView = {
//        let tupleView = HTupleView(frame: .zero)
//        tupleView.backgroundColor = UIColor.clear
//        tupleView.layer.cornerRadius = 10 //默认系统弹框圆角为10.f
//        tupleView.isScrollEnabled = false
//        tupleView.disableBounce()
//        return tupleView
//    }()
//
//    // 添加动作类型
//    func addAction(_ action: HAlertAction) {
//        actions.append(action)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.clear
//        self.navigationBar.isHidden = true
//
//        //是否隐藏视觉展示效果，如毛玻璃效果
//        if self.hideVisualView {
//            self.tupleView.backgroundColor = UIColor.white
//            self.view.addSubview(self.tupleView)
//        } else {
//            self.visualView.contentView.addSubview(self.tupleView)
//            self.view.addSubview(self.visualView)
//        }
//
//        // 设置frame
//        self.visualView.frame.size = self.containerSize
//        self.tupleView.frame.size = self.containerSize
//
//        // 设置代理
//        self.tupleView.delegate = self
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if !self.hideVisualView {
//            self.visualView.subviews.forEach {
//                $0.layer.cornerRadius = self.tupleView.layer.cornerRadius
//            }
//        }
//    }
//
//    override func vcWillDisappear(_ type: HVCDisappearType) {
//        if type == .pop || type == .dismiss {
//            self.tupleView.releaseTupleBlock()
//        }
//    }
//
//    func numberOfSectionsInTupleView() -> Any {
//        return 3
//    }
//    func numberOfItemsInSection(_ section: Any) -> Any {
//        return actions.count == 2 ? 5 : 4
//    }
//    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        switch indexPath.row {
//        case HCell0:
//            return CGSize(width: self.tupleView.width, height: 60)
//        case HCell1:
//            return CGSize(width: self.tupleView.width, height: _messageHeight)
//        case HCell2:
//            return CGSize(width: self.tupleView.width, height: 1)
//        case HCell3:
//            if actions.count == 1 {
//                return CGSize(width: self.tupleView.width, height: 48)
//            } else if actions.count == 2 {
//                return CGSize(width: self.tupleView.width / 2, height: 48)
//            }
//        case HCell4:
//            return CGSize(width: self.tupleView.width / 2, height: 48)
//        default:
//            break
//        }
//        return CGSize.zero
//    }
//    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        switch (indexPath.row) {
//        case HCell0:
//            return UIEdgeInsets(top: 24, left: 24, bottom: 12, right: 24)
//        case HCell1:
//            return UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)
//        case HCell2, HCell3, HCell4:
//            return UIEdgeInsets.zero
//        default:
//            break
//        }
//        return UIEdgeInsets.zero
//    }
//    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
//        //
//        // 判断执行Cell顺序
//        var row = indexPath.row
//        if row == HCell3, actions.count == 1, let action = actions.first {
//            if action.style == .cancel {
//                row = HCell3
//            } else if action.style == .confirm {
//                row = HCell4
//            }
//        }
//
//        switch row {
//        case HCell0:
//            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
//            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
//            cell.label.textAlignment = .center
//            cell.label.textColor = HColorHex("#17191E")
//            cell.label.text = _title
//        case HCell1:
//            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
//            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
//            cell.label.textAlignment = .center
//            cell.label.numberOfLines = 0
//            cell.label.textColor = HColorHex("#17191E")
//            cell.label.text = _message
//        case HCell2:
//            let cell = tuple.cell(HTupleBaseCell.self, nil, true, indexPath) as! HTupleBaseCell
//            cell.backgroundColor = HColorHex("#F7F8FA")
//        case HCell3:
//            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
//            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
//            cell.label.textAlignment = .center
//            var bounds = cell.layoutViewBounds
//            bounds = CGRect(x: bounds.width - 1, y: 0, width: 1, height: bounds.height)
//            cell.label.addSubLayer(withFrame: bounds, color: HColorHex("#F7F8FA"))
//            cell.label.textColor = HColorHex("#17191E")
//            if let cancelAction = actions.first(where: { $0.style == .cancel }) {
//                cell.label.text = cancelAction.title
//            }
//        case HCell4:
//            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
//            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
//            cell.label.textAlignment = .center
//            cell.label.textColor = HColorHex("#3879FC")
//            if let confirmAction = actions.first(where: { $0.style == .confirm }) {
//                cell.label.text = confirmAction.title
//            }
//        default:
//            break
//        }
//    }
//    func didSelectCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
//
//        // 判断执行Cell顺序
//        var row = indexPath.row
//        if row == HCell3, actions.count == 1, let action = actions.first {
//            if action.style == .cancel {
//                row = HCell3
//            } else if action.style == .confirm {
//                row = HCell4
//            }
//        }
//
//        // 调用相关方法
//        if row == HCell3, let cancelAction = actions.first(where: { $0.style == .cancel }) {
//            cancelAction.handler?(.cancel)
//        } else if row == HCell4, let confirmAction = actions.first(where: { $0.style == .confirm }) {
//            confirmAction.handler?(.confirm)
//        }
//    }
//
//}
