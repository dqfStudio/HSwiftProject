//
//  DPMBaseHeaderFooterView.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objcMembers
class DPMBaseHeaderFooterView: UITableViewHeaderFooterView, DPMReactiveViewProtocol {
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.dpm_setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func dpm_setupViews() {
        
    }
    
    func dpm_bindViewModel(_ viewModel: Any?) {
        
    }
    
}
