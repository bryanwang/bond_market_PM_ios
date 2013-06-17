//
//  AddLiquidityViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "AddLiquidityViewController.h"

@interface AddLiquidityViewController ()

@end

@implementation AddLiquidityViewController

- (void)doneBtnTapped
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"补充流动资金";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"AddLiquidityDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

@end
