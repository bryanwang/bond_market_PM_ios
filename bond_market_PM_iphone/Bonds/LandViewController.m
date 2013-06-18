//
//  LandViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "LandViewController.h"

@interface LandViewController ()

@end

@implementation LandViewController

- (void)addLandAssertBacked
{
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 土地", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
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
    
    //土地出让证明
    if (dic[@"土地出让证明"])
        [result[@"data"] addObject: @{@"key": @"土地出让证明", @"value": cards[[dic[@"土地出让证明"] integerValue]]}];
   
    if (dic[@"土地面积"])
        [result[@"data"] addObject: @{@"key": @"土地面积", @"value": dic[@"土地面积"]}];
    
    if (dic[@"转让价值"])
        [result[@"data"] addObject: @{@"key": @"转让价值", @"value": dic[@"转让价值"]}];
    
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
    self.title = @"土地";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addLandAssertBacked)];
    
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"LandTypesDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
