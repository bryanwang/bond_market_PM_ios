//
//  FilterViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-5.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)filterBonds
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    QRootElement *root = self.qc.quickDialogTableView.root;
    [root fetchValueIntoObject:dic];
    //只返回 “query”字段 如果"query: 为空 则默认为 按“全部”筛选
    if ([dic[@"all"] count] > 0) {
        dic[@"query"] = [NSDictionary dictionary];
    }
    self.filterCallback(dic[@"query"]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"] highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"] target:self selector:@selector(filterBonds)];
    ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)(item.customView)) setTitle:@"新增" forState:UIControlStateNormal];
    [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
    
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"按状态筛选";
    
    [self setUpLeftNavigationButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
