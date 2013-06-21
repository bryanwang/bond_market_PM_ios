//
//  BondFinancialIndicatorsViewController.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BondFinancialIndicatorsViewController : BYBaseQuickDialogViewController

- (void)bindObject: (NSDictionary *)obj;
- (void)setElementsEnable;
- (void)setElementsDisable;
- (NSMutableDictionary *)fetchData;

@end
