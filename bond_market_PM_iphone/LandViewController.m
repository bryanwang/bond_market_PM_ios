//
//  LandViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "LandViewController.h"

@interface LandViewController ()

@end

@implementation LandViewController

- (void)addLandAssertBacked
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"土地";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addLandAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)xx
{
    NSLog(@"xx");
}
@end
