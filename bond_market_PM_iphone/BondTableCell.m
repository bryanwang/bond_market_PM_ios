//
//  BondTableCell.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BondTableCell.h"

@interface BondTableCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *captain;
@property (weak, nonatomic) IBOutlet UIImageView *iconcaptain;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UIView *tagstatus;

@end

@implementation BondTableCell

- (void)setBond:(NSDictionary *)bond
{
    if (![_bond isEqualToDictionary:bond]) {
        _bond = bond;
        NSDictionary *info = bond[@"NewBondInfo"];
        NSDictionary *owner =  bond[@"OwnerInfo"];
        self.title.text = info[@"ShortTitle"];
        self.type.text = info[@"Type"];
        
        if (![owner[@"Name"] isEqual: NSLocalizedString(@"no owner", "")]) {
             self.captain.text = owner[@"Name"];
         } else {
             [self.captain removeFromSuperview];
             [self.iconcaptain removeFromSuperview];
         }
        
        switch ([info[@"Status"] integerValue]) {
            case Auditing:
                self.status.image = [UIImage imageNamed:@"status-0"];
                break;
            case Audited:
                self.status.image = [UIImage imageNamed:@"status-1"];
                break;
            case AuditedFailed:
                self.status.image = [UIImage imageNamed:@"status-4"];
                self.tagstatus.backgroundColor = RGBCOLOR(197, 193, 186);
                break;
            case Matchting:
                self.status.image = [UIImage imageNamed:@"status-2"];
                break;
            case Matched:
                self.status.image = [UIImage imageNamed:@"status-3"];
                break;
            case MatchedFailed:
                self.status.image = [UIImage imageNamed:@"status-5"];
                self.tagstatus.backgroundColor = RGBCOLOR(197, 193, 186);
                break;
        }
    }
}

@end
