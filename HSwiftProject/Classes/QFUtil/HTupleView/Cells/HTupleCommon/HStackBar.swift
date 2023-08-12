//
//  HStackBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/12.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HStackBar: UIScrollView {
    
    var items: [String]?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
//        // Set the delegate of the tuple view to self and add it as a subview
//        tupleView.delegate = self
//        self.addArrangedSubview(tupleView)
        
//        // Add indicatorBar
//        indicatorBar.backgroundColor = indicatorBarColor
//        tupleView.addSubview(indicatorBar)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(stackView)
        
        self.showsHorizontalScrollIndicator = false
        
//        stackView.spacing = 20
        
        var viewWidth = 0.0
        
        
        //创建100个BUTTON
        for index in 1 ..< 10 {
//            let button = UIButton(type: .custom)
            let button = HWebButtonView()
            let title = "Button" + String(index)
            button.text = title
//            button.setTitle(title, forState: .normal)
            button.textFont = UIFont.font(ofSize: 14, weight: .regular)
            button.backgroundColor = .red
            stackView.addArrangedSubview(button) //将BUTTON放于stackView容器中，此后不需要设置BUTTON的任何约束，就能实现从上到下排列显示，宽高都是自适应大小，注意这儿必须要用addArrangedSubview而不能用addSubView
//            button.frame = CGRectMake(0, 60, 300, 90) //不用设FRAME了，设了也不会起作用的，因为stackView会自动去添加一些约束。
//            button.backgroundColor = UIColor.randomColor()
            
            viewWidth += button.intrinsicContentSize.width
            
            button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width).isActive = true
            
            button.pressed = { (sender, data) in
                if button.x < 0 {
                    
                }
            }
            
//            button.snp_makeConstraints(closure: { (make) -> Void in
//                make.height.equalTo(60)//不能设FRAME，但设置约束就有效果了，所以在这儿可以更新BUTTON的显示
//            })
        }
        
//        self.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        
        viewWidth += 20 * 10
        self.contentSize = CGSize(width: viewWidth, height: self.height)
        stackView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: self.height)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLayoutSubviews() {
//       super.viewDidLayoutSubviews()
//       //我们知道contentSize必须大于SIZE，在某个方向才能滑动。所以这儿需要设置contentSize，为什么要在这儿设了，因为这个地方刚好布局完成，所有的VIEW都有了明确的frame值，而你在viewDidLoad中去设置的话，frame值都还为0，结果会不违你所愿的。
//       self.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
//    }
    
//    var scrollView: UIScrollView!
//        var stackView: UIStackView!
//        override func viewDidLoad(){
//           super.viewDidLoad()
//           //创建scrollView, 置于self.view之上
//           scrollView = UIScrollView()
//           view.addSubview(scrollView)
//           self.scrollView.snp_makeConstraints { (make) -> Void in
//               make.edges.equalTo(self.view)
//           }
//           //创建容器，并设为竖直排列，置于scrollView上
//           stackView = UIStackView()
//           stackView.axis = .Vertical
//           scrollView.addSubview(stackView)
//           self.stackView.snp_makeConstraints { (make) -> Void in
//               make.top.equalTo(self.scrollView)
//               make.left.equalTo(self.scrollView)
//               make.right.equalTo(self.scrollView)
//               make.width.equalTo(self.scrollView)
//           }
//           //创建100个BUTTON
//           for index in 1 ..< 100 {
//               let button = UIButton(type: UIButtonType.System)
//               button.setTitle("Button" + String(index), forState: .Normal)
//               stackView.addArrangedSubview(button) //将BUTTON放于stackView容器中，此后不需要设置BUTTON的任何约束，就能实现从上到下排列显示，宽高都是自适应大小，注意这儿必须要用addArrangedSubview而不能用addSubView
//               button.frame = CGRectMake(0, 60, 300, 90) //不用设FRAME了，设了也不会起作用的，因为stackView会自动去添加一些约束。
//               button.backgroundColor = UIColor.randomColor()
//               button.snp_makeConstraints(closure: { (make) -> Void in
//                   make.height.equalTo(60)//不能设FRAME，但设置约束就有效果了，所以在这儿可以更新BUTTON的显示
//               })
//           }
//        }
//        override func viewDidLayoutSubviews(){
//           super.viewDidLayoutSubviews()
//           //我们知道contentSize必须大于SIZE，在某个方向才能滑动。所以这儿需要设置contentSize，为什么要在这儿设了，因为这个地方刚好布局完成，所有的VIEW都有了明确的frame值，而你在viewDidLoad中去设置的话，frame值都还为0，结果会不违你所愿的。
//           scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
//        }
    
}
