//
//  InputInfoTableHeader.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "InputInfoTableHeader.h"

@interface InputInfoTableHeader ()
@property (weak, nonatomic) IBOutlet UILabel *totalEntryFee;
@property (weak, nonatomic) IBOutlet UILabel *totalDeductFee;
@end

@implementation InputInfoTableHeader

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
