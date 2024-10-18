//
//  HTupleLayout.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleLayout: NSObject {
    
    static var shared = HTupleLayout()
    
    private lazy var layoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
//    func post(item: SquarePostItem, tuple: HTupleView, cellWidth: CGFloat) {
//        guard let postID = item.id, tuple.cellHeights[postID] == nil else { return }
//        
//        // cell height
//        let cellHeight = 10.0
//        
//        // postHeaderView
//        let headerViewHeight = 44.0
//        cellHeight += headerViewHeight
//        
//        // postTextView
//        self.layoutLabel.text = item.content
//        let textHeight = self.layoutLabel.textHeight(with: cellWidth)
//        let textViewHeight = textHeight + 8.0
//        cellHeight += textViewHeight
//        
//        // postImageView
//        let imageViewHeight = 110.0 + 8.0
//        cellHeight += imageViewHeight
//        
//        // postVideoView
//        let videoViewHeight = 80.0 + 8.0
//        cellHeight += videoViewHeight
//        
//        // postFooterView
//        let footerViewHeight = 17.0 + 12.0
//        cellHeight += footerViewHeight
//
//        // 保存cell高度
//        tuple.cellHeights[postID] = cellHeight
//    }
    
}
