//
//  MyBondsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "MyBondsViewController.h"
#import "BondsTableViewController.h"
#import <AKSegmentedControl.h>

@interface MyBondsViewController ()
@property (strong, nonatomic)AKSegmentedControl *segmentedControl;
@property (strong, nonatomic)BondsTableViewController *tableviewController;
@end

@implementation MyBondsViewController


- (BondsTableViewController *)tableviewController
{
    if (_tableviewController == nil) {
        _tableviewController = [[BondsTableViewController alloc]init];
    }
    
    return _tableviewController;
}

- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self.tableviewController setOrderType:index];
    [self.tableviewController reloadTableview];
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

- (void)filterMyBonds
{
    
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"] highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"] target:self selector:@selector(filterMyBonds)];
    ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)(item.customView)) setTitle:@"筛选" forState:UIControlStateNormal];
    [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
    
    self.navigationItem.rightBarButtonItem = item;
}


- (void)fetchMyBonds
{
    UIView *view = self.tableviewController.view;
    CGRect rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    view.frame = rect;
    [self.view addSubview:view];
    
    [self.tableviewController fetchMyBonds];
    [self.tableviewController fetchMyInputInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的新债";
    [self setUpSegmentedControll];
    [self setUpLeftNavigationButton];
    [self fetchMyBonds];
    
    [self.segmentedControl setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
