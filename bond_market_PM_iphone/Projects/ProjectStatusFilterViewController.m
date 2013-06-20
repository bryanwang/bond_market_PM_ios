//
//  ProjectStatusFilterViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-20.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectStatusFilterViewController.h"

@interface ProjectStatusFilterViewController ()

@end

@implementation ProjectStatusFilterViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"ProjectStatusFilterDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)filterProjects
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    QRootElement *root = self.qc.quickDialogTableView.root;
    [root fetchValueIntoObject:dic];
    //只返回 “query”字段 如果"query: 为空 则默认为 按“全部”筛选
    NSDictionary* info = [NSDictionary dictionaryWithObject:dic[@"query"] forKey: BYPROJECTSTATUSFILTERQUERY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPROJECTFILTERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"完成" target:self selector:@selector(filterProjects)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setUpSeletedRole
{
    QRootElement *root = self.qc.quickDialogTableView.root;
    QSelectSection *allsection = (QSelectSection *)[root getSectionForIndex:0];
    QSelectSection *querysection = (QSelectSection *)[root getSectionForIndex:1];
    __block ProjectStatusFilterViewController *_self = self;
    
    [[QuickDialogHelper sharedInstance]setUpSelectRoleWithAllSelecte:allsection AndQuerySelect:querysection WithChangedCallback:^{
        [_self.qc.quickDialogTableView reloadData];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"按状态筛选";
    
    [self setUpLeftNavigationButton];
    [self setUpSeletedRole];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
