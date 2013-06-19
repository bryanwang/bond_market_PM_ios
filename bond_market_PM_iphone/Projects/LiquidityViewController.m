//
//  LiquidityViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "LiquidityViewController.h"

@interface LiquidityViewController ()

@end

@implementation LiquidityViewController

- (void)doneBtnTapped
{
    NSMutableDictionary *result = [@{@"type": @"补充流动资金", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if([(NSArray *)dic[@"补充流动资金"] count] == 0) return;

    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"补充流动资金";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"LiquidityDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

@end
