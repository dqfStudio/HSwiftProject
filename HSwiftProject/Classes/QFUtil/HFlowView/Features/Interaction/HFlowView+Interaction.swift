//
//  HFlowView+Interaction.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  系统拖拽重排和多选。真正改数据源要在回调里自己做。
//

import UIKit

private var hflowDragHandlerKey: UInt8 = 0

extension HFlowView {

    /// 开启系统拖拽重排。真正改数据源要在 handler 里自己做，再刷新列表。
    func enableDragReorder(_ handler: @escaping (IndexPath, IndexPath) -> Void) {
        objc_setAssociatedObject(self, &hflowDragHandlerKey, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        dragInteractionEnabled = true
        dragDelegate = self
        dropDelegate = self
    }

    func disableDragReorder() {
        objc_setAssociatedObject(self, &hflowDragHandlerKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
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
        indexPathsForSelectedRows?.forEach { deselectRow(at: $0, animated: false) }
    }

    func selectAllRows() {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
    }

    func deselectAllRows() {
        indexPathsForSelectedRows?.forEach { deselectRow(at: $0, animated: false) }
    }

    private var dragReorderHandler: ((IndexPath, IndexPath) -> Void)? {
        objc_getAssociatedObject(self, &hflowDragHandlerKey) as? (IndexPath, IndexPath) -> Void
    }
}

extension HFlowView: UITableViewDragDelegate, UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider(object: "\(indexPath.section)-\(indexPath.row)" as NSString))
        item.localObject = indexPath
        return [item]
    }

    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.localDragSession != nil
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard
            let destination = coordinator.destinationIndexPath,
            let source = coordinator.items.first?.dragItem.localObject as? IndexPath
        else { return }
        dragReorderHandler?(source, destination)
    }
}
