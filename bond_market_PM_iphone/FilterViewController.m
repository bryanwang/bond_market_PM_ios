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
    self.filterCallback(dic[@"query"]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"完成" target:self selector:@selector(filterBonds)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setUpSeletedRole
{
    QRootElement *root = self.qc.quickDialogTableView.root;
    __weak QSelectSection *allsection = (QSelectSection *)[root getSectionForIndex:0];
    __weak QSelectSection *querysection = (QSelectSection *)[root getSectionForIndex:1];
    allsection.onSelected = ^{
        if (allsection.selectedIndexes.count == allsection.items.count) {
            [querysection setSelectedIndexes:[@[@0,@1,@2,@3,@4,@5] mutableCopy]];
            
        } else {
            [querysection setSelectedIndexes:[NSMutableArray array]];
        }
        
        [self.qc.quickDialogTableView reloadData];
    };
    
    querysection.onSelected = ^{
        if (querysection.selectedIndexes.count > 0 && querysection.selectedIndexes.count != allsection.items.count) {
            [allsection setSelectedIndexes:[NSMutableArray array]];
        }
        
        [self.qc.quickDialogTableView reloadData];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"按状态筛选";
    
    [self setUpSeletedRole];
    [self setUpLeftNavigationButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
