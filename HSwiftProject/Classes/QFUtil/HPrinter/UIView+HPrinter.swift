//
//  UIView+HPrinter.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/15.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIView {
    
    public func addSubview(_ view: UIView, file: String = #file) {
#if DEBUG
        let filePath: String
        if file.contains(".") {
            filePath = file.components(separatedBy: "/").last ?? ""
        }else {
            filePath = file
        }
        let aKey: String = String(format: "%p", view)
        HPrinterManager.share.setObject(filePath, forKey: aKey as NSCopying)
#endif
        self.addSubview(view)
    }
    
#if DEBUG
    
    public func logMark() {
        self.exclusive(exc: "logMarkExclusive", delay: 1.0) {
            self.logAction()
        }
    }
    
    private func logAction() {
        
        if self.isSystemClass(self.classForCoder) == false {
            print("HPrinting-->className:\(self.className)\n")
        }
        
        if let loginfo = self.logInfo(), !loginfo.isEmpty {
            print("HPrinting-->loginfo:\(loginfo)\n")
        }

        if let label = self as? UILabel, let text = label.text, !text.isEmpty {
            print("HPrinting-->label.text:\(text)\n")
        }
        else if let textView = self as? UITextView, let text = textView.text, !text.isEmpty {
            print("HPrinting-->textView.text:\(text)\n")
        }
        else if let btn = self as? UIButton, let text = btn.titleLabel?.text, !text.isEmpty {
            print("HPrinting-->button.text:\(text)\n")
        }
        
        if let superview = self.superview, self.isSystemClass(superview.classForCoder) == false {
            print("HPrinting-->super[1]ClassName:\(superview.className)\n")
        }else if let superview = self.superview?.superview, self.isSystemClass(superview.classForCoder) == false {
            print("HPrinting-->super[2]ClassName:\(superview.className)\n")
        }else if let superview = self.superview?.superview?.superview, self.isSystemClass(superview.classForCoder) == false {
            print("HPrinting-->super[3]ClassName:\(superview.className)\n")
        }
        
        self.logVC()
        
    }
    
    private func logVC() {
        guard let controller = findViewController() else { return }
        print("HPrinting-->viewController:\(controller.className)\n")
    }

    private func findViewController() -> UIViewController? {
        var next = self.next
        while let current = next {
            if current is UIViewController {
                return current as? UIViewController
            }
            next = current.next
        }
        return nil
    }

    private func logInfo() -> String? {
        let aKey = String(format: "%p", self)
        if HPrinterManager.share.containsObject(aKey) {
            return HPrinterManager.share.objectForKey(aKey)
        }
        return nil
    }
    
#endif
    
}
