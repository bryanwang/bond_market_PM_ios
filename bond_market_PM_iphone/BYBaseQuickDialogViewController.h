//
//  BYBaseQuickDialogViewController.h
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYBaseQuickDialogDelegate <NSObject>

@optional

- (void)showLandTypes;
- (void)showEstateTypes;
- (void)showEquityTypes;
- (void)showReceivablesTypes;
- (void)showGuaranteeTypes;
- (void)showEnhancementsWays;
- (void)showBankSupportWays;
- (void)showOtherTrustWays;
- (void)showTrustWays;

@end


@interface BYBaseQuickDialogViewController : QuickDialogController

@property (nonatomic, strong) id<BYBaseQuickDialogDelegate> delegate;

@end
