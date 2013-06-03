//
//  TrustWaysViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "TrustWaysViewController.h"
//#import "AssertsTypesViewController.h"
#import "LandViewController.h"
#import "EstateViewController.h"
#import "EquityViewController.h"
#import "ReceivablesViewController.h"
#import "OtherTrustWaysViewController.h"
#import "GuaranteeViewController.h"
#import "EnhancementsViewController.h"
#import "BankSupportViewController.h"
#import "OtherTrustWaysViewController.h"

@interface TrustWaysViewController ()

@end

@implementation TrustWaysViewController

- (void)displayViewControllerForRoot:(QRootElement *)element {
    QuickDialogController *newController = [QuickDialogController controllerForRoot:element];
    [super displayViewController:newController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//- (void)showAssertsTypes:(QElement *)element{
//    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"AssertsTypesDataBuilder" andData:nil];
//    AssertsTypesViewController *ac = [[AssertsTypesViewController alloc]initWithRoot:root];
//    NSDictionary* dict = [NSDictionary dictionaryWithObject:ac forKey:BYCONTROLLERKEY];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
//                                                        object:self
//                                                      userInfo:dict];
//}

- (void)postNotificatioWithUserInfoController: (UIViewController *)vc
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:vc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showLandTypes:(QElement *)element
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"LandTypesDataBuilder" andData:nil];
    LandViewController *lc = [[LandViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:lc];
}

- (void)showEstateTypes:(QElement *)element
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"EstateTypesDataBuilder" andData:nil];
    EstateViewController *ec = [[EstateViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showEquityTypes:(QElement *)element
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"EquityDataBuilder" andData:nil];
    EquityViewController *ec = [[EquityViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showReceivablesTypes:(QElement *)element
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ReceivablesDataBuilder" andData:nil];
    ReceivablesViewController *rc = [[ReceivablesViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:rc];
}


- (void)showGuaranteeTypes:(QElement *)element{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"GuaranteeDataBuilder" andData:nil];
    GuaranteeViewController *gc = [[GuaranteeViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:gc];
}

- (void)showEnhancementsWays:(QElement *)element{
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"EnhancementsDataBuilder" andData:nil];
    EnhancementsViewController *ec = [[EnhancementsViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:ec];
}

- (void)showBankSupportWays:(QElement *)element{
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"BankSupportDataBuilder" andData:nil];
    BankSupportViewController *bc = [[BankSupportViewController alloc]initWithRoot:root];
    [self postNotificatioWithUserInfoController:bc];
}

- (void)showOtherTrustWays:(QElement *)element{
    OtherTrustWaysViewController *oc = [[OtherTrustWaysViewController alloc]initWithNibName:@"OtherTrustWaysViewController" bundle:nil];
    [self postNotificatioWithUserInfoController:oc];
}



@end
