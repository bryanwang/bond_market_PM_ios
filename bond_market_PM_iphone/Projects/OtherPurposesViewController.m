//
//  OtherPurposesViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "OtherPurposesViewController.h"
#import "UIPlaceHolderTextView.h"

@interface OtherPurposesViewController ()
@property (nonatomic, strong)UIPlaceHolderTextView *textview;
@end

@implementation OtherPurposesViewController

- (void)doneBtnTapped
{
    NSMutableDictionary *result = [
                                   @{@"type": @"其它资金用途",
                                   @"data": @[@{@"key": @"其他", @"value": self.textview.text}]}
                                   mutableCopy];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"其他增信方式";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    self.textview = [[UIPlaceHolderTextView alloc]initWithFrame:(CGRect){{10.0f, 10.0f}, {self.view.bounds.size.width - 20.0f, 120.0f}}];
    self.textview.placeholder = @"其他...";
    [self.view addSubview:self.textview];
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
