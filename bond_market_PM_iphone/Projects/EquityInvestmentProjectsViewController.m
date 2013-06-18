//
//  EquityInvestmentProjectsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "EquityInvestmentProjectsViewController.h"

@interface EquityInvestmentProjectsViewController ()

@end

@implementation EquityInvestmentProjectsViewController

- (void)doneBtnTapped
{
    NSMutableDictionary *result = [@{@"type": @"募投项目", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if (dic[@"项目名称"])
        [result[@"data"] addObject: @{@"key": @"项目名称", @"value": dic[@"项目名称"]}];
    
    if (dic[@"投资总金额"])
        [result[@"data"] addObject: @{@"key": @"投资总金额", @"value": dic[@"投资总金额"]}];
    
    if (dic[@"项目性质"])
        [result[@"data"] addObject: @{@"key": @"项目性质", @"value": dic[@"项目性质"]}];
    
    if (dic[@"项目性质"])
        [result[@"data"] addObject: @{@"key": @"项目性质", @"value": dic[@"项目性质"]}];
    
    if (dic[@"项目简介"])
        [result[@"data"] addObject: @{@"key": @"项目简介", @"value": dic[@"项目简介"]}];
    
    //批文
    NSArray *kinds =[Utils sharedInstance].ApprovalTypes;
    NSMutableArray *a = [NSMutableArray array];
    [(NSArray *)dic[@"批文"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [a addObject: kinds[[obj integerValue]]];
    }];
    if (dic[@"其他批文"])
        [a addObject: dic[@"其他批文"]];
    if (a.count > 0)
        [result[@"data"] addObject: @{@"key": @"批文", @"value": a}];

    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"募投项目";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
    
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EquityInvestmentProjectsDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

@end
