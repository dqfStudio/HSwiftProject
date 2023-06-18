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
        
        let webActionView = HWebActionView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 60))
        webActionView.backgroundColor = .red
//        webActionView.setImageUrlString("https://d1e084oasoo524.cloudfront.net/images/Group_Chat-Banner.png")
        webActionView.imagePosition = .right
//        webActionView.renderColor = .yellow
        webActionView.imageSpace = 10
//        webActionView.imageView.image = UIImage(named: "hvc_back_icon")
        webActionView.setImage(WithName: "hvc_back_icon")
//        webActionView.imageSize = CGSize(width: 23, height: 23)
        
//        webActionView.imageView.backgroundColor = .green
        webActionView.titleLabel.text = "封疆大吏是否能啦"
//        webActionView.titleLabel.font = UIFont.systemFont(ofSize: 17)
//        webActionView.titleLabel.backgroundColor = .blue
        
        webActionView.pressed = { (_ sender: Any?, _ data: Any?) in
            NSLog("")
        }
        
        self.view.addSubview(webActionView)
        return

        let toolbar = HScrollbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))

        toolbar.titleColor = .blue
        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
        toolbar.titleBGColor = .green

        toolbar.titleSelectedColor = .red
        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
        toolbar.titleSelectedBGColor = .yellow

        toolbar.items = ["item1", "item2", "item3", "item4", "item5", "item6"]
        toolbar.itemWidth = UIScreen.width / 6

        toolbar.isScrollEnabled = false

        toolbar.selectedIndex = 1

        toolbar.selectedBlock = { index in
            NSLog(index)
        }

        toolbar.cornerRadius = 20
        self.view.addSubview(toolbar)
        
    }

}
