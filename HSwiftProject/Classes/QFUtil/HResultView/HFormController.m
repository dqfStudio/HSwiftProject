//
//  HFormController.m
//  QFProj
//
//  Created by dqf on 2018/12/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

//#import "HFormController.h"
//#import "UIScreen+HUtil.h"
//#import "HTupleView.h"
//
//#define KItemHeight     80
//#define KFooterHeight   50
//
//@interface HFormController ()
//@property (nonatomic) HTupleView *tupleView;
//@property (nonatomic) NSInteger numberOfRows;
//@property (nonatomic) NSInteger rowItems;
//@property (nonatomic, copy) NSArray *sourceArr;
//@property (nonatomic, copy) HFormCellBlock cellBlock;
//@end
//
//@implementation HFormController
//
//+ (instancetype)formControllerWithModel:(NSArray<HFormModel *> *)models
//                           numberOfRows:(NSInteger)rows
//                               rowItems:(NSInteger)items
//                            buttonBlock:(HFormCellBlock)buttonBlock {
//    HFormController *formController = HFormController.new;
//    formController.sourceArr = models;
//    formController.numberOfRows = rows;
//    formController.rowItems = items;
//    [formController setup];
//    return formController;
//}
//
//- (HTupleView *)tupleView {
//    if (!_tupleView) {
//        CGRect frame = [UIScreen mainScreen].bounds;
//        _tupleView = [[HTupleView alloc] initWithFrame:frame];
//        [_tupleView bounceDisenable];
//        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
//    }
//    return _tupleView;
//}
//
//- (void)setup {
//    //添加view
//    [[UIApplication sharedApplication].delegate.window addSubview:self.tupleView];
//}
//
//- (NSInteger)numberOfSectionsInTupleView {
//    return 1;
//}
//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGSize)sizeForHeaderInSection:(NSInteger)section {
//    NSInteger height = KFooterHeight;
//    if (UIScreen.isIPhoneX) height += UIScreen.bottomBarHeight;
//    return CGSizeMake(self.tupleView.width, self.tupleView.height-KItemHeight *self.numberOfRows-height);
//}
//- (CGSize)sizeForFooterInSection:(NSInteger)section {
//    NSInteger height = KFooterHeight;
//    if (UIScreen.isIPhoneX) height += UIScreen.bottomBarHeight;
//    return CGSizeMake(self.tupleView.width, height);
//}
//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.tupleView.width, KItemHeight *self.numberOfRows);
//}
//
//- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section {
//    NSInteger height = 0;
//    if (UIScreen.isIPhoneX) height += UIScreen.bottomBarHeight;
//    return UIEdgeInsetsMake(10, 0, height, 0);
//}
//
//- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
//    headerBlock(nil, HTupleButtonApex.class, nil, YES);
////    HTupleButtonApex *cell = headerBlock(nil, HTupleButtonApex.class, nil, YES);
////    [cell.buttonView setPressed:^(id sender, id data) {
////        //销毁对象
////        [self destroy];
////    }];
//}
//- (void)tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
//    HTupleButtonApex *cell = footerBlock(nil, HTupleButtonApex.class, nil, YES);
//    [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
//    [cell.buttonView setTitleColor:[UIColor blackColor]];
//    [cell.buttonView setTitle:@"取消"];
//    [cell.buttonView setPressed:^(id sender, id data) {
//        //销毁对象
//        [self destroy];
//    }];
//}
//- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
//    HFormCell *cell = itemBlock(nil, HFormCell.class, nil, YES);
//    [cell setModelArr:self.sourceArr];
//
//    //配置参数
//    [cell setRows:self.numberOfRows];
//    [cell setRowItems:self.rowItems];
//    @www
//    [cell setFormCellBlock:^(NSIndexPath *idxPath, HFormModel *model) {
//        @sss
//        if (self.cellBlock) {
//            self.cellBlock(indexPath, model);
//        }
//    }];
//}
//
////销毁对象
//- (void)destroy {
//    //弹框消失
//    [self.tupleView removeFromSuperview];
//}
//
//@end
