//
//  BYQuickDialogWrappedViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYBaseQuickDialogDelegate <NSObject>

@optional

//bonds
- (void)showLandTypes;
- (void)showEstateTypes;
- (void)showEquityTypes;
- (void)showReceivablesTypes;
- (void)showGuaranteeTypes;
- (void)showEnhancementsWays;
- (void)showBankSupportWays;
- (void)showOtherTrustWays;
- (void)showTrustWays;

//projects
- (void)AddLiquidity;
- (void)DebtRestructuring;
- (void)EquityInvestmentProjects;
- (void)OtherPurposes;
- (void)showAntiGuarantor;

@end


@interface BYBaseQuickDialogViewController : QuickDialogController

@property (nonatomic, strong) id<BYBaseQuickDialogDelegate> delegate;

@end


@interface BYQuickDialogWrappedViewController : BBCustomBackButtonViewController

@property (strong, nonatomic) BYBaseQuickDialogViewController *qc;

- (void)setupQuickDialogControllerWithRoot: (QRootElement *)root;

@end
