//
//  BYBaseQuickDialogViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BYBaseQuickDialogViewController.h"
#import "BBCustomBackButtonViewController.h"

@interface BYBaseQuickDialogViewController ()

@end

@implementation BYBaseQuickDialogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *bv = [[UIView alloc]initWithFrame:self.view.bounds];
    bv.backgroundColor = RGBCOLOR(224, 221, 215);
    self.quickDialogTableView.backgroundView =bv;
    
    QAppearance *appearance = [QElement appearance];
    appearance.backgroundColorEnabled = RGBCOLOR(255, 255, 255);
    appearance.backgroundColorDisabled = RGBCOLOR(255, 255, 255);
    
    appearance.labelFont = [UIFont systemFontOfSize:12];
    appearance.labelColorEnabled = RGBCOLOR(100, 100, 100);
    appearance.labelColorDisabled = RGBCOLOR(100, 100, 100);
    
    appearance.valueFont = [UIFont systemFontOfSize:14];
    appearance.valueColorEnabled = RGBCOLOR(49, 49, 49);
    appearance.valueColorDisabled =RGBCOLOR(49, 49, 49);
    
    appearance.entryFont = [UIFont systemFontOfSize:14];
    appearance.entryTextColorEnabled = RGBCOLOR(49, 49, 49);
    appearance.entryTextColorDisabled =RGBCOLOR(49, 49, 49);
    
    appearance.sectionTitleFont = [UIFont systemFontOfSize:14];
    appearance.sectionTitleColor = RGBCOLOR(49, 49, 49);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)displayViewControllerForRoot:(QRootElement *)element {
    QuickDialogController *newController = [QuickDialogController controllerForRoot:element];
    [super displayViewController:newController];
}


// BYBaseQuickDialogViewController 主要作为 QuickDialog 中 ActionControl 的转发中转站
// 接收到 ActionControl 时间时 转发给 delegate 是完成具体实现
- (void)showLandTypes:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showLandTypes)])
        [self.delegate showLandTypes];
}

- (void)showEstateTypes:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showEstateTypes)])
        [self.delegate showEstateTypes];
}

- (void)showEquityTypes:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showEquityTypes)])
        [self.delegate showEquityTypes];
}

- (void)showReceivablesTypes:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showReceivablesTypes)])
        [self.delegate showReceivablesTypes];
}

- (void)showGuaranteeTypes:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showGuaranteeTypes)])
        [self.delegate showGuaranteeTypes];
}

- (void)showEnhancementsWays:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showEnhancementsWays)])
        [self.delegate showEnhancementsWays];
}

- (void)showBankSupportWays:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showBankSupportWays)])
        [self.delegate showBankSupportWays];
}

- (void)showOtherTrustWays:(QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showOtherTrustWays)])
        [self.delegate showOtherTrustWays];
}

- (void)handleEquityAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"Equity"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"股权所有人"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

- (void)handleGuaranteeAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"Guarantee"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"担保方"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

- (void)handleReceivablesAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"Receivables"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"应收账款对象"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

@end
