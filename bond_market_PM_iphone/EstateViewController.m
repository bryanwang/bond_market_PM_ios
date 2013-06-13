//
//  EstateViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "EstateViewController.h"

@interface EstateViewController ()

@end

@implementation EstateViewController


- (void)addEstateAssertBacked
{
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 房产", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if (dic.count == 0) return;
    
    NSMutableArray *kinds = [@[
                             @"商业",
                             @"住宅"
                             ] mutableCopy];
    NSMutableArray *cards = [@[
                             @"有",
                             @"无",
                             @"",
                             ] mutableCopy];
    
    //性质
    NSMutableArray *a = [NSMutableArray array];
    [(NSArray *)dic[@"性质"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [a addObject: kinds[[obj integerValue]]];
    }];
    if (dic[@"其他性质"])
        [a addObject: dic[@"其他性质"]];
    if (a.count > 0)
        [result[@"data"] addObject: @{@"key": @"性质", @"value": a}];
    
    //房产证
    if (dic[@"房产证"])
        [result[@"data"] addObject: @{@"key": @"房产证", @"value": cards[[dic[@"房产证"] integerValue]]}];
    
    if (dic[@"评估价值"])
        [result[@"data"] addObject: @{@"key": @"评估价值", @"value": dic[@"评估价值"]}];
    
    if (dic[@"覆盖倍数"])
        [result[@"data"] addObject: @{@"key": @"覆盖倍数", @"value": dic[@"覆盖倍数"]}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"房产";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addEstateAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
