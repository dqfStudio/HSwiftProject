////
////  HNodeModelTableView.swift
////  HSwiftProject
////
////  Created by owner on 2024/6/3.
////  Copyright © 2024 wind. All rights reserved.
////
//
//let MaxLevel: Int = 4 //最大的层级数
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SLNodeTableViewCellDelegate {
//    @IBOutlet weak var tableView: UITableView!
//    var dataSource: [SLNodeModel] = []
//    var selectedSource: [SLNodeModel] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.navigationItem.title = "TableView 多级列表"
//        self.dataSource = []
//        self.selectedSource = []
//        self.setDataSOurce()
//    }
//
//    // 获取并初始化 树根结点数组
//    func setDataSOurce() {
//        for i in 0..<4 {
//            let node = SLNodeModel()
//            node.parentID = ""
//            node.childrenID = ""
//            node.level = 1
//            node.name = "第\(node.level)级结点"
//            node.leaf = 0
//            node.root = true
//            node.expand = false
//            node.selected = false
//            self.dataSource.append(node)
//        }
//    }
//
//    // 获取并展开父结点的子结点数组 数量随机产生
//    func expandChildrenNodesLevel(level: Int, at indexPath: IndexPath) {
//        let nodeModel = self.dataSource[indexPath.row]
//        var insertNodeRows: [IndexPath] = []
//        let insertLocation = indexPath.row + 1
//        for _ in 0..<(Int(arc4random()) % 9) {
//            let node = SLNodeModel()
//            node.parentID = ""
//            node.childrenID = ""
//            node.level = level + 1
//            node.name = "第\(node.level)级结点"
//            node.leaf = (node.level < MaxLevel) ? false : true
//            node.root = false
//            node.expand = false
//            node.selected = nodeModel.selected
//            self.dataSource.insert(node, at: insertLocation)
//            insertNodeRows.append(IndexPath(row: insertLocation, section: 0))
//        }
//        
//        //插入cell
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: insertNodeRows, with: .none)
//        self.tableView.endUpdates()
//        
//        //更新新插入的元素之后的所有cell的cellIndexPath
//        var reloadRows: [IndexPath] = []
//        let reloadLocation = insertLocation + insertNodeRows.count
//        for i in reloadLocation..<self.dataSource.count {
//            reloadRows.append(IndexPath(row: i, section: 0))
//        }
//        self.tableView.reloadRows(at: reloadRows, with: .none)
//    }
//
//    // 获取并隐藏父结点的子结点数组
//    func hiddenChildrenNodesLevel(level: Int, at indexPath: IndexPath) {
//        var deleteNodeRows: [IndexPath] = []
//        var length = 0
//        let deleteLocation = indexPath.row + 1
//        for i in deleteLocation..<self.dataSource.count {
//            let node = self.dataSource[i]
//            if node.level > level {
//                deleteNodeRows.append(IndexPath(row: i, section: 0))
//                length += 1
//            } else {
//                break
//            }
//        }
//        self.dataSource.removeSubrange(deleteLocation..<(deleteLocation + length))
//        self.tableView.beginUpdates()
//        self.tableView.deleteRows(at: deleteNodeRows, with: .none)
//        self.tableView.endUpdates()
//        
//        //更新删除的元素之后的所有cell的cellIndexPath
//        var reloadRows: [IndexPath] = []
//        let reloadLocation = deleteLocation
//        for i in reloadLocation..<self.dataSource.count {
//            reloadRows.append(IndexPath(row: i, section: 0))
//        }
//        self.tableView.reloadRows(at: reloadRows, with: .none)
//    }
//
//    // 更新当前结点下所有子结点的选中状态
//    func selectedChildrenNodes(level: Int, selected: Bool, at indexPath: IndexPath) {
//        var selectedNodeRows: [IndexPath] = []
//        let deleteLocation = indexPath.row + 1
//        for i in deleteLocation..<self.dataSource.count {
//            let node = self.dataSource[i]
//            if node.level > level {
//                node.selected = selected
//                selectedNodeRows.append(IndexPath(row: i, section: 0))
//            } else {
//                break
//            }
//        }
//        self.tableView.reloadRows(at: selectedNodeRows, with: .none)
//    }
//
//    // MARK: - UITableViewDelegate  UITableViewDataSource
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataSource.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? SLNodeTableViewCell
//        if cell == nil {
//            cell = SLNodeTableViewCell(style: .value1, reuseIdentifier: "cellID")
//        }
//        let node = self.dataSource[indexPath.row]
//        cell?.node = node
//        cell?.delegate = self
//        cell?.cellSize = CGSize(width: self.view.frame.size.width, height: 44)
//        cell?.cellIndexPath = indexPath
//        cell?.refreshCell()
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//
//    // MARK: - SLNodeTableViewCellDelegate
//
//    func nodeTableViewCell(_ cell: SLNodeTableViewCell, selected: Bool, at indexPath: IndexPath) {
//        selectedChildrenNodes(level: cell.node.level, selected: selected, at: indexPath)
//    }
//
//    func nodeTableViewCell(_ cell: SLNodeTableViewCell, expand: Bool, at indexPath: IndexPath) {
//        if expand {
//            expandChildrenNodesLevel(level: cell.node.level, at: indexPath)
//        } else {
//            hiddenChildrenNodesLevel(level: cell.node.level, at: indexPath)
//        }
//    }
//}
