//
//  HFPickerView.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HFPickerView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var topView: UIView!
    private var doneBtn: UIButton!
    private var tableView: UITableView!
    private var resultArr: [String] = []
    
    var array: [String] = []
    var selectedArray: [String] = []
    var title: String = ""
    var selectionBlock: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 917 / 667))
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topView = UIView(frame: CGRect(x: 0, y: 667 / 667, width: 1, height: 250 / 667))
        topView.backgroundColor = UIColor.white
        addSubview(topView)
        
        let maskPath = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = topView.bounds
        maskLayer.path = maskPath.cgPath
        topView.layer.mask = maskLayer
        
        doneBtn = UIButton(type: .custom)
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.titleLabel?.font = .systemFont(ofSize: 14.0)
        doneBtn.setTitleColor(UIColor.gray, for: .normal)
        doneBtn.frame = CGRect(x: 320 / 375, y: 5 / 667, width: 50 / 375, height: 40 / 667)
        doneBtn.addTarget(self, action: #selector(quit), for: .touchUpInside)
        topView.addSubview(doneBtn)
        
        let titlelb = UILabel(frame: CGRect(x: 100 / 375, y: 0, width: 175 / 375, height: 50 / 667))
        titlelb.backgroundColor = UIColor.clear
        titlelb.textAlignment = .center
        titlelb.text = title
        titlelb.font = UIFont.systemFont(ofSize: 20 / 375)
        topView.addSubview(titlelb)
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 50 / 667, width: 1, height: 200 / 667)
        tableView.backgroundColor = UIColor(red: 240 / 255.0, green: 239 / 255.0, blue: 245 / 255.0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        topView.addSubview(tableView)
        if selectedArray.count > 0 {
            resultArr.append(contentsOf: selectedArray)
        }
    }
    
    class func pickerView() -> HFPickerView {
        return HFPickerView()
    }
    
    func show() {
        show(in: UIApplication.shared.keyWindow!)
    }
    
    private func show(in view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            var point = self.center
            point.y -= 250
            self.center = point
        }) { (finished) in
            
        }
        view.addSubview(self)
    }
    
    @objc
    private func quit() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            var point = self.center
            point.y += 250
            self.center = point
        }) { (finished) in
            if let selectionBlock = self.selectionBlock {
                var tmpStr = ""
                for str in self.resultArr {
                    tmpStr = tmpStr + "," + str
                }
                if tmpStr.count > 0 && tmpStr.prefix(1) == "," {
                    tmpStr = String(tmpStr.suffix(from: tmpStr.index(after: tmpStr.startIndex)))
                }
                selectionBlock(tmpStr)
            }
            self.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTableIndentifier = "cellTableIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellTableIndentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellTableIndentifier)
        }
        let content = array[indexPath.row]
        if resultArr.contains(content) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        cell?.textLabel?.text = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected((cell?.isSelected)!, animated: true)
        let content = array[indexPath.row]
        if let index = resultArr.firstIndex(of: content) {
            resultArr.remove(at: index)
        } else {
            resultArr.append(content)
        }
        tableView.reloadData()
    }
}
