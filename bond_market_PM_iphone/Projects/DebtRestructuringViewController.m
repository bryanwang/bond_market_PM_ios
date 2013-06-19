//
//  DebtRestructuringViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "DebtRestructuringViewController.h"

@interface DebtRestructuringViewController ()

@end

@implementation DebtRestructuringViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"DebtRestructuringDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)doneBtnTapped
{
    NSMutableDictionary *result = [@{@"type": @"调整债务结构", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if (dic[@"偿还银行借款"])
        [result[@"data"] addObject: @{@"key": @"偿还银行借款", @"value": dic[@"偿还银行借款"]}];

    if (dic[@"评估价值"])
        [result[@"data"] addObject: @{@"key": @"调整债务结构其他", @"value": dic[@"调整债务结构其他"]}];

    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"调整债务结构";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(doneBtnTapped)];
}


@end
