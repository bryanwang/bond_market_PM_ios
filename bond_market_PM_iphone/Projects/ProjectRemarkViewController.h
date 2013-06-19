//
//  ProjectRemarkViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectRemarkViewController : BBCustomBackButtonViewController

- (void)bindObject: (NSString *)remark;
- (void)setElementsEnable;
- (void)setElementsDisable;
- (NSString *)fetchData;

@end
