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
//    private lazy var rightView: UIView = {
//        return UIView()
//    }()
//    
//    func reloadSubviews(_ auths: [String]) {
//        // 移除视图
//        self.removeArrangedSubview(nameLabel)
//        self.authViews.forEach { authView in
//            self.removeArrangedSubview(authView)
//        }
//        self.authViews.removeAll()
//        self.removeArrangedSubview(rightView)
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
//                let button = HWebButtonView()
//                button.pressed = { [weak self] (sender, data) in
//                    if let userTag = UserTag(rawValue: auth) {
//                        self?.selectBlock?(userTag)
//                    }
//                }
//                if let userTag = UserTag(rawValue: auth) {
//                    switch userTag {
//                    case .GM:
//                        button.setImage(WithName: "group_member_tag_gm")
//                    case .VIP:
//                        button.setImage(WithName: "group_member_tag_vip")
//                    case .POP:
//                        button.setImage(WithName: "profile_auth_pop")
//                    case .OTC:
//                        button.setImage(WithName: "profile_auth_otc")
//                    case .UGC:
//                        button.setImage(WithName: "profile_auth_ugc")
//                    case .FCA:
//                        button.setImage(WithName: "profile_auth_fca")
//                    }
//                }
//                self.authViews.append(button)
//                self.addArrangedSubview(button)
//                authWidth += authSize + authSpacing
//            }
//            // 添加最右边占位视图
//            self.addArrangedSubview(rightView)
//            // 设置间隔
//            if let lastView = self.authViews.last {
//                let textWidth = nameLabel.textWidth(with: self.height)
//                let spaceWidth = self.width - textWidth - authWidth
//                if spaceWidth > 0 {
//                    self.setCustomSpacing(spaceWidth, after: lastView)
//                }
//            }
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
