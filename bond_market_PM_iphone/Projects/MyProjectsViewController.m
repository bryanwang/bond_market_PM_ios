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
    CGRect aRect = CGRectMake(0.0f, 0.0f, APP_SCREEN_WIDTH, 44.0f);
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:aRect];
    //    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"sort-bar"];
    [segmentedControl setBackgroundImage:backgroundImage];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"sort-bar-01-sel"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"sort-bar-01-sel"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"sort-bar-01-sel"];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"从新到旧" forState:UIControlStateNormal];
    btn1.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn1 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn1 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn1 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn2 = [[UIButton alloc] init];
    btn2.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn2 setTitle:@"从旧到新" forState:UIControlStateNormal];
    [btn2 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn2 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn2 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn3 = [[UIButton alloc] init];
    btn3.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn3 setTitle:@"按牵头人" forState:UIControlStateNormal];
    [btn3 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn3 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn3 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [segmentedControl setButtonsArray:@[btn1, btn2, btn3]];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    [self.view addSubview:segmentedControl];
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
