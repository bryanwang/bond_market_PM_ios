//
//  ProjectViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ProjectEditStaus: NSUInteger {
    ProjectView,
    ProjectEditing,
    ProjectCreate
} ProjectEditStaus;

@interface ProjectViewController : BBCustomBackButtonViewController <UIAlertViewDelegate>

- (id)initWithProject: (NSDictionary *)project;

@end
