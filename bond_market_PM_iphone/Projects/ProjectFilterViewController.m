//
//  ProjectFilterViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-20.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectFilterViewController.h"
#import "ProjectTypeFilterViewController.h"
#import "ProjectStatusFilterViewController.h"

@interface ProjectFilterViewController () <BYBaseQuickDialogDelegate>
@property (nonatomic, strong) ProjectTypeFilterViewController *projectTypeFilterViewController;
@property (nonatomic, strong) ProjectStatusFilterViewController *projectStatusFilterViewController;
@end

@implementation ProjectFilterViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"ProjectFilterDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
        self.qc.delegate = self;
    }
    
    return self;
}

- (ProjectTypeFilterViewController *)projectTypeFilterViewController
{
    if (_projectTypeFilterViewController == nil) {
        _projectTypeFilterViewController = [[ProjectTypeFilterViewController alloc]init];
    }
    
    return _projectTypeFilterViewController;
}

- (ProjectStatusFilterViewController *)projectStatusFilterViewController
{
    if (_projectStatusFilterViewController == nil) {
        _projectStatusFilterViewController = [[ProjectStatusFilterViewController alloc] init];
    }
    
    return _projectStatusFilterViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目筛选";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma quick dialog delegate
- (void)filterProjectByStatus
{
    [self.navigationController pushViewController:self.projectStatusFilterViewController animated:YES];
}

- (void)filterProjectByType
{
    [self.navigationController pushViewController:self.projectTypeFilterViewController animated:YES];
}

@end
