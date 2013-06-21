//
//  MyBondsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "MyBondsViewController.h"
#import "BondsTableViewController.h"
#import "BondFilterViewController.h"
#import "define.h"
#import <AKSegmentedControl.h>

@interface MyBondsViewController ()
@property (strong, nonatomic)AKSegmentedControl *segmentedControl;
@property (strong, nonatomic)BondsTableViewController *tableviewController;
@property (strong, nonatomic) BondFilterViewController *filterViewController;
@end


@implementation MyBondsViewController

- (BondsTableViewController *)tableviewController
{
    if (_tableviewController == nil) {
        _tableviewController = [[BondsTableViewController alloc]init];
    }

    return _tableviewController;
}


- (BondFilterViewController *)filterViewController
{
    if (_filterViewController == nil) {
        _filterViewController = [[BondFilterViewController alloc] init];
        
        //刷选项选择后的callback
        __block MyBondsViewController *delegate = self;
        _filterViewController.filterCallback = ^ (id filter) {
            [delegate.tableviewController filterBy:(NSArray *)filter];
        };
    }
    
    return _filterViewController;
}


- (void)filterMyBonds
{
    [self.navigationController pushViewController:self.filterViewController animated:YES];
}

- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self.tableviewController orderBy:(BondsOrderType)index];
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
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"筛选" target:self selector:@selector(filterMyBonds)];
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
