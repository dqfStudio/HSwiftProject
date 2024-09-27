//
//  HMainController7.swift
//  HSwiftProject
//
//  Created by owner on 2023/11/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HMainController7: HViewController, HTupleViewDelegate {
    
//    var cellHeights: [CGFloat] = [100, 200, 300, 200, 400, 150, 200, 300, 500, 400]
    var cellHeights: [CGFloat] = [400, 500, 600, 500, 700, 450]
    
    private lazy var tupleView: HTupleView = {
        var frame = self.view.bounds
        frame.y = UIScreen.topBarHeight
        frame.height -= frame.y + 50
        let layout = HTupleViewWaterfallLayout()
        let tupleView = HTupleView(frame: frame, collectionViewLayout: layout)
        tupleView.sectionHeadersPinToVisibleBounds = true
        return tupleView
    }()
    
    var sourceData: [String] = ["放假啦束带结发拉屎会计法拉数据发来的撒放假了打撒发给垃圾粉了",
                                "我饿付了款静电纺丝啦",
                                "电风扇两地分居啊射流风机撒冷风机打死了封疆大吏酸辣粉家里的撒放假了手打见风使舵附件丽都水岸就发了打撒就发了打撒开发激发来撒娇飞力达快捷方式独立开发阿萨德浪费萨拉丁发撒老大饭卡手打理发手打拉法基撒发啦",
                                "sfadsklfdaslfjdslaf",
                                "weejeffljfljl",
                                "jdflsakjfljsaflkjsal"]
    
    var postList: [HPostVM] = [HPostVM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第五页"
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        
        sourceData.forEach { item in
            let postVM = HPostVM()
            postVM.post = item
            postVM.imageUrls = ["11", "22", "33", "44"]
            postVM.videoUrl = "11"
            postList.append(postVM)
        }

        DispatchQueue.main.async {
            self.tupleView.contentOffset = CGPoint(x: 0, y: 1)
            self.tupleView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }

}


extension HMainController7 {
    func numberOfSectionsInTupleView() -> Any {
        return 2
    }
    func numberOfColumnsInSection(_ section: Any) -> Any {
        return 2
    }
    func insetForSection(_ section: Any) -> Any {
//        let section = section as! Int
//        if section == 0 {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.width / 2)
//        }else {
//            let hh = 100 + 200 + 300 + 200 + 400 + 150
//            return UIEdgeInsets(top: -CGFloat(hh), left: UIScreen.width / 2, bottom: 0, right: 0)
//        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return postList.count
    }
    func sizeForHeaderInSection(_ section: Any) -> Any {
//        return CGSize(width: UIScreen.width, height: 50)
        let section = section as! Int
        if section == 0 {
            return CGSize(width: UIScreen.width, height: 50)
//            return CGSize.zero
        }else {
            return CGSize(width: UIScreen.width, height: 50)
//            return CGSize.zero
        }
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let numberOfColumns = 2 // 你可以根据需要设置列数
        let padding: CGFloat = 10
//        let itemWidth = (self.tupleView.width - padding * CGFloat(numberOfColumns + 1)) / CGFloat(numberOfColumns)
        
        let itemWidth = (self.tupleView.width - 32 - 10) / CGFloat(numberOfColumns)
//        let itemWidth = (self.tupleView.width) / CGFloat(numberOfColumns)
//        let itemHeight = itemWidth * 1.5 // 你可以根据内容动态调整高度
//        let itemHeight = CGFloat(Int.random(in: 100...500))
//        let itemHeight = cellHeights[indexPath.row]
//        return CGSize(width: itemWidth, height: itemHeight)
        
        if indexPath.section == 0 {
//            let itemHeight = cellHeights[indexPath.row]
            return CGSize(width: itemWidth, height: 100)
        }else {
            let itemHeight = cellHeights[indexPath.row]
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    func minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return 10
    }
    func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return 10
    }
    func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseHeader(HTupleBaseApex.self, nil, true, indexPath) as! HTupleBaseApex
//        cell.backgroundColor = UIColor.green
        if indexPath.section == 0 {
            cell.backgroundColor = .green
        }else {
            cell.backgroundColor = .yellow
//            cell.alpha = 0
        }
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HPengCell.self, indexPath.stringValue, true, indexPath) as! HPengCell
        if indexPath.section == 0 {
            cell.backgroundColor = .yellow
        }else {
            cell.backgroundColor = .green
        }
