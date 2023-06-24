//
//  HTextLoopView.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/8.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HSelectTextBlock = (_ selectString: NSString, _ index: Int) -> Void

class HTextLoopView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var dataSource: NSArray?
    private var tableView: UITableView?
    private var myTimer: Timer?
    
    private var _interval: TimeInterval = 1.0
    private var interval: TimeInterval {
        get {
            return _interval
        }
        set {
            if _interval != newValue {
                _interval = newValue
                myTimer = Timer.scheduledTimer(timeInterval: _interval, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
            }
        }
    }
    private var currentRowIndex: Int = 0
    private var selectBlock: HSelectTextBlock?

    /**
     @param frame 控件大小
     @param dataSource 数据源
     @param interval 时间间隔,默认是1.0秒
     @param selectBlock 选中回调方法
     */
    static func textLoopViewWithFrame(_ frame: CGRect, _ dataSource: NSArray, _ interval: TimeInterval, _ selectBlock: @escaping HSelectTextBlock) -> HTextLoopView {
        let loopView = HTextLoopView(frame: frame)
        loopView.dataSource = dataSource
        loopView.selectBlock = selectBlock
        loopView.interval = interval
        return loopView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.rowHeight = frame.size.height
        tableView!.separatorStyle = .none
        tableView!.showsVerticalScrollIndicator = false
        tableView!.isUserInteractionEnabled = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.scrollsToTop = false
        self.addSubview(tableView!)
        NotificationCenter.default.addObserver(self, selector: #selector(backAndRestart), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func backAndRestart() {
        self.timer()
    }
    
    @objc
    private func timer() {
        DispatchQueue.main.async {
            self.currentRowIndex += 1
            if self.currentRowIndex >= self.dataSource!.count {
                self.currentRowIndex = 0
            }
            self.tableView?.setContentOffset(CGPoint(x: 0, y: CGFloat(self.currentRowIndex) * self.tableView!.rowHeight), animated: true)
        }
    }
    
    //tableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "HTextLoopViewCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cell!.textLabel?.text = dataSource?[indexPath.row] as? String
        cell!.textLabel?.font = .systemFont(ofSize: 14.0)
        cell!.textLabel?.textColor = .lightText
        cell!.backgroundColor = .clear
        cell!.selectionStyle = .none
        return cell!
    }

    // tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectBlock?(dataSource?[indexPath.row] as! NSString, indexPath.row)
    }

    // scrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 以无动画的形式跳到第1组的第0行
        if currentRowIndex == dataSource!.count {
            currentRowIndex = 0
            DispatchQueue.main.async {
                self.tableView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }

    // touch method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectBlock != nil {
            if currentRowIndex >= dataSource!.count {
                currentRowIndex = 0
            }
            self.selectBlock?(dataSource?[currentRowIndex] as! NSString, currentRowIndex)
        }
    }

}
