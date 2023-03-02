//
//  HTupleViewCell.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleBlankCell : HTupleBaseCell {
    private var _view: UIView?
    var view: UIView {
        if _view == nil {
            _view = UIView()
            self.layoutView.addSubview(_view!)
        }
        return _view!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.view)
    }
}

class HTupleLabelCell : HTupleBaseCell {
    private var _label: UILabel?
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_label!)
        }
        return _label!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.label)
    }
}

class HTupleTextCell : HTupleBaseCell {
    private var _textView: UITextView?
    var textView: UITextView {
        if _textView == nil {
            _textView = UITextView()
            _textView!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_textView!)
        }
        return _textView!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.textView)
    }
}

class HTupleButtonCell : HTupleBaseCell {
    private var _buttonView: HWebButtonView?
    var buttonView: HWebButtonView {
        if _buttonView == nil {
            _buttonView = HWebButtonView()
            self.layoutView.addSubview(_buttonView!)
        }
        return _buttonView!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.buttonView)
    }
}

class HTupleImageCell : HTupleBaseCell {
    private var _imageView: HWebImageView?
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
            self.layoutView.addSubview(_imageView!)
        }
        return _imageView!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.imageView)
    }
}

class HTupleTextFieldCell : HTupleBaseCell {
    private var _textField: HTextField?
    var textField: HTextField {
        if _textField == nil {
            _textField = HTextField()
            HLayoutTupleCell(_textField!)
            self.layoutView.addSubview(_textField!)
        }
        return _textField!
    }
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.textField)
    }
}

class HTupleViewCell : HTupleBaseCell {
    
    private var _label: UILabel?
    ///label
    var label: UILabel {
        if _label == nil {
            _label = UILabel()
            _label!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_label!)
        }
        return _label!
    }
    private var _detailLabel: UILabel?
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_detailLabel!)
        }
        return _detailLabel!
    }
    private var _accessoryLabel: UILabel?
    var accessoryLabel: UILabel {
        if _accessoryLabel == nil {
            _accessoryLabel = UILabel()
            _accessoryLabel!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_accessoryLabel!)
        }
        return _accessoryLabel!
    }

    
    private var _textView: UITextView?
    ///textView
    var textView: UITextView {
        if _textView == nil {
            _textView = UITextView()
            _textView!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_textView!)
        }
        return _textView!
    }
    private var _detailTextView: UITextView?
    var detailTextView: UITextView {
        if _detailTextView == nil {
            _detailTextView = UITextView()
            _detailTextView!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_detailTextView!)
        }
        return _detailTextView!
    }
    private var _accessoryTextView: UITextView?
    var accessoryTextView: UITextView {
        if _accessoryTextView == nil {
            _accessoryTextView = UITextView()
            _accessoryTextView!.font = UIFont.systemFont(ofSize: 14)
            self.layoutView.addSubview(_accessoryTextView!)
        }
        return _accessoryTextView!
    }

    
    private var _buttonView: HWebButtonView?
    ///button
    var buttonView: HWebButtonView {
        if _buttonView == nil {
            _buttonView = HWebButtonView()
            self.layoutView.addSubview(_buttonView!)
        }
        return _buttonView!
    }
    private var _detailButtonView: HWebButtonView?
    var detailButtonView: HWebButtonView {
        if _detailButtonView == nil {
            _detailButtonView = HWebButtonView()
            self.layoutView.addSubview(_detailButtonView!)
        }
        return _detailButtonView!
    }
    private var _accessoryButtonView: HWebButtonView?
    var accessoryButtonView: HWebButtonView {
        if _accessoryButtonView == nil {
            _accessoryButtonView = HWebButtonView()
            self.layoutView.addSubview(_accessoryButtonView!)
        }
        return _accessoryButtonView!
    }

    
    private var _imageView: HWebImageView?
    ///imageView
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
            self.layoutView.addSubview(_imageView!)
        }
        return _imageView!
    }
    private var _detailImageView: HWebImageView?
    var detailImageView: HWebImageView {
        if _detailImageView == nil {
            _detailImageView = HWebImageView()
            self.layoutView.addSubview(_detailImageView!)
        }
        return _detailImageView!
    }
    private var _accessoryImageView: HWebImageView?
    var accessoryImageView: HWebImageView {
        if _accessoryImageView == nil {
            _accessoryImageView = HWebImageView()
            self.layoutView.addSubview(_accessoryImageView!)
        }
        return _accessoryImageView!
    }

    
    private var _textField: HTextField?
    ///textField
    var textField: HTextField {
        if _textField == nil {
            _textField = HTextField()
            HLayoutTupleCell(_textField!)
            self.layoutView.addSubview(_textField!)
        }
        return _textField!
    }
    private var _detailTextField: HTextField?
    var detailTextField: HTextField {
        if _detailTextField == nil {
            _detailTextField = HTextField()
            HLayoutTupleCell(_detailTextField!)
            self.layoutView.addSubview(_detailTextField!)
        }
        return _detailTextField!
    }
    private var _accessoryTextField: HTextField?
    var accessoryTextField: HTextField {
        if _accessoryTextField == nil {
            _accessoryTextField = HTextField()
            HLayoutTupleCell(_accessoryTextField!)
            self.layoutView.addSubview(_accessoryTextField!)
        }
        return _accessoryTextField!
    }

}
