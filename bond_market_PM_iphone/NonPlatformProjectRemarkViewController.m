//
//  NonPlatformProjectRemarkViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "NonPlatformProjectRemarkViewController.h"
#import "UIPlaceHolderTextView.h"

@interface NonPlatformProjectRemarkViewController ()
@property (strong, nonatomic) UIPlaceHolderTextView *textview;
@end

@implementation NonPlatformProjectRemarkViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

@end
