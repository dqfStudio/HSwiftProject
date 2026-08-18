//
//  HBaseView.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objcMembers
class HBaseView: UIView, HReactiveViewProtocol {
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dm_setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dm_setupViews() {
        
    }
    
    func dm_bindViewModel(_ viewModel:Any?) {
        
    }
    
    func dm_destroy() {
        
    }
    
    deinit {
        
    }
    
}
