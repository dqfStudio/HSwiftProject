//
//  WaterfallViewController.swift
//  HSwiftProject
//
//  Created by owner on 2025/8/18.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

class WaterfallViewController: UIViewController {
    
    // 模拟数据：不同高度的图片
    private let imageHeights: [CGFloat] = [150, 200, 180, 250, 170, 220, 190, 240, 160, 210, 185, 230, 260, 140, 235]
    private let reuseIdentifier = "WaterfallCell"
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "瀑布流示例"
        view.backgroundColor = .white
        
        // 创建瀑布流布局
        let layout = createWaterfallLayout()
        
        // 创建集合视图
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    // 创建瀑布流布局 - 关键修改在这里
    private func createWaterfallLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            // 列数：根据屏幕宽度动态调整
            let columns = layoutEnvironment.traitCollection.horizontalSizeClass == .compact ? 2 : 3
            let spacing: CGFloat = 10
            
            // 计算每列的宽度
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: .absolute(100) // 这里的值会被下面的provider覆盖
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(spacing)
            
            // 创建分区
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            // 关键：设置自定义尺寸provider
//            section.visibleItemsInvalidationHandler = { [weak self] (items, contentOffset, environment) in
//                guard let self = self else { return }
//                items.forEach { item in
//                    let indexPath = item.indexPath
//                    // 根据索引设置实际高度
////                    let height = self.imageHeights[indexPath.item]
////                    item.layoutAttributes.size.height = height
//                    
//                    let height = self.imageHeights[indexPath.item]
////                    item.size.height = height
//                    
//                    item.layoutAttributes.size.height = height
//                }
//            }
//            section.visibleItemsInvalidationHandler = { items, _, _ in
//                items.forEach { item in
//                    let indexPath = item.indexPath
//                    let height = self.imageHeights[indexPath.item]
//                    var newSize = item.size
//                    newSize.height = height
//                    item.size = newSize
//                }
//            }
            
            return section
        }
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension WaterfallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageHeights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WaterfallCell
        let height = imageHeights[indexPath.item]
        cell.configure(height: height)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WaterfallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选中了第 \(indexPath.item) 个元素，高度: \(imageHeights[indexPath.item])")
    }
}

// 自定义瀑布流单元格
class WaterfallCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let heightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 图片视图
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        // 高度标签 - 显示当前cell的高度
        heightLabel.textColor = .white
        heightLabel.font = .boldSystemFont(ofSize: 16)
        heightLabel.textAlignment = .center
        
        contentView.addSubview(imageView)
        contentView.addSubview(heightLabel)
        
        // 添加约束
        imageView.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            heightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(height: CGFloat) {
        // 设置随机背景色以便区分
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple]
        imageView.backgroundColor = colors.randomElement()
        
        // 显示高度值
        heightLabel.text = "\(Int(height))"
        
        // 这里可以根据需要加载实际图片
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.white.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
    }
}
