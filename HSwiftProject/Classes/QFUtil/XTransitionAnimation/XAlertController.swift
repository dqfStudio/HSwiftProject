//
//  XAlertController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class XAlertController: HBaseController, HTupleViewDelegate {

    // 标题
    private var _title: String?
    // 取消动作
    private var cancelAction: HSheetAction
    // 动作类型
    private var actions: [HSheetAction] = [HSheetAction]()
    

    init(title: String?, cancelAction: HSheetAction) {
        _title = title
        self.cancelAction = cancelAction
        // 父类初始化方法
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var presentType: HTransitionStyle {
        return .alert
    }
    
    override var isShadowDismiss: Bool {
        return true
    }

    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            return self.view.bounds
        } mode: {
            return .delegate
        } exclusiveSections: {
            return [0, 1, 2]
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        tupleView.backgroundColor = UIColor.clear
        tupleView.roundTopCorners(16)
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        tupleView.outsideCntBlock = { [weak self] in
            self?.naviBack()
        }
        return tupleView
    }()
    
    // 添加动作类型
    func addAction(_ action: HSheetAction) {
        actions.append(action)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear

        // 设置代理
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        
        switch self.presentType {
        case .drop:
            self.tupleView.tupleAlign = .top(0)
        case .alert:
            self.tupleView.tupleAlign = .center
        case .sheet:
            self.tupleView.tupleAlign = .bottom(0)
        default:
            break
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}

extension XAlertController {

    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        if let title = _title, !title.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        if let title = _title, !title.isEmpty {
            switch (indexPath.row) {
            case 0:
                return CGSize(width: self.tupleView.width, height: 35)
            case 1:
                return CGSize(width: self.tupleView.width, height: 1)
            default:
                return CGSize(width: self.tupleView.width, height: 50)
            }
        } else {
            return CGSize(width: self.tupleView.width, height: 1)
        }
    }
    @objc
    func tupleExa0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        if let title = _title, !title.isEmpty {
            switch (indexPath.row) {
            case 0:
                let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
                cell.backgroundColor = UIColor.white
                cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
                cell.label.textColor = UIColor.black
                cell.label.textAlignment = .center
                cell.label.text = title
            case 1:
                let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
                cell.backgroundColor = UIColor(hex: 0xF7F8FA)
            default:
                break
            }
        } else {
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            cell.backgroundColor = UIColor.white
        }
    }

}


extension XAlertController {

    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return actions.count + (actions.count - 1)
    }
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let row = indexPath.row % 2
        switch row {
        case 0:
            return CGSize(width: self.tupleView.width, height: 56)
        case 1:
            return CGSize(width: self.tupleView.width, height: 1)
        default:
            return CGSize(width: self.tupleView.width, height: 50)
        }
    }
    @objc
    func tupleExa1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let row = indexPath.row % 2
        switch row {
        case 0:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            cell.backgroundColor = UIColor.white
            var button = cell.viewWithTag(12345) as? HWebButtonView
            if button == nil {
                button = HWebButtonView(frame: cell.layoutViewBounds)
                button!.imageSpace = 8
                button!.tag = 12345
                button!.textFont = UIFont.font(ofSize: 16, weight: .regular)
                button!.textColor = UIColor.black
                button!.textAlignment = .center
                button!.isUserInteractionEnabled = false
                cell.addSubview(button!)
            }
            // 获取数据
            let index = indexPath.row / 2
            let action: HSheetAction = self.actions[index]
            // 标题
            button!.text = action.title
            // 图标
            if let image = action.image {
                button!.image = UIImage(named: image)
            }
            cell.selectBlock = {
                // 获取数据
                let index = indexPath.row / 2
                let action: HSheetAction = self.actions[index]
                // 回调
                action.handler?(index)
                self.naviBack()
            }
        case 1:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            cell.backgroundColor = UIColor(hex: 0xF7F8FA)
        default:
            break
        }
    }

}


extension XAlertController {

    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: self.tupleView.width, height: 8)
        case 1:
            return CGSize(width: self.tupleView.width, height: 56)
        case 2:
            return CGSize(width: self.tupleView.width, height: 1 + UIScreen.bottomBarHeight)
        default:
            return CGSize(width: self.tupleView.width, height: 50)
        }
    }
    @objc
    func tupleExa2_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            cell.backgroundColor = UIColor(hex: 0xF7F8FA)
        case 1:
            let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.backgroundColor = UIColor.white
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textColor = UIColor.black
            cell.label.textAlignment = .center
            cell.label.text = self.cancelAction.title
            cell.selectBlock = {
                self.cancelAction.handler?(-1)
                self.naviBack()
            }
            break
        case 2:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            cell.backgroundColor = UIColor.white
        default:
            break
        }
    }

}
