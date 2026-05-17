//
//  HAdvertsVC+HSingle.swift
//  HSwiftProject
//
//  Created by owner on 2024/12/21.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

extension HAdvertsVC {

    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 1
    }
    @objc
    func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tuple0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 50, left: 8, bottom: 0, right: 8)
    }
    @objc
    func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = self.tupleView.width(forSection: indexPath.section)
        return CGSize(width: width, height: 280)
    }
    @objc
    func tuple0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
        let cellBounds = cell.layoutViewBounds
        cell.imageView.frame = cellBounds
        cell.imageView.setImage(named: "IMG_1446")
        
        // 视频
        if self.videoView.superview == nil {
            self.videoView.makeFrame {
                var frame = cellBounds
                frame.y = 40
                frame.height = 200
                return frame
            }
            self.videoView.setTopLine(withColor: UIColor.white, lineHeight: 2)
            //self.videoView.setBottomLine(withColor: UIColor.white, lineHeight: 2)
            cell.contentView.addSubview(self.videoView)
        }
        
        // 栏目
        cell.detailView.makeFrame {
            var frame = cellBounds
            frame.x = 5
            frame.y = 15
            frame.height = 55
            frame.width = 40
            return frame
        }
        
        cell.detailView.alpha = 0.95
        cell.detailView.setImage(named: "2024222")
        
        // 标题
        //cell.label.text = "绿蛙叫嚣 蔡正元怒呛"
        cell.label.text = "清峰说事  话天下"
        cell.label.alpha = 0.95
        cell.label.cornerRadius = 8
        cell.label.backgroundColor = UIColor(hex: "#FF403A")
        cell.label.font = UIFont.font(ofSize: 14, weight: .medium)
        cell.label.textAlignment = .center
        cell.label.textColor = .yellow
        let labelWidth = cell.label.intrinsicContentSize.width + 30
        cell.label.makeFrame {
            var frame = cellBounds
            frame.x = 60 + (frame.width - 60 - labelWidth) / 2
            frame.width = labelWidth
            frame.height = 40
            return frame
        }
    }

}

extension HAdvertsVC {

    @objc
    func tuple1_numberOfSectionsInTupleView() -> Any {
        return 1
    }
    @objc
    func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tuple1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 50, left: 8, bottom: 0, right: 8)
    }
    @objc
    func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = self.tupleView.width(forSection: indexPath.section)
        return CGSize(width: width, height: 280)
    }
    @objc
    func tuple1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
        let cellBounds = cell.layoutViewBounds
        cell.imageView.frame = cellBounds
        cell.imageView.setImage(named: "IMG_1446")
        
        // 视频
        if self.videoView.superview == nil {
            self.videoView.makeFrame {
                var frame = cellBounds
                frame.y = 40
                frame.height = 200
                return frame
            }
            self.videoView.setTopLine(withColor: UIColor.white, lineHeight: 2)
            //self.videoView.setBottomLine(withColor: UIColor.white, lineHeight: 2)
            cell.contentView.addSubview(self.videoView)
        }
        
        // 栏目
        cell.detailView.makeFrame {
            var frame = cellBounds
            frame.x = 5
            frame.y = 15
            frame.height = 55
            frame.width = 40
            return frame
        }
        
        cell.detailView.alpha = 0.95
        cell.detailView.setImage(named: "2024222")
        
        // 标题
        //cell.label.text = "绿蛙叫嚣 蔡正元怒呛"
        cell.label.text = "清峰说事  话天下"
        cell.label.alpha = 0.95
        cell.label.cornerRadius = 8
        cell.label.backgroundColor = UIColor(hex: "#FF403A")
        cell.label.font = UIFont.font(ofSize: 14, weight: .medium)
        cell.label.textAlignment = .center
        cell.label.textColor = .yellow
        let labelWidth = cell.label.intrinsicContentSize.width + 30
        cell.label.makeFrame {
            var frame = cellBounds
            frame.x = 60 + (frame.width - 60 - labelWidth) / 2
            frame.width = labelWidth
            frame.height = 40
            return frame
        }
        
        // 子标题
        cell.detailLabel.text = "绿蛙叫嚣 蔡正元怒呛"
        cell.detailLabel.alpha = 0.95
        cell.detailLabel.backgroundColor = .yellow
        cell.detailLabel.font = UIFont.font(ofSize: 14, weight: .medium)
        cell.detailLabel.textAlignment = .center
        cell.detailLabel.numberOfLines = 2
        cell.detailLabel.textColor = UIColor(hex: "#FF403A")
        cell.detailLabel.makeFrame {
            var frame = cellBounds
            frame.y = frame.height - 40
            frame.width = frame.width
            frame.height = 40
            return frame
        }
    }

}
