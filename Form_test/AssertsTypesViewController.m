//
//  AssertsTypesViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "AssertsTypesViewController.h"
#import "LandViewController.h"
#import "EstateViewController.h"
#import "EquityViewController.h"
#import "ReceivablesViewController.h"
#import "OtherTrustWaysViewController.h"

@interface AssertsTypesViewController ()

@end

@implementation AssertsTypesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLandTypes:(QElement *)element{
    QRootElement *root = [LandTypesDataBuilder create];
    LandViewController *lc = [[LandViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:lc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showEstateTypes:(QElement *)element{
    QRootElement *root = [EstateTypesDataBuilder create];
    EstateViewController *ec = [[EstateViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:ec forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showEquityTypes:(QElement *)element{
    QRootElement *root = [EquityDataBuilder create];
    EquityViewController *ec = [[EquityViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:ec forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)showReceivablesTypes:(QElement *)element{
    QRootElement *root = [ReceivablesDataBuilder create];
    ReceivablesViewController *rc = [[ReceivablesViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:rc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}


@end
