//
//  HSheetController.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HSheetController : HViewController, HTupleViewDelegate {

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
    
    override var containerSize: CGSize {
        var height = 0.0
        height += Double(actions.count * 56 + (actions.count - 1) * 1)
        height += 8 + 56 + (1 + UIScreen.bottomBarHeight)
        return CGSize(width: 270, height: height)
    }
    
    override var presetType: HTransitionStyle {
        return .sheet
    }

    private lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: blur)
    }()

    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.tupleFrame({ () -> CGRect in
            return .zero
        }, exclusiveSections: { () -> NSArray in
            return [0, 1, 2]
        })
        tupleView.backgroundColor = UIColor.clear
        tupleView.setCornerRadiiOnTop(16)
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
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
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}

extension HSheetController {

    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        if _title != nil {
            return 2
        } else {
            return 1
        }
    }
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        if _title != nil {
            switch (indexPath.row) {
            case HCell0:
                return CGSize(width: self.tupleView.width, height: 35)
            case HCell1:
                return CGSize(width: self.tupleView.width, height: 1)
            default:
                break
            }
        } else {
            return CGSize(width: self.tupleView.width, height: 1)
        }
        return CGSize.zero
    }
    @objc
    func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        if _title != nil {
            switch (indexPath.row) {
            case HCell0:
                let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
                cell.label.textColor = UIColor.black
                cell.label.textAlignment = .center
                cell.label.text = _title
                break
            case HCell1:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                cell.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
                break
            default:
                break
            }
        } else {
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = .clear
        }
    }

}


extension HSheetController {

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
            break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let row = indexPath.row % 2
        switch row {
        case 0:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            var button = cell.viewWithTag(12345) as? UIButton
            if button == nil {
                button = UIButton(frame: cell.layoutViewBounds)
                button!.tag = 12345
                button!.textFont = UIFont.font(ofSize: 16, weight: .regular)
                button!.textColor = UIColor.black
                button!.textAlignment = .center
                button!.isUserInteractionEnabled = false
                cell.addSubview(button!)
            }
            // 获取数据
            let index = indexPath.row / 2
            let action: HSheetAction = actions[index]
            // 标题
            button!.text = action.title
            // 图标
            if let image = action.image {
                button!.setImage(UIImage(named: image), for: .normal)
                button!.imageAndTextWithSpacing(8)
            }
        case 1:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        default:
            break
        }
    }
    @objc
    func tupleExa1_didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        let row = indexPath.row % 2
        switch row {
        case 0:
            // 获取数据
            let index = indexPath.row / 2
            let action: HSheetAction = actions[index]
            // 回调
            action.handler?(index)
        case 1:
            break
        default:
            break
        }
    }

}


extension HSheetController {

    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case HCell0:
            return CGSize(width: self.tupleView.width, height: 8)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: 56)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 1 + UIScreen.bottomBarHeight)
        default:
            break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case HCell0:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = UIColor.clear
            break
        case HCell1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 16, weight: .medium)
            cell.label.textColor = UIColor.black
            cell.label.textAlignment = .center
            cell.label.text = cancelAction.title
            break
        case HCell2:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.backgroundColor = UIColor.white
            break
        default:
            break
        }
    }
    @objc
    func tupleExa2_didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        // 回调
        if indexPath.row == HCell1 {
            cancelAction.handler?(-1)
        }
    }

}
