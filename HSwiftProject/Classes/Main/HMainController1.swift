//
//  HMainController1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let kTabBarHeight: CGFloat = 50.0

//class HMainController1: HTupleController {
class HMainController1: HCusViewController {
    
    lazy var activeBar: HActivebar = {
        let activeWidth = self.view.width
        let frame = CGRect(x: 0, y: UIScreen.statusBarHeight, width: activeWidth, height: kTabBarHeight)
        let activeBar = HActivebar(frame: frame, direction: .horizontal)
        activeBar.backgroundColor = UIColor.gray
        
//        activeBar.headerSpacing = 16
//        activeBar.footerSpacing = 16
//        activeBar.itemSpacing = 10
        
//        activeBar.indicatorWidth = 20
        activeBar.indicatorWidth = self.view.width / 4
        activeBar.indicatorHeight = 3
        activeBar.indicatorColor = UIColor.red
        activeBar.showIndicator = true
//        activeBar.tupleView.tupleAlign = .center
        
//        activeBar.showTopSeparator = true
//        activeBar.topSeparatorColor = .red
        
        activeBar.showBottomSeparator = true
        activeBar.bottomSeparatorColor = UIColor.black
        
        activeBar.numberBlock = {
            return 4
        }
        activeBar.sizeBlock = { index in
            return self.view.width / 4
        }
        activeBar.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.textAlignment = .center
            switch indexPath.row {
            case 0:
                cell.label.text = "第一个"
            case 1:
                cell.label.text = "第二个"
            case 2:
                cell.label.text = "第三个"
            case 3:
                cell.label.text = "第四个"
            default:
                break
            }
            if indexPath.row == activeBar.selectedIndex {
                cell.label.textColor = UIColor.red
                cell.label.font = UIFont.systemFont(ofSize: 17)
            }else {
                cell.label.textColor = UIColor.black
                cell.label.font = UIFont.systemFont(ofSize: 16)
            }
        }
        activeBar.didSelectBlock = { index in
            
        }
        return activeBar
    }()
    
    override var prefersNavigationBarHidden: Bool {
        true
    }
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(activeBar)
        
        let activeY = UIScreen.statusBarHeight + kTabBarHeight
        let activeH = UIScreen.height - activeY - (50 + UIScreen.bottomBarHeight)
        let activeFrame = CGRect(x: 0, y: activeY, width: self.view.width, height: activeH)
        let activeView = HActiveView(frame: activeFrame)
        
        let flowVC = HTupleAutoVC()
        let tupleVC = HTupleController()
        let chatVC = HChatsMsgVC()
        let postVC = HPostVC()
        
        activeView.activeBar = activeBar
        activeView.viewControllers = [flowVC, tupleVC, chatVC, postVC]
        self.view.addSubview(activeView)
    }
        
}
