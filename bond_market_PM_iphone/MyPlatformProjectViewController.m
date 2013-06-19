//
//  MyPlatformProjectViewController.m
//  bond_market_PM_iphone
//
//  Created by YANG Yuxin on 13-6-19.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "MyPlatformProjectViewController.h"
#import "PlatformProjectsTableViewController.h"
#import "BondFilterViewController.h"
#import <AKSegmentedControl.h>

@interface MyPlatformProjectViewController ()
@property (strong, nonatomic)PlatformProjectsTableViewController *tableviewController;
@property (strong, nonatomic)BondFilterViewController *filterViewController;
@property (strong, nonatomic)AKSegmentedControl *segmentedControl;
@end

@implementation MyPlatformProjectViewController

- (BondFilterViewController *)filterViewController
{
    if (_filterViewController == nil) {
        _filterViewController = [[BondFilterViewController alloc] init];
        
        __block MyPlatformProjectViewController *delegate = self;
        _filterViewController.filterCallback = ^ (id filter) {
            [delegate.tableviewController filterBy:(NSArray *)filter];
        };
        
    }
    
    return _filterViewController;
}

- (PlatformProjectsTableViewController *)tableviewController
{
    if (_tableviewController == nil) {
        _tableviewController = [[PlatformProjectsTableViewController  alloc]init];
        _tableviewController.delegate = self;
    }
    
    return _tableviewController;
}


- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self.tableviewController orderBy:(PlatformProjectsOrderType)index];
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
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"筛选" target:self selector:@selector(filterMyProjects)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)filterMyProjects
{
    [self.navigationController pushViewController:self.filterViewController animated:YES];
}

- (void)fetchMyBonds
{
    UIView *view = self.tableviewController.view;
    CGRect rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    view.frame = rect;
    [self.view addSubview:view];
    
    [self.tableviewController fetchMyPlatformProjects];
    [self.tableviewController fetchMyInputInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"平台项目";
    
    [self setUpLeftNavigationButton];
    [self setUpSegmentedControll];
    
    [self fetchMyBonds];
    
    [self.segmentedControl setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
