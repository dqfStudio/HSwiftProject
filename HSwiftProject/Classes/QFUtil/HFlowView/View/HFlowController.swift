//
//  HFlowController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/10.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HFlowController: HViewController {
    
    lazy var flowView: HFlowView = {
        return HFlowView(frame: .zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom navigation bar
        self.navigationBar.isHidden = true
        self.flowView.delegate = self
        self.view.addSubview(self.flowView)
        self.flowView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

extension HFlowController: HFlowViewDelegate {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return 8
    }
    func flowItem(_ flow: HFlowView, atIndexPath indexPath: IndexPath) {
        let cell = flow.cell(HFlowLabelCell.self, nil, false, indexPath) as! HFlowLabelCell
        cell.fixedWidth = flow.width(forSection: indexPath.section)
//        cell.fixedHeight = 80
        
        cell.label.backgroundColor = .yellow
        cell.label.numberOfLines = 0
        cell.label.text = "家乐福大数据冯老师复方丹参封疆大吏撒附件打撒丽枫酒店酸辣粉大家酸辣粉离开家我拉的开发机六点多撒会计分录打扫房间领导撒附件都说了咖啡机多少啦咖啡机第三方"
        
        cell.label.snp.makeConstraints { make in
            // 指定宽度
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(cell.fixedWidth)
            
            // 指定高度
//            make.left.top.right.equalToSuperview()
//            make.height.equalTo(cell.fixedHeight)
            
            // 指定宽度和高度
//            make.left.top.equalToSuperview()
//            make.height.equalTo(cell.fixedHeight)
//            make.width.equalTo(cell.fixedWidth)
        }

    }
        
}
