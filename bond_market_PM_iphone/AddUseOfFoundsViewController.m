//
//  AddUseOfFoundsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "AddUseOfFoundsViewController.h"
#import "AddLiquidityViewController.h"
#import "DebtRestructuringViewController.h"
#import "EquityInvestmentProjectsViewController.h"
#import "OtherPurposesViewController.h"

@interface AddUseOfFoundsViewController ()

@end

@implementation AddUseOfFoundsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建资金用途";
    
    QRootElement *root =  [[QRootElement alloc] initWithJSONFile:@"UseOfFoundsDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma base quick dialog delegate
- (void)AddLiquidity
{
    AddLiquidityViewController *ac = [[AddLiquidityViewController alloc] init];
    [self.navigationController pushViewController:ac animated:YES];
}

- (void)DebtRestructuring
{
    DebtRestructuringViewController *dc = [[DebtRestructuringViewController alloc] init];
    [self.navigationController pushViewController:dc animated:YES];
}

- (void)EquityInvestmentProjects
{
    EquityInvestmentProjectsViewController *ec = [[EquityInvestmentProjectsViewController alloc] init];
    [self.navigationController pushViewController:ec animated:YES];
}

- (void)OtherPurposes
{
    OtherPurposesViewController *oc = [[OtherPurposesViewController alloc] init];
    [self.navigationController pushViewController:oc animated:YES];
}

@end
