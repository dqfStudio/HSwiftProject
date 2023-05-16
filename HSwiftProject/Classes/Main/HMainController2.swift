//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = HToolbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))
        
//        var items = [UIBarButtonItem]()
//
////        let item1 = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector())
//        let item1 = UIBarButtonItem()
//        item1.title = "item1"
//
//        let item2 = UIBarButtonItem()
//        item2.title = "item2"
//
////        let item2 = UIBarButtonItem(title: "item2", menu: nil)
////        UIBarItem
//
//        items.append(item1)
//        items.append(item2)
//        toolbar.setItems(items, animated: false)
        
        
        toolbar.titleColor = .blue
        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
        toolbar.titleBGColor = .green
        
        toolbar.titleSelectedColor = .red
        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
        toolbar.titleSelectedBGColor = .yellow
        
        toolbar.items = ["item1", "item2", "item3"]
        
        toolbar.selectedBlock = { index in
            NSLog(index)
        }
        
        toolbar.cornerRadius = 20
//        toolbar.backgroundColor = .green
        self.view.addSubview(toolbar)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        let stackView = UIStackView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 120))
//        stackView.axis = .horizontal
//        stackView.distribution = .fill
//        stackView.alignment = .fill
////        stackView.spacing = 8
//
//
//        let leftEdgeSpaceView = UIView()
//        leftEdgeSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(leftEdgeSpaceView)
//
//        let leftItemView = UIView()
//        leftItemView.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        leftItemView.backgroundColor = .red
//        stackView.addArrangedSubview(leftItemView)
//
//        let leftTitleSpaceView = UIView()
//        leftTitleSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(leftTitleSpaceView)
//
//        let titleView = UIView()
//        titleView.backgroundColor = .blue
//        stackView.addArrangedSubview(titleView)
//
//        let rightTitleSpaceView = UIView()
//        rightTitleSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(rightTitleSpaceView)
//
//        let rightItemView = UIView()
//        rightItemView.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        rightItemView.backgroundColor = .yellow
//        stackView.addArrangedSubview(rightItemView)
//
//        let rightEdgeSpaceView = UIView()
//        rightEdgeSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(rightEdgeSpaceView)
//
//        // Add constraints for view1 and view3
////        view1.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
////        view3.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15).isActive = true
//
////        stackView.setCustomSpacing(55, after: view3)
//
//        view.addSubview(stackView)
//
//
//    }

}
