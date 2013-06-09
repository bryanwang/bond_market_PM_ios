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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)postNotificatioWithUserInfoController: (UIViewController *)vc
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:vc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}


#pragma base quick dialog delegate
- (void)showLandTypes
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"LandTypesDataBuilder" andData:nil];
    LandViewController *lc = [[LandViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:lc];
}

- (void)showEstateTypes
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"EstateTypesDataBuilder" andData:nil];
    EstateViewController *ec = [[EstateViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showEquityTypes
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"EquityDataBuilder" andData:nil];
    EquityViewController *ec = [[EquityViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showReceivablesTypes
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ReceivablesDataBuilder" andData:nil];
    ReceivablesViewController *rc = [[ReceivablesViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:rc];
}

- (void)showGuaranteeTypes
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"GuaranteeDataBuilder" andData:nil];
    GuaranteeViewController *gc = [[GuaranteeViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:gc];
}

- (void)showEnhancementsWays
{
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"EnhancementsDataBuilder" andData:nil];
    EnhancementsViewController *ec = [[EnhancementsViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showBankSupportWays
{
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"BankSupportDataBuilder" andData:nil];
    BankSupportViewController *bc = [[BankSupportViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:bc];
}

- (void)showOtherTrustWays
{
    OtherTrustIncreaseViewController *oc = [[OtherTrustIncreaseViewController alloc]initWithNibName:@"OtherTrustWaysViewController" bundle:nil];
    [self postNotificatioWithUserInfoController:oc];
}

@end
