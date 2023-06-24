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
        set { self.text = newValue?.localized() }
    }
}

extension UIButton {
    var textLocalized: String? {
        get { return self.title(for: .normal) }
        set { self.setTitle(newValue?.localized(), for: .normal) }
    }
}

extension UITextView {
    var textLocalized: String? {
        get { return self.text }
        set { self.text = newValue?.localized() }
    }
}

extension UITextField {
    var textLocalized: String? {
        get { return self.text }
        set { self.text = newValue?.localized() }
    }
    var placeholderLocalized: String? {
        get { return self.placeholder }
        set { self.placeholder = newValue?.localized() }
    }
}
