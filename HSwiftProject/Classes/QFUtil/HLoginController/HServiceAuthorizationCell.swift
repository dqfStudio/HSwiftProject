//
//  HServiceAuthorizationCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HServiceAgreementBlock = () -> Void
//typedef void(^HServiceAgreementBlock)(void)

class HServiceAuthorizationCell : HTupleLabelCell {
    
    ///default is true
    var isAuthorized: Bool = true
    var serviceAgreementBlock: HServiceAgreementBlock?
    
//@property(nonatomic, getter=isAuthorized) BOOL authorized //default is YES
//@property(nonatomic, copy) HServiceAgreementBlock serviceAgreementBlock
//@end
//
//@interface HServiceAuthorizationCell ()
    
    private var _buttonView: HWebButtonView?
    private var buttonView: HWebButtonView? {
        if _buttonView == nil {
            _buttonView = HWebButtonView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            _buttonView!.setImage(UIImage(named: "registet_checkbox_icon"), for: .normal)
            _buttonView!.setImage(UIImage(named: "registet_checkbox_icon_h"), for: .selected)
            _buttonView!.isSelected = !_buttonView!.isSelected
            _buttonView!.pressed = { (target, data) in
                let buttonView = target as! HWebButtonView
                buttonView.isSelected = !buttonView.isSelected
            }
        }
        return _buttonView!
    }
    
    private var _attributedString: NSMutableAttributedString?
//    private var attributedString: NSMutableAttributedString {
//        get {
//            if _attributedString == nil {
////                _buttonView = [[HWebButtonView alloc] initWithFrame:CGRect(x: 0, y: 0, width: 20, height: 20)]
////                [_buttonView setImage:[UIImage imageNamed:@"registet_checkbox_icon"] forState:UIControlStateNormal]
////                [_buttonView setImage:[UIImage imageNamed:@"registet_checkbox_icon_h"] forState:UIControlStateSelected]
////                [_buttonView setSelected:!_buttonView.isSelected]
////                [_buttonView setPressed:^(HWebButtonView *buttonView, id data) {
////                    [buttonView setSelected:!buttonView.isSelected]
////                }]
//
//                _attributedString = NSMutableAttributedString.init(string: <#T##String#>, attributes: <#T##[NSAttributedString.Key : Any]?#>)
//                _attributedString = [NSMutableAttributedString h_attachmentStringWithContent:_buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:_buttonView.frame.size  alignToFont:[UIFont systemFontOfSize:14] alignment:HTextVerticalAlignmentCenter]
//
//                NSString *string1 = @"点击开始，即表示已阅读并同意"
//                NSString *string2 = @"《服务协议》"
//
//                [_attributedString h_appendString:string1]
//                [_attributedString h_appendString:string2]
//
//                [_attributedString h_setColor:[UIColor colorWithString:@"#BABABF"] range:NSMakeRange(1, string1.length)]
//                [_attributedString h_setColor:[UIColor colorWithString:@"#34BDD7"] range:NSMakeRange(string1.length+1, string2.length)]
//                //设置点击
//                HTextHighlight *highlight = HTextHighlight.new
//                @www
//                highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        @sss
//                        if (self.serviceAgreementBlock) {
//                            self.serviceAgreementBlock()
//                        }
//                    })
//                }
//                [_attributedString h_setTextHighlight:highlight range:NSMakeRange(string1.length, string2.length)]
//            }
//            return _attributedString
//        }
//    }
    
//@property (nonatomic) NSMutableAttributedString *attributedString
//@property (nonatomic) HWebButtonView *buttonView
//@end
//
//@implementation HServiceAuthorizationCell
//    - (NSMutableAttributedString *)attributedString {
//        if (!_attributedString) {
//            _buttonView = [[HWebButtonView alloc] initWithFrame:CGRect(x: 0, y: 0, width: 20, height: 20)]
//            [_buttonView setImage:[UIImage imageNamed:@"registet_checkbox_icon"] forState:UIControlStateNormal]
//            [_buttonView setImage:[UIImage imageNamed:@"registet_checkbox_icon_h"] forState:UIControlStateSelected]
//            [_buttonView setSelected:!_buttonView.isSelected]
//            [_buttonView setPressed:^(HWebButtonView *buttonView, id data) {
//                [buttonView setSelected:!buttonView.isSelected]
//            }]
//
//            _attributedString = [NSMutableAttributedString h_attachmentStringWithContent:_buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:_buttonView.frame.size  alignToFont:[UIFont systemFontOfSize:14] alignment:HTextVerticalAlignmentCenter]
//
//            NSString *string1 = @"点击开始，即表示已阅读并同意"
//            NSString *string2 = @"《服务协议》"
//
//            [_attributedString h_appendString:string1]
//            [_attributedString h_appendString:string2]
//
//            [_attributedString h_setColor:[UIColor colorWithString:@"#BABABF"] range:NSMakeRange(1, string1.length)]
//            [_attributedString h_setColor:[UIColor colorWithString:@"#34BDD7"] range:NSMakeRange(string1.length+1, string2.length)]
//            //设置点击
//            HTextHighlight *highlight = HTextHighlight.new
//            @www
//            highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    @sss
//                    if (self.serviceAgreementBlock) {
//                        self.serviceAgreementBlock()
//                    }
//                })
//            }
//            [_attributedString h_setTextHighlight:highlight range:NSMakeRange(string1.length, string2.length)]
//        }
//        return _attributedString
//    }
    
    override func initUI() {
//        self.label.attributedText = self.attributedString
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textAlignment = .center
    }
}
