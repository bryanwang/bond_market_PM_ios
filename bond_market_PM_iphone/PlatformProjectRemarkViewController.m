//
//  PlatformProjectRemarkViewController.m
//  bond_market_PM_iphone
//
//  Created by YANG Yuxin on 13-6-19.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "PlatformProjectRemarkViewController.h"
#import "UIPlaceHolderTextView.h"

@interface PlatformProjectRemarkViewController ()
@property (strong, nonatomic) UIPlaceHolderTextView *textview;
@end

@implementation PlatformProjectRemarkViewController

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

@end
