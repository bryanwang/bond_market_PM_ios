//
//  BondViewController.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupListComponent.h"

@interface BondViewController : BBCustomBackButtonViewController <UIAlertViewDelegate>

- (id)initWithBond: (NSDictionary *)bond;

@end
