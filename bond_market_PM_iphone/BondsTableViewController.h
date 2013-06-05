//
//  BondsTableViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum BondsOrderType: NSUInteger
{
    OrderByTime,
    OrderByTimeDesc,
    OrderByChargePerson
} BondsOrderType;

@interface BondsTableViewController : UITableViewController
@property (nonatomic) BondsOrderType orderType;

- (void) reloadTableview;
- (void) fetchMyBonds;

@end
