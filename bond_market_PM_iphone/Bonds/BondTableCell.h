//
//  BondTableCell.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum BondStatus:NSInteger{
    Auditing,
    Audited,
    AuditedFailed,
    Matchting,
    Matched,
    MatchedFailed
} BondStatus;

@interface BondTableCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *bond;
@end
