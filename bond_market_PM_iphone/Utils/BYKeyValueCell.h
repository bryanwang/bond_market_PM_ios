//
//  BYKeyValueCell.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYKeyValueCell : UITableViewCell

@property (nonatomic, strong)NSDictionary *data;
- (float)cellHeight;

@end