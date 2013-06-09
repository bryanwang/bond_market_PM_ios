//
//  EstateViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "EstateViewController.h"

@interface EstateViewController ()

@end

@implementation EstateViewController


- (void)addEstateAssertBacked
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"房产";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addEstateAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
