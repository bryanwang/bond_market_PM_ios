//
//  OtherTrustIncreaseViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "OtherTrustIncreaseViewController.h"
#import "UIPlaceHolderTextView.h"

@interface OtherTrustIncreaseViewController ()
@property (nonatomic, strong)UIPlaceHolderTextView *textview;
@end

@implementation OtherTrustIncreaseViewController

- (void)addOtherTrustIncrease
{
    NSMutableDictionary *result = [
                                   @{@"type": @"其它增信方式",
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addOtherTrustIncrease)];
    
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
