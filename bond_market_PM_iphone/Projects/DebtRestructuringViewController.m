//
//  DebtRestructuringViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "DebtRestructuringViewController.h"

@interface DebtRestructuringViewController ()

@end

@implementation DebtRestructuringViewController

- (void)doneBtnTapped
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"调整债务结构";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"DebtRestructuringDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}


@end
