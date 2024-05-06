//
//  MessageBaseRightTableViewCell.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class MessageBaseRightTableViewCell: UITableViewCell, MessageCellAble {
    func setMessage(model: MessageInfo, extraInfo: ExtraInfo?) {
        
    }
    
    var delegate: MessageDelegate?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .red
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
