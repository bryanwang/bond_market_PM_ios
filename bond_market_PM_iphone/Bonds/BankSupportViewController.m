//
//  BankSupportViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BankSupportViewController.h"

@interface BankSupportViewController ()

@end

@implementation BankSupportViewController

- (void)addBankSupport
{
    NSMutableDictionary *result = [@{@"type": @"银行流动性支持", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if (dic.count == 0) return;
    
    if(dic[@"银行名称"])
        [result[@"data"] addObject: @{@"key": @"银行名称", @"value": dic[@"银行名称"]}];
    
    if (dic[@"银行其他"])
        [result[@"data"] addObject: @{@"key": @"其他", @"value": dic[@"银行其他"]}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"银行流动性增强";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addBankSupport)];
    
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"BankSupportDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