//        cell.backgroundColor = .yellow
        guard indexPath.row < postList.count else { return }
        
//        cell.layoutView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        // 赋值model
//        let postVM = postList[indexPath.row]
//        cell.postVM = postVM
    }

}

class HPengCell: HTupleBaseCell, HTupleViewDelegate {
    
    // 帖子model
    private var _postVM: HPostVM?
    var postVM: HPostVM! {
        get { return _postVM }
        set {
            if _postVM?.post != newValue.post {
                _postVM = newValue
                tupleView.reloadTupleData()
            }
        }
    }
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            return self.bounds
        } mode: {
            return .delegate
        } exclusiveSections: {
            return [0, 1, 2, 3, 4, 5]
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        self.layoutView.addArrangedSubview(tupleView)
        return tupleView
    }()
    
    override func initUI() {
//        self.tupleView.delegate = self
//        self.layoutView.addArrangedSubview(self.tupleView)
//        self.tupleView.cntSizeBlock = { [weak self] cntSize in
//            if let tuple = self?.tuple {
//                tuple.reloadData()
//            }
//        }
    }
    
    func reloadTupleData() {
        self.tupleView.reloadTupleData()
    }
    
    deinit {
        self.tupleView.releaseTupleBlock()
    }
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 6
    }

}

extension HPengCell {
    
    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 24, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 48)
    }
    
    @objc
    func tupleExa0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var headerView = cell.layoutView.viewWithTag(121314) as? HPostHeader
        if headerView == nil {
            headerView = HPostHeader(frame: frame)
            headerView!.tag = 121314
            headerView!.avatarButton.pressed = { (sender, data) in
                NSLog("")
            }
            cell.layoutView.addSubview(headerView!)
        }
        headerView!.avatarButton.backgroundColor = .red
        headerView!.nameLabel.text = "张三"
        headerView!.dateLabel.text = "2023-08-10"
        
        cell.selectBlock = {
            NSLog("")
        }
    }
    
}

extension HPengCell {
    
    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 文字内容
        if postVM.post?.count ?? 0 > 0 {
            items += 1
            // 是否显示更多信息
            if postVM.postExtend == .extend {
                items += 1
            }
        }
        return items
    }
    
    @objc
    func tupleExa1_insetForSection(_ section: Any) -> Any {
        if postVM.post?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case 0:
            if postVM.postExtend == .extend {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postTextHeightOmit)
            } else {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
            }
        case 1:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postExtendSpace)
        default:
            break
        }
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postExtendSpace)
    }
    
    @objc
    func tupleExa1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //内容
            if postVM.postExtend == .extend {
                let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue + "notExtended", true, indexPath) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 3
                cell.label.text = postVM.post
            } else {
                let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue + "isExtended", true, indexPath) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 0
                cell.label.text = postVM.post
            }
        case 1: //更多
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
            cell.edgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            
            let frame = cell.layoutViewBounds
            let width = "显示更多".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: postExtendSpace - 8.0)

            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "显示更多"
            cell.buttonView.pressed = { (sender, data) in
                self.postVM.postExtend = .isExtended
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tupleView.reloadData()
                }
            }
        default:
            break
        }

    }
    
}

extension HPengCell {
    
    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 是否需要翻译
        if postVM.postExtend != .extend, postVM.postTranslate != .undefine {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa2_insetForSection(_ section: Any) -> Any {
        // 是否需要翻译
        if postVM.postExtend != .extend, postVM.postTranslate != .undefine {
            return UIEdgeInsets(top: 8, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
        return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
        }
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postTranslateSpace - 8.0)
    }
    
    @objc
    func tupleExa2_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue, true, indexPath) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textColor = UIColor(hex: "#17191E")
            cell.label.numberOfLines = 0
            cell.label.text = postVM.post
        } else {
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
            
            let frame = cell.layoutViewBounds
            let width = "翻译内容".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: postTranslateSpace - 8.0)
            
            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "翻译内容"
            
            cell.buttonView.pressed = { (sender, data) in
                // 是否已经翻译过了
                self.postVM.postTranslate = .isTranslated
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tupleView.reloadData()
                }
            }
        }

    }
    
}

extension HPengCell {
    
