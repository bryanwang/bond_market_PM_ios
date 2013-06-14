//
//  AddTrustIncreaseViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "AddTrustIncreaseViewController.h"
#import "LandViewController.h"
#import "EstateViewController.h"
#import "EquityViewController.h"
#import "ReceivablesViewController.h"
#import "OtherTrustIncreaseViewController.h"
#import "GuaranteeViewController.h"
#import "EnhancementsViewController.h"
#import "BankSupportViewController.h"
#import "OtherTrustIncreaseViewController.h"

@interface AddTrustIncreaseViewController ()

@end

@implementation AddTrustIncreaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建增信方式";
    
    QRootElement *root =  [[QRootElement alloc] initWithJSONFile:@"TrutWaysDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma base quick dialog delegate
- (void)showLandTypes
{
    LandViewController *lc = [[LandViewController alloc] init];
    [self.navigationController pushViewController:lc animated:YES];
}

- (void)showEstateTypes
{
    EstateViewController *ec = [[EstateViewController alloc] init];
    [self.navigationController pushViewController:ec animated:YES];
}

- (void)showEquityTypes
{
    EquityViewController *ec = [[EquityViewController alloc] init];
    [self.navigationController pushViewController:ec animated:YES];
}

- (void)showReceivablesTypes
{
    ReceivablesViewController *rc = [[ReceivablesViewController alloc] init];
    [self.navigationController pushViewController:rc animated:YES];
}

- (void)showGuaranteeTypes
{
    GuaranteeViewController *gc = [[GuaranteeViewController alloc] init];
   [self.navigationController pushViewController:gc animated:YES];
}

- (void)showEnhancementsWays
{
    EnhancementsViewController *ec = [[EnhancementsViewController alloc] init];
    [self.navigationController pushViewController:ec animated:YES];
}

- (void)showBankSupportWays
{
    BankSupportViewController *bc = [[BankSupportViewController alloc] init];
    [self.navigationController pushViewController:bc animated:YES];
}

- (void)showOtherTrustWays
{
    OtherTrustIncreaseViewController *oc = [[OtherTrustIncreaseViewController alloc]init];
  [self.navigationController pushViewController:oc animated:YES];
}

@end
