//
//  ViewController.h
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BondBasicInfoViewController : BYBaseQuickDialogViewController

- (void)bindObject: (NSDictionary *)obj;
- (void)setElementsEnable;
- (void)setElementsDisable;
- (NSMutableDictionary *)fetchData;

@end
