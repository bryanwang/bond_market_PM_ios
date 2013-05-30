//
//  ViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondBasicInfoViewController.h"
#import "TrustWaysViewController.h"

@interface BondBasicInfoViewController ()

@end

@implementation BondBasicInfoViewController

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

- (void)showTrustWays:(QElement *)element{
    QRootElement *root = [TrutWaysDataBuilder create];
    TrustWaysViewController *tc = [[TrustWaysViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:tc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

@end
