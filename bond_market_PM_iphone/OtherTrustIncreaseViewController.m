//
//  OtherTrustIncreaseViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "OtherTrustIncreaseViewController.h"
#import "HDTextView.h"

@interface OtherTrustIncreaseViewController ()
@property (weak, nonatomic) IBOutlet HDTextView *textview;
@end

@implementation OtherTrustIncreaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textview.placeholder = @"其他...";
    self.title = @"其他增信方式";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textview becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
