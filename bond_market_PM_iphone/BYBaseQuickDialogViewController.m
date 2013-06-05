//
//  BYBaseQuickDialogViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BYBaseQuickDialogViewController.h"
#import "BBCustomBackButtonViewController.h"
#import "LandViewController.h"
#import "EstateViewController.h"
#import "EquityViewController.h"
#import "ReceivablesViewController.h"
#import "OtherTrustWaysViewController.h"
#import "GuaranteeViewController.h"
#import "EnhancementsViewController.h"
#import "BankSupportViewController.h"
#import "OtherTrustWaysViewController.h"


@interface BYBaseQuickDialogViewController ()

@end

@implementation BYBaseQuickDialogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *bv = [[UIView alloc]initWithFrame:self.view.bounds];
    bv.backgroundColor = RGBCOLOR(224, 221, 215);
    self.quickDialogTableView.backgroundView =bv;
}

- (void)displayViewControllerForRoot:(QRootElement *)element {
    QuickDialogController *newController = [QuickDialogController controllerForRoot:element];
    [super displayViewController:newController];
}



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


- (void)handleEquityAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root getSectionForIndex:0];
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"股权所有人"];
    [section insertElement:e1 atIndex: section.elements.count - 1];
    [self.quickDialogTableView reloadData];
}

- (void)handleGuaranteeAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root getSectionForIndex:0];
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"担保方"];
    [section insertElement:e1 atIndex: section.elements.count - 1];
    [self.quickDialogTableView reloadData];
}

- (void)handleReceivablesAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root getSectionForIndex:0];
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"应收账款对象"];
    [section insertElement:e1 atIndex: section.elements.count - 1];
    [self.quickDialogTableView reloadData];
}


@end