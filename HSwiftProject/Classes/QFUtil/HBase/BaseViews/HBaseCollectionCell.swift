//
//  HBaseCollectionCell.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objcMembers
class HBaseCollectionCell: UICollectionViewCell, HReactiveViewProtocol {
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    var isSelect: Bool = false
    
    override var isSelected: Bool {
        get {
            return self.isSelect
        }
        set {
            self.isSelect = newValue
            if newValue {
                self.setSelectedStyle()
            } else {
                self.setDeSelectedStyle()
            }
        }
    }
    
    func setSelectedStyle() {
        
    }
     
    func setDeSelectedStyle() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.dm_setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func dm_setupViews() {
        
    }
    
    func dm_bindViewModel(_ viewModel: Any?) {
        
    }
    
}
