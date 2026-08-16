//
//  HCollView+Interaction.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  系统拖拽重排和多选。真正改数据源要在回调里自己做。
//

import UIKit

private var hcollDragHandlerKey: UInt8 = 0

extension HCollView {

    /// 开启系统拖拽重排。真正改数据源要在 handler 里自己做，再刷新列表。
    func enableDragReorder(_ handler: @escaping (IndexPath, IndexPath) -> Void) {
        objc_setAssociatedObject(self, &hcollDragHandlerKey, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        dragInteractionEnabled = true
        dragDelegate = self
        dropDelegate = self
    }

    func disableDragReorder() {
        objc_setAssociatedObject(self, &hcollDragHandlerKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        dragInteractionEnabled = false
        dragDelegate = nil
        dropDelegate = nil
    }

    func enterMultiSelectMode() {
        allowsSelection = true
        allowsMultipleSelection = true
    }

    func exitMultiSelectMode() {
        allowsMultipleSelection = false
        indexPathsForSelectedItems?.forEach { deselectItem(at: $0, animated: false) }
    }

    func selectAllItems() {
        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                selectItem(at: IndexPath(item: item, section: section), animated: false, scrollPosition: [])
            }
        }
    }

    func deselectAllItems() {
        indexPathsForSelectedItems?.forEach { deselectItem(at: $0, animated: false) }
    }

    private var dragReorderHandler: ((IndexPath, IndexPath) -> Void)? {
        objc_getAssociatedObject(self, &hcollDragHandlerKey) as? (IndexPath, IndexPath) -> Void
    }
}

extension HCollView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning _: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider(object: "\(indexPath.section)-\(indexPath.item)" as NSString))
        item.localObject = indexPath
        return [item]
    }

    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        session.localDragSession != nil
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate _: UIDropSession, withDestinationIndexPath _: IndexPath?) -> UICollectionViewDropProposal {
        UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard
            let destination = coordinator.destinationIndexPath,
            let source = coordinator.items.first?.dragItem.localObject as? IndexPath
        else { return }
        dragReorderHandler?(source, destination)
    }
}
