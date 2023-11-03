//
//  HMainController7.swift
//  HSwiftProject
//
//  Created by owner on 2023/11/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HMainController7: HViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = HWaterfallMutiSectionFlowLayout()
        layout.delegate = self
        var frame = self.view.bounds
        frame.y = UIScreen.topBarHeight
        frame.height -= frame.y + 50
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.alwaysBounceVertical = true
        collection.dataSource = self
        collection.delegate = self
        collection.showsVerticalScrollIndicator = false
        collection.register(HPengCell.self, forCellWithReuseIdentifier: HPengCell.identifiers)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional.tup after loading the view.
        self.title = "第五页"
        self.navigationBar.leftItem.isHidden = true
        self.view.addSubview(collectionView)
    }
    
}

extension HMainController7: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPengCell.identifiers, for: indexPath) as! HPengCell
        cell.imageView.backgroundColor = .red
        return cell
    }
}

extension HMainController7: HWaterfallMutiSectionDelegate {
    func heightForItemAtIndexPath(_ indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return CGFloat((arc4random() % 3 + 1) * 90)
    }
    func numberOfColumnsInSection( _ section: Int) -> Int {
        return 2
    }
    func lineSpacingForSection( _ section: Int) -> CGFloat {
        return 16.0
    }
    func interitemSpacingForSection( _ section: Int) -> CGFloat {
        return 15.0
    }
}

class HPengCell: UICollectionViewCell {
    static let identifiers = "HPengCellIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        imageView.frame = self.bounds
    }
    
    lazy var imageView: HWebImageView = {
        let imageView = HWebImageView()
        imageView.cornerRadius = 8.0
        self.addSubview(imageView)
        return imageView
    }()
    
}
