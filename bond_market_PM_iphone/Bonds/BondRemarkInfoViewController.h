//
//  BondRemarkInfoViewController.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BondRemarkInfoViewController : BBCustomBackButtonViewController

- (void)bindObject: (NSString *)remark;
- (void)setElementsEnable;
- (void)setElementsDisable;
- (NSString *)fetchData;

@end
