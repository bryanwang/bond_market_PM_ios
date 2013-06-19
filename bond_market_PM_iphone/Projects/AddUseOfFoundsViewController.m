//
//  AddUseOfFoundsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "AddUseOfFoundsViewController.h"
#import "LiquidityViewController.h"
#import "DebtRestructuringViewController.h"
#import "EquityInvestmentProjectsViewController.h"
#import "OtherPurposesViewController.h"

@interface AddUseOfFoundsViewController () <BYBaseQuickDialogDelegate>

@end

@implementation AddUseOfFoundsViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"UseOfFoundsDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
        self.qc.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建资金用途";
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma base quick dialog delegate
- (void)AddLiquidity
{
    LiquidityViewController *ac = [[LiquidityViewController alloc] init];
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
