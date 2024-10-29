////
////  HUserAuthView.swift
////  HSwiftProject
////
////  Created by owner on 2024/10/19.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import UIKit
//
//typealias HUserAuthViewBlock = (_ auth: UserTag) -> Void
//
//class HUserAuthView: UIStackView {
//    
//    var authString: String = "1" {
//        didSet {
//            if authString != oldValue {
//                let auths = sortAuth(authString)
//                self.reloadSubviews(auths)
//            }
//        }
//    }
//
//    var authSize: CGFloat = 16.0
//    var authSpacing: CGFloat = 4.0
//    var selectBlock: HUserAuthViewBlock?
//    private var authViews: [UIButton] = []
//    
//    lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.text
//        label.font = UIFont.font(ofSize: 16, weight: .medium)
//        return label
//    }()
//    
//    private lazy var gmButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "group_member_tag_gm")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.GM)
//        }
//        return button
//    }()
//    private lazy var vipButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "group_member_tag_vip")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.VIP)
//        }
//        return button
//    }()
//    private lazy var popButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "profile_auth_pop")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.POP)
//        }
//        return button
//    }()
//    private lazy var otcButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "profile_auth_otc")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.OTC)
//        }
//        return button
//    }()
//    private lazy var ugcButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "profile_auth_ugc")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.UGC)
//        }
//        return button
//    }()
//    private lazy var fcaButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.setImage(WithName: "profile_auth_fca")
//        button.pressed = { [weak self] (sender, data) in
//            self?.selectBlock?(.FCA)
//        }
//        return button
//    }()
//    
//    private lazy var rightView: UIView = {
//        return UIView()
//    }()
//    
//    func reloadSubviews(_ auths: [String]) {
//        // 移除视图
//        self.arrangedSubviews.forEach { v in
//            self.removeArrangedSubview(v)
//            v.removeFromSuperview()
//        }
//        
//        // 添加name视图
//        self.addArrangedSubview(nameLabel)
//        
//        // 添加auth视图
//        if auths.isEmpty {
//            // 设置间隔
//            self.spacing = 0.0
//        }else {
//            // 设置间隔
//            self.spacing = authSpacing
//            // auth宽度
//            var authWidth = 0.0
//            auths.forEach { auth in
//                if let userTag = UserTag(rawValue: auth) {
//                    switch userTag {
//                    case .GM:
//                        self.addArrangedSubview(self.gmButton)
//                    case .VIP:
//                        self.addArrangedSubview(self.vipButton)
//                    case .POP:
//                        self.addArrangedSubview(self.popButton)
//                    case .OTC:
//                        self.addArrangedSubview(self.otcButton)
//                    case .UGC:
//                        self.addArrangedSubview(self.ugcButton)
//                    case .FCA:
//                        self.addArrangedSubview(self.fcaButton)
//                    }
//                }
//                authWidth += authSize + authSpacing
//            }
//            // 设置间隔
//            if let lastView = self.arrangedSubviews.last {
//                let textWidth = nameLabel.textWidth(with: self.height)
//                let spaceWidth = self.width - textWidth - authWidth
//                if spaceWidth > 0 {
//                    self.setCustomSpacing(spaceWidth, after: lastView)
//                }
//            }
//            // 添加最右边占位视图
//            self.addArrangedSubview(rightView)
//        }
//    }
//    
//    // 将授权字符串按照GM、VIP、POP、OTC、UGC的顺序返回
//    private func sortAuth(_ auth: String) -> [String] {
//        var authString = auth.replacingOccurrences(of: " ", with: "")
//        authString = authString.replacingOccurrences(of: "，", with: ",")
//        guard !authString.isEmpty else { return [] }
//        let items = authString.components(separatedBy: ",")
//        let order = ["GM", "VIP", "POP", "OTC", "UGC", "ANGEL"]
//        return items.sorted { (first, second) -> Bool in
//            guard let firstIndex = order.firstIndex(of: first), let secondIndex = order.firstIndex(of: second) else { return false }
//            return firstIndex < secondIndex
//        }
//    }
//    
//}
