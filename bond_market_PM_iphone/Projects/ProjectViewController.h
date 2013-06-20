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


typedef enum ProjectType: NSUInteger {
    Bond,
    Project,
    PlatformProject,
} ProjectType;

@interface ProjectViewController : BBCustomBackButtonViewController <UIAlertViewDelegate>

- (id)initWithProject: (NSDictionary *)project;
- (id)initWithProjectCreateType: (ProjectType *)projectType;
@end
