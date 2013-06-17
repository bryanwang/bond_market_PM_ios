//
//  EquityInvestmentProjectsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "EquityInvestmentProjectsViewController.h"

@interface EquityInvestmentProjectsViewController ()

@end

@implementation EquityInvestmentProjectsViewController

- (void)doneBtnTapped
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"募投项目";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EquityInvestmentProjectsDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

@end
