//
//  HPostCommentFooter.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/11.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostCommentFooter: UIStackView {
    
    lazy var likeButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_like"), for: .normal)
        //button.setImage(UIImage(named: "square_post_like_sel"), for: .selected)
        return button
    }()
    
    lazy var commentButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_comment"), for: .normal)
        return button
    }()
    
    lazy var shareButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_share"), for: .normal)
        return button
    }()
    
    lazy var moreButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_more"), for: .normal)
        return button
    }()
    
    required init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.addArrangedSubview(likeButton)
        self.addArrangedSubview(commentButton)
        self.addArrangedSubview(shareButton)
        self.addArrangedSubview(moreButton)
        self.distribution = .equalSpacing
    }
    
}
