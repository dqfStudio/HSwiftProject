//
//  HAuthView.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/17.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HAuthViewBlock = (_ auth: String) -> Void

class HAuthView: HTupleStackView {

    var nameString: String?
    var nameColor = UIColor.white
    var nameFont = UIFont.font(ofSize: 16, weight: .regular)
    
    var authString: String = "" {
        didSet {
            if authString != oldValue {
                auths = sortAuth(authString)
                tupleView.reloadTupleData()
            }
        }
    }
    private var auths: [String] = []
    private var authSize: CGFloat = 16.0
    
    var itemSpacing: CGFloat = 4.0
    var selectBlock: HAuthViewBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.tupleView.isScrollEnabled = false
        self.addArrangedSubview(self.tupleView)
    }
    
    // 将授权字符串按照GM、VIP、POP、OTC、UGC的顺序返回
    private func sortAuth(_ auth: String) -> [String] {
        var authString = auth.replacingOccurrences(of: " ", with: "")
        authString = authString.replacingOccurrences(of: "，", with: ",")
        guard !authString.isEmpty else { return [] }
        let items = authString.components(separatedBy: ",")
        let order = ["GM", "VIP", "POP", "OTC", "UGC"]
        return items.sorted { (first, second) -> Bool in
            guard let firstIndex = order.firstIndex(of: first), let secondIndex = order.firstIndex(of: second) else { return false }
            return firstIndex < secondIndex
        }
    }
    
}

extension HAuthView {
    
    func numberOfSectionsInTupleView() -> Any {
        return self.auths.isEmpty ? 0 : 1
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.auths.count + 1
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        if indexPath.row == 0 {
            // 名称字符长度
            var nameWidth = self.nameString?.widthWithFont(self.nameFont,
                                                           constrainedToHeight: self.height) ?? 1.0
            nameWidth = ceil(nameWidth) //向上取整
            // 授权字符长度
            var authWidth = self.width - (self.itemSpacing + self.authSize) * CGFloat(self.auths.count)
            authWidth = max(authWidth, 0) //取最大值
            // 取名称与授权字符长度的最小值
            nameWidth = min(nameWidth, authWidth) //取最小值
            return CGSize(width: nameWidth, height: self.height)
        }else {
            return CGSize(width: self.authSize, height: self.height)
        }
    }
    
    func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return self.itemSpacing
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {       
        if indexPath.row == 0 {
            let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.textColor = self.nameColor
            cell.label.font = self.nameFont
            cell.label.text = self.nameString
        }else {
            let cell = tuple.reuseCell(HTupleImageCell.self, nil, true, indexPath) as! HTupleImageCell
            if indexPath.row <= self.auths.count {
                let authIndex = indexPath.row - 1
                let auth = self.auths[authIndex]
                //cell.imageView.setImage(WithName: auth)
                cell.selectBlock = { [weak self] in
                    self?.selectBlock?(auth)
                }
            }
        }
    }
    
}
