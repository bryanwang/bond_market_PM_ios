//
//  ProjectsTableViewController
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PlatformProjectsOrderType: NSUInteger
{
    OrderByTime,
    OrderByTimeDesc,
    OrderByChargePerson
} PlatformProjectsOrderType;


@interface PlatformProjectsTableViewController : UITableViewController

@property (strong, nonatomic) id delegate;

- (void) reloadTableview;
- (void) fetchMyPlatformProjects;
- (void) fetchMyInputInfo;

- (void)orderBy:(PlatformProjectsOrderType)orderType;
- (void)filterBy: (NSArray *)query;

@end
