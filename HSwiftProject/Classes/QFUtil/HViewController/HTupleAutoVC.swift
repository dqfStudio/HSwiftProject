//
//  HTupleAutoVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/10.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleAutoVC: HViewController {
    
    lazy var tupleView: HTupleView = {
        return HTupleView.tupleFrame {
            return .zero
        } mode: {
            return .delegate
        } layout: {
            return HTupleViewLayout(.vertical, .automatic)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom navigation bar
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        self.tupleView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

extension HTupleAutoVC: HTupleViewDelegate {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 4
    }
    func tupleItem(_ flow: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell = flow.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.backgroundColor = UIColor.gray
            
            cell.layoutView.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.right.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(self.tupleView.width - 20)
            }
            cell.label.numberOfLines = 0
            cell.label.text = "家乐福大数据冯老师复方丹参封疆大吏撒附件打撒丽枫酒店酸辣粉大家酸辣粉离开家我拉的开发机六点多撒会计分录打扫房间领导撒附件都说了咖啡机多少啦咖啡机第三方"
            
            cell.separatorView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(self.tupleView.width)
                make.height.equalTo(1)
            }
            
            cell.selectBlock = {
                let tupleAlert = HTupleAlertVC.showRePassErrorAlert { index in }
                self.presentController(tupleAlert, completion: nil)
            }
        case 1:
            let cell = flow.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            cell.backgroundColor = UIColor.gray
            
            cell.layoutView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(self.tupleView.width)
                make.height.equalTo(65)
            }
            
            cell.separatorView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalTo(self.tupleView.width)
            }
            
            cell.imageView.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.height.equalTo(45)
            }
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(WithName: "icon_no_server")
            
            cell.label.backgroundColor = UIColor.red
            cell.label.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(15)
            }
            
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.snp.makeConstraints { make in
                make.top.equalTo(cell.label.snp.bottom)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(15)
            }

            cell.accsryLabel.backgroundColor = UIColor.green
            cell.accsryLabel.snp.makeConstraints { make in
                make.top.equalTo(cell.detailLabel.snp.bottom)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(15)
            }
        case 2:
            let cell = flow.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            cell.backgroundColor = UIColor.gray
            
            cell.layoutView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(self.tupleView.width)
                make.height.equalTo(65)
            }
            
            cell.separatorView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalTo(self.tupleView.width)
            }
            
            cell.imageView.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.height.equalTo(45)
            }
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(WithName: "icon_no_server")
            
            cell.label.backgroundColor = UIColor.red
            cell.label.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-27)
                make.height.equalTo(22.5)
            }
            
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.snp.makeConstraints { make in
                make.top.equalTo(cell.label.snp.bottom)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-27)
                make.height.equalTo(22.5)
            }

            cell.detailView.snp.makeConstraints { make in
                make.left.equalTo(cell.label.snp.right).offset(10)
                make.width.equalTo(7)
                make.height.equalTo(13)
                make.centerY.equalToSuperview()
            }
            cell.detailView.setImage(WithName: "icon_tuple_arrow_right")
        case 3:
            let cell = flow.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            cell.backgroundColor = UIColor.gray
            
            cell.layoutView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(self.tupleView.width)
                make.height.equalTo(65)
            }
            
            cell.separatorView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalTo(self.tupleView.width)
            }
            
            cell.imageView.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.height.equalTo(45)
            }
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(WithName: "icon_no_server")
            
            cell.label.backgroundColor = UIColor.red
            cell.label.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-82)
                make.height.equalTo(22.5)
            }
            
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.snp.makeConstraints { make in
                make.top.equalTo(cell.label.snp.bottom)
                make.left.equalTo(cell.imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-82)
                make.height.equalTo(22.5)
            }
            
            cell.detailView.snp.makeConstraints { make in
                make.left.equalTo(cell.label.snp.right).offset(10)
                make.width.height.equalTo(45)
                make.centerY.equalToSuperview()
            }
            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImage(WithName: "icon_no_server")

            cell.accsryView.snp.makeConstraints { make in
                make.left.equalTo(cell.detailView.snp.right).offset(10)
                make.width.equalTo(7)
                make.height.equalTo(13)
                make.centerY.equalToSuperview()
            }
            cell.accsryView.setImage(WithName: "icon_tuple_arrow_right")
        default:
            break
        }
    }
        
}
