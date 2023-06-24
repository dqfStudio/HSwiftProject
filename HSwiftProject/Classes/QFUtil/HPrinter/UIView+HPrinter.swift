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
        self.exclusive(exc: "logMarkExclusive", delay: 1) {
            self.logAction()
        }
    }
    
    private func logAction() {
        if self.isSystemClass(self.classForCoder) == false {
            print("HPrinting-->className:\(self.className)\n")
        }
        let loginfo = self.logInfo()
        if !loginfo.isEmpty {
            print("HPrinting-->loginfo:\(loginfo)\n")
        }
        if self.isKind(of: UILabel.self) {
            let label: UILabel = self as! UILabel
            if let text = label.text, !text.isEmpty {
                print("HPrinting-->label.text:\(text)\n")
            }
        }
        else if self.isKind(of: UITextView.self) {
            let textView: UITextView = self as! UITextView
            if let text = textView.text, !text.isEmpty {
                print("HPrinting-->textView.text:\(text)\n")
            }
        }
        else if self.isKind(of: UIControl.self) {
            if self.isKind(of: UIButton.self) {
                let btn: UIButton = self as! UIButton
                if let text = btn.titleLabel?.text, !text.isEmpty {
                    print("HPrinting-->button.text:\(text)\n")
                }
//                if btn.allTargets.count > 0 {
//                    let objc: AnyHashable = btn.allTargets.first!
//                    print("HPrinting-->button.targets:\(objc.description)\n")
//                }
                if let identifier = btn.imageView?.image?.accessibilityIdentifier, !identifier.isEmpty {
                    print("HPrinting-->button.image.name:\(identifier)\n")
                    return
                }
            }else if self.isKind(of: UIControl.self) {
//                let control: UIControl = self as! UIControl
//                if control.allTargets.count > 0 {
//                    let objc: AnyHashable = control.allTargets.first!
//                    print("HPrinting-->control.targets:\(objc.description)\n")
//                }
            }
        }
        else if self.isKind(of: UIImageView.self) {
            let imageView: UIImageView = self as! UIImageView
            if let identifier = imageView.image?.accessibilityIdentifier, !identifier.isEmpty {
                print("HPrinting-->imageView.image.name:\(identifier)\n")
            }
            return
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
        
        var next = self.next
        var controller: UIViewController?

        while next?.isKind(of: UIViewController.self) == false {
            next = next?.next
            if next == nil {
                break
            }
        }
        if next?.isKind(of: UIViewController.self) == true {
            controller = next as? UIViewController
            print("HPrinting-->viewController:\(controller!.className)\n")
        }
    }
    
    private func logInfo() -> String {
        let aKey: String = String(format: "%p", self)
        if HPrinterManager.share.containsObject(aKey) {
            return HPrinterManager.share.objectForKey(aKey)!
        }
        return ""
    }
    
#endif
    
}

//extension UIImage {
//
//    @objc class func swizzle() {
//        Swizzle(UIImage.self) {
////            #selector(imageNamed:) <-> #selector(myViewDidLoad)
//            #selector(init?(named _:)) <-> #selector(init?(mynamed _:))
//
////            init?(named name: String)
//        }
//    }
//
//    public /*not inherited*/ convenience init?(named name: String, file: String = #file) {
////        super.ini
//    }
//
//    @objc private func myViewDidLoad() {
//        print(#function)
//        myViewDidLoad()
//        UIImage(named: "")
//        UIImage.init(named: <#T##String#>)
////        UIImage.init(named: <#T##String#>)
//    }
//
//    @objc private func myViewWillAppear(_ animated: Bool) {
//        print(#function)
//        myViewWillAppear(animated)
//    }
//
//}


