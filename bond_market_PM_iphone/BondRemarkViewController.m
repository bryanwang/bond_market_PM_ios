//
//  BondRemarkViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondRemarkViewController.h"

@interface BondRemarkViewController ()
@end

@implementation BondRemarkViewController

- (void)bindObject:(NSString *)remark
{
    self.textview.text = remark;
}

- (void)setElementsDisable
{
    self.textview.userInteractionEnabled = NO;
}

- (void)setElementsEnable
{
    self.textview.userInteractionEnabled = YES;
}

- (NSString *)fetchData
{
    return self.textview.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textview.placeholder = @"请输入备注..";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
