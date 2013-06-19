//
//  BYQuickDialogWrappedViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BYQuickDialogWrappedViewController.h"

@interface BYQuickDialogWrappedViewController () 

@end

@implementation BYQuickDialogWrappedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    RunBlockAfterDelay(.3, ^{
        [self.view addSubview:self.qc.view];
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end




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
    QSection  *section = [root sectionWithKey:@"股权所有人"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"股权所有人"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

- (void)handleGuaranteeAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"担保方"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"担保方"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

- (void)handleReceivablesAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"应收账款对象"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"应收账款对象"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}

- (void)handleAntiGuarantorAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root sectionWithKey:@"反担保人"];
    if (section) {
        QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"反担保人"];
        [section insertElement:e1 atIndex: section.elements.count - 1];
        [self.quickDialogTableView reloadData];
    }
}



//projects
- (void)AddLiquidity: (QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(AddLiquidity)])
        [self.delegate AddLiquidity];
}

- (void)DebtRestructuring: (QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(DebtRestructuring)])
        [self.delegate DebtRestructuring];
}

- (void)EquityInvestmentProjects: (QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(EquityInvestmentProjects)])
        [self.delegate EquityInvestmentProjects];
}

- (void)OtherPurposes: (QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(OtherPurposes)])
        [self.delegate OtherPurposes];
}

- (void)showAntiGuarantor: (QElement *)element
{
    if ([self.delegate respondsToSelector:@selector(showAntiGuarantor)])
        [self.delegate showAntiGuarantor];
}

@end
