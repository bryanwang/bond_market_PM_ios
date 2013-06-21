//
//  MyProjectsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "MyProjectsViewController.h"
#import <AKSegmentedControl.h>
#import "ProjectsTableViewController.h"
#import "ProjectFilterViewController.h"

@interface MyProjectsViewController ()
@property (strong, nonatomic)ProjectsTableViewController *tableviewController;
@property (strong, nonatomic)ProjectFilterViewController *filterViewController;
@property (strong, nonatomic)AKSegmentedControl *segmentedControl;
@end

@implementation MyProjectsViewController

- (ProjectFilterViewController *)filterViewController
{
    if (_filterViewController == nil) {
        _filterViewController = [[ProjectFilterViewController alloc] init];
    }
    
    return _filterViewController;
}

- (ProjectsTableViewController *)tableviewController
{
    if (_tableviewController == nil) {
        _tableviewController = [[ProjectsTableViewController  alloc]init];
        _tableviewController.delegate = self;
    }
    
    return _tableviewController;
}


- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self.tableviewController orderBy:(ProjectsOrderType)index];
}

- (void)setUpSegmentedControll
{
    NSArray *titles = @[@"从新到旧", @"从旧到新", @"按牵头人"];
    SEL action = @selector(segmentedControlValueChanged:);
    self.segmentedControl = [[QuickDialogHelper sharedInstance]
                             setUpSegmentedControllWithTitles:titles
                             WithSelectedChangedAcion:action
                             WithTarget:self];
    [self.view addSubview:self.segmentedControl];
}



- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"筛选" target:self selector:@selector(filterButtonTapped)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)filterButtonTapped
{
    [self.navigationController pushViewController:self.filterViewController animated:YES];
}

- (void)fetchMyProjects
{
    UIView *view = self.tableviewController.view;
    CGRect rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    view.frame = rect;
    [self.view addSubview:view];
    
    [self.tableviewController fetchMyProjects];
    [self.tableviewController fetchMyInputInfo];
}


- (void)filterProjectsByNotification:  (NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    
    NSDictionary *info = notification.userInfo;
    id typequery = [info objectForKey:BYPROJECTTYPEFILTERQUERY];
    id statusquery = [info objectForKey:BYPROJECTSTATUSFILTERQUERY];
    
    [self.tableviewController filterByStatus:statusquery AndType:typequery];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目查看";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterProjectsByNotification:) name:BYPROJECTFILTERNOTIFICATION object:nil];
    
    [self setUpLeftNavigationButton];
    [self setUpSegmentedControll];
    
    [self fetchMyProjects];
    
    [self.segmentedControl setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYPROJECTFILTERNOTIFICATION object:nil];
}

@end
