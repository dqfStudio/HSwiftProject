//
//  HSkeletonView2.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

//import UIKit
//import Lottie
//
//class HSkeletonView2: UIControl, HTupleViewDelegate {
//    
//    lazy var loadingView: LottieAnimationView = {
//        let loading = LottieAnimationView(name: "page_logo")
//        loading.loopMode = .autoReverse
//        return loading
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.bg
//        self.addSubview(loadingView)
//        loadingView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(64)
//        }
//    }
//
//    @available(*, unavailable)
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        loadingView.play()
//    }
//    
//    override func removeFromSuperview() {
//        if self.superview != nil {
//            loadingView.stop()
//            super.removeFromSuperview()
//        }
//    }
//    
//}
