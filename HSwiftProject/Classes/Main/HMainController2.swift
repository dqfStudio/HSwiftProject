//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let toolbar = HScrollbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))
////        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))
//
////        var items = [UIBarButtonItem]()
////
//////        let item1 = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector())
////        let item1 = UIBarButtonItem()
////        item1.title = "item1"
////
////        let item2 = UIBarButtonItem()
////        item2.title = "item2"
////
//////        let item2 = UIBarButtonItem(title: "item2", menu: nil)
//////        UIBarItem
////
////        items.append(item1)
////        items.append(item2)
////        toolbar.setItems(items, animated: false)
//
//
//        toolbar.titleColor = .blue
//        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
//        toolbar.titleBGColor = .green
//
//        toolbar.titleSelectedColor = .red
//        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
//        toolbar.titleSelectedBGColor = .yellow
//
//        toolbar.items = ["item1", "item2", "item3", "item4", "item5", "item6"]
//        toolbar.itemWidth = UIScreen.width / 6
//
//        toolbar.isScrollEnabled = false
//
//        toolbar.selectedIndex = 1
//
//        toolbar.selectedBlock = { index in
//            NSLog(index)
//        }
//
//        toolbar.cornerRadius = 20
////        toolbar.backgroundColor = .green
//        self.view.addSubview(toolbar)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let multiButtonView = HMultiButtonView(frame: CGRect(x: 10, y: 200, width: 320, height: 80))
//        multiButtonView.spacing = 10
//        self.view.addSubview(multiButtonView)
//
//        multiButtonView.button.backgroundColor = .red
//
//        multiButtonView.detailButton.backgroundColor = .blue
//
//        multiButtonView.accessoryButton.backgroundColor = .green
//
//        return
        
//        let searchBar = HSearchBar(frame: CGRect(x: 10, y: 200, width: 320, height: 80))
//
////        searchBar.cornerRadius = 40
//
//        if searchBar.leftView == nil {
//            searchBar.leftView = UIView()
//            searchBar.leftView?.backgroundColor = .green
////            searchBar.leftWidth = 40
//            searchBar.leftSpace = 5
//        }
//
//        searchBar.textField.text = "fffff"
//        searchBar.textField.backgroundColor = .yellow
//
//        if searchBar.rightView == nil {
//            searchBar.rightView = UIView()
//            searchBar.rightView?.backgroundColor = .blue
////            searchBar.rightWidth = 40
//            searchBar.rightSpace = 15
//        }
//
//        searchBar.backgroundColor = .red
//        self.view.addSubview(searchBar)
//
//        return
        
//        let button = HWebActionView()
//        button.frame = CGRect(x: 10, y: 200, width: 320, height: 80)
        
//        let imageView = UIImageView(frame: CGRect(x: 10, y: 200, width: 320, height: 80))
//        let tintColor = imageView.tintColor
        
//        let button = HWebActionView(frame: CGRect(x: 10, y: 200, width: 320, height: 80))
        let button = HWebButtonView(frame: CGRect(x: 10, y: 200, width: 320, height: 80))
        self.view.addSubview(button)
        
        button.imageSize = CGSize(width: 8, height: 12)
        
        let image = UIImage(named: "icon_tuple_arrow_right")
        button.image = image
        
        
//        let string = "https://freechatoss.s3.ap-southeast-1.amazonaws.com/images/Group_Chat_Banner_English.png"

//        button.setImageUrlString(string)
        
//        if button.hasImage {
//            button.renderColor = .green
//        } else {
            button.renderColor = .yellow
//        }
        
        button.text = "啊发来的撒酒疯拉的屎"
        
        button.imagePosition = .top
        button.imageSpace = 15
        
        button.backgroundColor = .red
//        self.view.addSubview(button)
        
        return
        
//        let sectionView = HSectionView(frame: CGRect(x: 10, y: 200, width: 320, height: 120))
//        sectionView.backgroundColor = .gray
//        self.view.addSubview(sectionView)
//
//
//        sectionView.headerWidth = 40
//        sectionView.headerSpace = 5
//        if sectionView.header == nil {
//            let header = UIView()
//            header.backgroundColor = .red
//            sectionView.header = header
//        }
//
//
//        sectionView.footerWidth = 40
//        sectionView.footerSpace = 5
//        if sectionView.footer == nil {
//            let footer = UIView()
//            footer.backgroundColor = .blue
//            sectionView.footer = footer
//        }
//
//
//        if sectionView.item == nil {
//            let item = UIView()
//            item.backgroundColor = .yellow
//            sectionView.item = item
//        }
//
//        sectionView.reloadData()
//
//        return
        
        let stackView = UIStackView(frame: CGRect(x: 100, y: 200, width: 120, height: UIScreen.width))
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill

        let leftEdgeSpaceView = UIView()
        leftEdgeSpaceView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(leftEdgeSpaceView)

        let leftItemView = UIImageView()
        leftItemView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        leftItemView.backgroundColor = .red
        stackView.addArrangedSubview(leftItemView)
        leftItemView.image = UIImage(named: "hvc_back_icon")
        leftItemView.contentMode = .bottom

        let leftTitleSpaceView = UIView()
        leftTitleSpaceView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(leftTitleSpaceView)
        
        let titleView = HLabel()
        titleView.backgroundColor = .blue
        stackView.addArrangedSubview(titleView)
        titleView.text = "啊发来的撒酒疯拉的屎"
//        titleView.contentMode = .top
        
        titleView.numberOfLines = 0 // Set to 0 for multiline labels
        titleView.textAlignment = .left // Set your desired text alignment
        titleView.verticalAlignment = .top // Set vertical alignment to top
        

        let rightTitleSpaceView = UIView()
        rightTitleSpaceView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(rightTitleSpaceView)

        let rightItemView = UIView()
        rightItemView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        rightItemView.backgroundColor = .yellow
        stackView.addArrangedSubview(rightItemView)

        let rightEdgeSpaceView = UIView()
        rightEdgeSpaceView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(rightEdgeSpaceView)
        
        view.addSubview(stackView)
        
        

//        let stackView = UIStackView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 120))
//        stackView.axis = .horizontal
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//
//        let leftEdgeSpaceView = UIView()
//        leftEdgeSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(leftEdgeSpaceView)
//
//        let leftItemView = UIImageView()
//        leftItemView.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        leftItemView.backgroundColor = .red
//        stackView.addArrangedSubview(leftItemView)
//        leftItemView.image = UIImage(named: "hvc_back_icon")
//        leftItemView.contentMode = .right
//
//        let leftTitleSpaceView = UIView()
//        leftTitleSpaceView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        stackView.addArrangedSubview(leftTitleSpaceView)
//
//        let titleView = UILabel()
//        titleView.backgroundColor = .blue
//        stackView.addArrangedSubview(titleView)
//        titleView.text = "啊发来的撒酒疯拉的屎"
//
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
//        view.addSubview(stackView)


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
