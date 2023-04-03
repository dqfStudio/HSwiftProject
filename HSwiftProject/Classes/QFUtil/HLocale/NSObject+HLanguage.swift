//
//  NSObject+HLanguage.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/16.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

///主要用于词条的本地化
public extension String {
    func localized() -> String {
        return self
    }
}

extension UILabel {
    var textLocalized: String? {
        get { return self.text }
        set {
            if newValue != nil, newValue!.isEmpty != false {
                self.text = newValue!.localized()
            }else {
                self.text = newValue
            }
        }
    }
}

extension UIButton {
    var textLocalized: String? {
        get { return self.title(for: .normal) }
        set {
            if newValue != nil, newValue!.isEmpty != false {
                self.setTitle(newValue!.localized(), for: .normal)
            }else {
                self.setTitle(newValue, for: .normal)
            }
        }
    }
}

extension UITextView {
    var textLocalized: String? {
        get { return self.text }
        set {
            if newValue != nil, newValue!.isEmpty != false {
                self.text = newValue!.localized()
            }else {
                self.text = newValue
            }
        }
    }
}

extension UITextField {
    var textLocalized: String? {
        get { return self.text }
        set {
            if newValue != nil, newValue!.isEmpty != false {
                self.text = newValue!.localized()
            }else {
                self.text = newValue
            }
        }
    }
    var placeholderLocalized: String? {
        get { return self.placeholder }
        set {
            if newValue != nil, newValue!.isEmpty != false {
                self.placeholder = newValue!.localized()
            }else {
                self.placeholder = newValue
            }
        }
    }
}
