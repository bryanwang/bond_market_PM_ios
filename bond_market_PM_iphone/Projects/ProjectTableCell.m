//
//  ProjectTableCell.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectTableCell.h"

@interface ProjectTableCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *captain;
@property (weak, nonatomic) IBOutlet UIImageView *iconcaptain;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UIView *tagstatus;
@property (weak, nonatomic) IBOutlet UIView *sepview;

@property (weak, nonatomic) IBOutlet UILabel *inputBonus;
@property (weak, nonatomic) IBOutlet UILabel *estimateBonus;

@end

@implementation ProjectTableCell

- (void)setProject:(NSDictionary *)project
{
    if (![_project isEqualToDictionary:project]) {
        _project = project;
        NSDictionary *info = project[@"ProjectInfo"];
        NSDictionary *owner =  project[@"OwnerInfo"];
        NSDictionary *inputInfo = project[@"InputInfo"];
        
        self.title.text = info[@"Subject"];
        self.type.text = info[@"Type"] && ![info[@"Type"] isEqual:[NSNull null]]? info[@"Type"] : @"";
        
        self.inputBonus.text = [NSString stringWithFormat:@"%@", inputInfo[@"InputBonus"]];
        self.estimateBonus.text = [NSString stringWithFormat:@"%@", inputInfo[@"EstimateBonus"]];
        
        if (![owner[@"Name"] isEqual: NSLocalizedString(@"no owner", "")]) {
            self.captain.text = owner[@"Name"];
        } else {
            [self.captain removeFromSuperview];
            [self.iconcaptain removeFromSuperview];
        }
        
        //status
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


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    NSUInteger status = [self.project[@"ProjectInfo"][@"Status"] integerValue];
    if (status == MatchedFailed || status == AuditedFailed) {
        self.tagstatus.backgroundColor = RGBCOLOR(197, 193, 186);
    }
    else {
        self.tagstatus.backgroundColor = RGBCOLOR(182, 12, 16);
        self.sepview.backgroundColor = RGBCOLOR(145, 144, 142);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSUInteger status = [self.project[@"ProjectInfo"][@"Status"] integerValue];
    if (status == MatchedFailed || status == AuditedFailed) {
        self.tagstatus.backgroundColor = RGBCOLOR(197, 193, 186);
    }
    else {
        self.tagstatus.backgroundColor = RGBCOLOR(182, 12, 16);
        self.sepview.backgroundColor = RGBCOLOR(145, 144, 142);
    }
}
@end
