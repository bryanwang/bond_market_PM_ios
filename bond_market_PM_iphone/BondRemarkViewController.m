//
//  BondRemarkViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondRemarkViewController.h"
#import "HDTextView.h"

@interface BondRemarkViewController ()
@property (weak, nonatomic) IBOutlet HDTextView *textview;

@end

@implementation BondRemarkViewController

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
