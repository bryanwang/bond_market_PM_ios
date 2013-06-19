//
//  BondRemarkViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondRemarkViewController.h"
#import "UIPlaceHolderTextView.h"

@interface BondRemarkViewController ()
@property (strong, nonatomic) UIPlaceHolderTextView *textview;
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
    self.textview = [[UIPlaceHolderTextView alloc]initWithFrame:(CGRect){{10.0f, 10.0f}, {self.view.bounds.size.width - 20.0f, 120.0f}}];
    self.textview.placeholder = @"请输入备注..";
    self.textview.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.textview];
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