    @objc
    func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 图片
        if let count = postVM.imageUrls?.count, count > 0 {
            items += count
            //四张图片时由于布局的特殊性，多添加一个item
            if count == 4 {
                items += 1
            }
        }
        return items
    }
    
    @objc
    func tupleExa3_insetForSection(_ section: Any) -> Any {
        if postVM.imageUrls?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa3_minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return postImageSpace
    }
    
    @objc
    func tupleExa3_minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return postImageSpace
    }
    
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: postImageSize, height: postImageSize)
    }
    
    @objc
    func tupleExa3_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
            let frame = cell.layoutViewBounds
            cell.buttonView.frame = frame
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                NSLog("图片")
            }
            
        } else if indexPath.row == 1 {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                NSLog("图片")
            }

        }  else if indexPath.row == 2 {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                cell.buttonView.isUserInteractionEnabled = false
            } else {
                cell.buttonView.backgroundColor = .red
                cell.buttonView.isUserInteractionEnabled = true
                cell.buttonView.text = "图片"
                cell.buttonView.cornerRadius = 8.0
                cell.buttonView.pressed = { (sender, data) in
                    NSLog("图片")
                }
            }
            
        } else {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row - 1
                    NSLog("图片")
                }
                
            } else {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row
                    NSLog("图片")
                }
            }
            
        }

    }
    
}

extension HPengCell {
    
    @objc
    func tupleExa4_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        if postVM.videoUrl?.count ?? 0 > 0 {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa4_insetForSection(_ section: Any) -> Any {
        if postVM.videoUrl?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa4_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVideoSize)
    }
    
    @objc
    func tupleExa4_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
        cell.buttonView.backgroundColor = .red
        cell.buttonView.text = "视频"
        cell.buttonView.cornerRadius = 8.0
        cell.buttonView.pressed = { (sender, data) in
            NSLog("视频")
        }
    }
    
}

extension HPengCell {
    
    @objc
    func tupleExa5_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa5_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 25, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa5_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 24)
    }
    
    @objc
    func tupleExa5_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var footerView = cell.layoutView.viewWithTag(131415) as? HPostFooter
        if footerView == nil {
            footerView = HPostFooter(frame: frame)
            footerView!.tag = 131415
            footerView!.likeButton.pressed = { (sender, data) in
                NSLog("like")
            }
            
            footerView!.commentButton.pressed = { (sender, data) in
                NSLog("comment")
                self.viewController?.navigationController?.pushViewController(HPostCommentVC(), animated: true)
            }
            
            footerView!.shareButton.pressed = { (sender, data) in
                NSLog("share")
            }
            
            footerView!.moreButton.pressed = { (sender, data) in
                NSLog("more")
            }
            cell.layoutView.addSubview(footerView!)
        }
        footerView!.likeButton.text = "喜欢"
        footerView!.commentButton.text = "评论"
        footerView!.shareButton.text = "分享"
        footerView!.moreButton.text = "更多"
    }
    
}


//class HMainController7: HViewController, UICollectionViewDelegate {
//    var collectionView: UICollectionView!
//    var items: [String] = [] // 用于存储数据
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 示例数据
//        items = ["短文本--1", "这是一个较长的文本示例--2", "中等高度的文本--3", "短--4", "更长的文本示例，可能会占用更多的空间--5", "短文本--6", "中等高度的文本--7", "短--8", "更长的文本示例，可能会占用更多的空间--9"]
//        
//        // 创建集合视图
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createWaterfallLayout())
//        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: "WaterfallCell")
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .white
//        view.addSubview(collectionView)
//    }
//
//    func createWaterfallLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
////        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        
//        let twoColumnGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
//        
//        let section = NSCollectionLayoutSection(group: twoColumnGroup)
//        section.interGroupSpacing = 10
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//        
//        return UICollectionViewCompositionalLayout(section: section)
//    }
//}
//
//extension HMainController7: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterfallCell", for: indexPath) as! WaterfallCell
//        if indexPath.section == 0 {
//            cell.backgroundColor = .yellow
//        }else {
//            cell.backgroundColor = .red
//        }
//        
//        cell.configure(with: items[indexPath.item])
//        return cell
//    }
//}
//
//class WaterfallCell: UICollectionViewCell {
//    private let label = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(label)
//        label.numberOfLines = 0 // 允许多行
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with text: String) {
//        label.text = text
//        label.sizeToFit() // 根据内容调整大小
//    }
//}
