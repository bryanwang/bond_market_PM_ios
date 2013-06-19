//
//  FinancingMethodViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum FinancingMethodEditStatus: NSUInteger {
    FinancingMethodEditing,
    FinancingMethodNormal
}FinancingMethodEditStatus;

@interface FinancingMethodViewController : BYQuickDialogWrappedViewController

@property (nonatomic) FinancingMethodEditStatus status;

- (void)bindObject: (id)financing;
- (id)fetchData;

@end
