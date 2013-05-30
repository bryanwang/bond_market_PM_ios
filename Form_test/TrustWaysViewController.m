//
//  TrustWaysViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "TrustWaysViewController.h"
#import "AssertsTypesViewController.h"
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


- (void)showAssertsTypes:(QElement *)element{
    QRootElement *root = [AssertsTypesDataBuilder create];
    AssertsTypesViewController *ac = [[AssertsTypesViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:ac forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showGuaranteeTypes:(QElement *)element{
    QRootElement *root = [GuaranteeDataBuilder create];
    GuaranteeViewController *gc = [[GuaranteeViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:gc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showEnhancementsWays:(QElement *)element{
    QRootElement *root = [EnhancementsDataBuilder create];
    EnhancementsViewController *ec = [[EnhancementsViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:ec forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showBankSupportWays:(QElement *)element{
    QRootElement *root = [BankSupportDataBuilder create];
    BankSupportViewController *bc = [[BankSupportViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:bc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];}

- (void)showOtherTrustWays:(QElement *)element{
    OtherTrustWaysViewController *oc = [[OtherTrustWaysViewController alloc]initWithNibName:@"OtherTrustWaysViewController" bundle:nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:oc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}



@end
