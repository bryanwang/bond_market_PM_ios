//
//  ProjectsTableViewController
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ProjectsOrderType: NSUInteger
{
    OrderByTime,
    OrderByTimeDesc,
    OrderByChargePerson
} ProjectsOrderType;


@interface ProjectsTableViewController : UITableViewController

@property (strong, nonatomic) id delegate;

- (void) reloadTableview;
- (void) fetchMyProjects;
- (void) fetchMyInputInfo;

- (void)orderBy:(ProjectsOrderType)orderType;
- (void)filterBy: (NSArray *)query;

@end
