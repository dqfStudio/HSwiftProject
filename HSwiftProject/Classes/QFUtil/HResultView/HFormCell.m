//
//  HFormCell.m
//  QFProj
//
//  Created by dqf on 2018/12/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

//#import "HFormCell.h"
//#import "HTupleView.h"
//
//@interface HFormCell ()
//@property (nonatomic) HTupleView *tupleView;
//@end
//
//@implementation HFormModel
//+ (HFormModel *)modelWithTitle:(NSString *)title icon:(NSString *)icon {
//    HFormModel *model = HFormModel.new;
//    model.title = title;
//    model.icon  = icon;
//    return model;
//}
//@end
//
//@implementation HFormCell
//
//- (HTupleView *)tupleView {
//    if (!_tupleView) {
//        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleDirectionHorizontal];
//        [_tupleView setBackgroundColor:[UIColor whiteColor]];
//        [_tupleView setPagingEnabled:YES];
//        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
//        // 设置默认参数
//        [self setup];
//        [self addSubview:_tupleView];
//    }
//    return _tupleView;
//}
//
//- (void)updateLayoutView {
//    HLayoutTupleCell(self.tupleView)
//}
//
//- (void)setup {
//    self.rows = 1;
//    self.rowItems = 4;
//}
//
//- (NSInteger)numberOfSectionsInTupleView {
//    NSInteger pages = 1;
//    if (self.modelArr) {
//
//        NSInteger items = self.modelArr.count;
//        NSInteger tmpItems = self.rows *self.rowItems;
//
//        pages = items/tmpItems;
//        tmpItems = pages *tmpItems;
//
//        if (tmpItems != items) {
//            pages += 1;
//        }
//    }
//    return pages;
//}
//
//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    return self.rows *self.rowItems;
//}
//
//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.tupleView.width/self.rowItems-1, self.tupleView.height/self.rows-1);
//}
//
//- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = indexPath.section *self.rows *self.rowItems + indexPath.row;
//    if (index < self.modelArr.count) {
//        HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
//        [cell.buttonView setTitleColor:[UIColor blackColor]];
//
//        HFormModel *model = [self.modelArr objectAtIndex:index];
//
//        [cell.buttonView setImage:[UIImage imageNamed:model.icon]];
//        [cell.buttonView setTitle:model.title];
//
//        [cell.buttonView setPressed:^(id sender, id data) {
//            if (self.formCellBlock) {
//                self.formCellBlock(indexPath, model);
//            }
//        }];
//    }else {
//        itemBlock(nil, HTupleBaseCell.class, nil, YES);
//    }
//}
//
//- (void)setModelArr:(NSArray<HFormModel *> *)modelArr {
//    if (_modelArr != modelArr) {
//        _modelArr = nil;
//        _modelArr = modelArr;
//        [self.tupleView reloadData];
//    }
//}
//
//@end
