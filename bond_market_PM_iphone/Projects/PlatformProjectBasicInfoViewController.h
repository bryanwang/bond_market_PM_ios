//
//  PlatformProjectBasicInfoViewController.h
//  bond_market_PM_iphone
//
//  Created by YANG Yuxin on 13-6-19.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformProjectBasicInfoViewController : BYBaseQuickDialogViewController

- (void)bindObject: (NSDictionary *)obj;
- (void)setElementsEnable;
- (void)setElementsDisable;
- (NSMutableDictionary *)fetchData;

@end
