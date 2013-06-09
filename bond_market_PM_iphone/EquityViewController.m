//
//  EquityViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "EquityViewController.h"

@interface EquityViewController ()

@end

@implementation EquityViewController

- (void)addEquityAssertBacked
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"股权";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addEquityAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
