//
//  DPMBaseStackView.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objcMembers
class DPMBaseStackView: UIStackView, DPMReactiveViewProtocol {
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dpm_setupViews()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dpm_setupViews() {
        
    }
    
    func dpm_bindViewModel(_ viewModel: Any?) {
        
    }
    
    deinit {
        
    }
    
}
