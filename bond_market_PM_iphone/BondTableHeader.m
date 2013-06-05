//
//  BondTableHeader.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BondTableHeader.h"

@interface BondTableHeader()
@property (weak, nonatomic) IBOutlet UILabel *totalEntryFee;
@property (weak, nonatomic) IBOutlet UILabel *totalDeductFee;
@end

@implementation BondTableHeader

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.totalDeductFee setFont:[UIFont BertholdFontOfSize:36]];
    [self.totalEntryFee setFont:[UIFont BertholdFontOfSize:36]];
}

- (void)setInputInfo:(NSDictionary *)inputInfo
{
    self.totalDeductFee.text = [NSString stringWithFormat:@"%@", inputInfo[@"totalActualBonus"]];
    self.totalEntryFee.text = [NSString stringWithFormat:@"%@", inputInfo[@"totalInputBonus"]];
    
    [self setNeedsDisplay];
}

@end
