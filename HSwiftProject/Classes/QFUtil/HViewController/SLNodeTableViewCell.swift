////
////  SLNodeTableViewCell.swift
////  HSwiftProject
////
////  Created by owner on 2024/6/3.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import UIKit
//
//protocol SLNodeTableViewCellDelegate: NSObjectProtocol {
//    - (void)nodeTableViewCell:(SLNodeTableViewCell *)cell selected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath; //选中的代理
//    - (void)nodeTableViewCell:(SLNodeTableViewCell *)cell expand:(BOOL)expand atIndexPath:(NSIndexPath *)indexPath;  //展开的代理
//}
////@objc protocol HTupleViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
////    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor
////}
//
//class SLNodeTableViewCell: UITableViewCell {
// 
//    var node: SLNodeModel; // 结点
//    var cellIndexPath: NSIndexPath // cell的位置
//    var cellSize: CGSize // 宽高
//    var delegate: SLNodeTableViewCellDelegate?
//    
////    @property (nonatomic, strong) UIButton *selectedBtn; // 选中按钮
////    @property (nonatomic, strong) UILabel *nameLabel; // 名字
////    @property (nonatomic, strong) UIButton *expandBtn; // 展开按钮
////    @property (nonatomic, strong) UIView *line; // 细线
//
////    - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//    func refreshCell() {
//        
//    }
//    
//    - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//        if (self) {
//            _selectedBtn = [[UIButton alloc] init];
//            [_selectedBtn addTarget:self action:@selector(selectedClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [self.contentView addSubview:_selectedBtn];
//            _nameLabel = [[UILabel alloc] init];
//            [self.contentView addSubview:_nameLabel];
//            _expandBtn = [[UIButton alloc] init];
//            [_expandBtn addTarget:self action:@selector(expandBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [self.contentView addSubview:_expandBtn];
//        }
//        return self;
//    }
//
//    #pragma mark - Help Methods
//
//    - (void)refreshCell {
//        
//        if(self.node.selected){
//            [_selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//        }else{
//            [_selectedBtn setImage:[UIImage imageNamed:@"disSelected"] forState:UIControlStateNormal];
//        }
//        if (self.node.expand) {
//            [_expandBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
//        }else{
//            [_expandBtn setImage:[UIImage imageNamed:@"noExpand"] forState:UIControlStateNormal];
//        }
//        
//        CGSize selectedSize = CGSizeMake(20, 20);
//        CGSize expandSize = CGSizeMake(20, 20);
//        _selectedBtn.frame = CGRectMake(8 + (self.node.level - 1) * selectedSize.width, (self.cellSize.height - selectedSize.height)/2.0, selectedSize.width, selectedSize.height);
//        _expandBtn.frame = CGRectMake(self.cellSize.width - 8 - expandSize.width, (self.cellSize.height - expandSize.height)/2.0, selectedSize.width, selectedSize.height);
//        _nameLabel.frame = CGRectMake(_selectedBtn.frame.origin.x + selectedSize.width + 8, 0, _expandBtn.frame.origin.x - 8 - (_selectedBtn.frame.origin.x + selectedSize.width + 8), self.cellSize.height);
//        _nameLabel.text = self.node.name;
//        
//        if (_node.leaf) {
//            _expandBtn.hidden = YES;
//        }else{
//            _expandBtn.hidden = NO;
//        }
//        
//    }
//
//    #pragma mark - Event Handle
//
//    - (void)selectedClicked:(UIButton *)btn {
//        if(!self.node.selected){
//            [_selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//        }else{
//            [_selectedBtn setImage:[UIImage imageNamed:@"disSelected"] forState:UIControlStateNormal];
//        }
//        self.node.selected = !self.node.selected;
//        if ([self.delegate respondsToSelector:@selector(nodeTableViewCell:selected:atIndexPath:)]) {
//            [self.delegate nodeTableViewCell:self selected:self.node.selected atIndexPath:self.cellIndexPath];
//        }
//    }
//
//    - (void)expandBtnClicked:(UIButton *)btn {
//        if (!self.node.expand) {
//            [_expandBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
//        }else{
//            [_expandBtn setImage:[UIImage imageNamed:@"noExpand"] forState:UIControlStateNormal];
//        }
//        self.node.expand = !self.node.expand;
//        if ([self.delegate respondsToSelector:@selector(nodeTableViewCell:expand:atIndexPath:)]) {
//            [self.delegate nodeTableViewCell:self expand:self.node.expand atIndexPath:self.cellIndexPath];
//        }
//    }
//
//    
//}
