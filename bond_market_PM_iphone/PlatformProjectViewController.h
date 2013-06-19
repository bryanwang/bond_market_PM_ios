//
//  PlatformProjectViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformProjectBasicInfoViewController.h"
#import "PlatformProjectFinancialIndicatorsViewController.h"
#import "PlatformProjectRemarkViewController.h"


typedef enum PlatformProjectEditStaus: NSUInteger {
    PlatformProjectView,
    PlatformProjectEditing,
    PlatformProjectCreate
} PlatformProjectEditStaus;

@interface PlatformProjectViewController : BBCustomBackButtonViewController <UIAlertViewDelegate>
- (id)initWithPlatformProject: (NSDictionary *)platformProject;
@end
