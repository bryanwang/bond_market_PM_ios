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
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 房产", @"data": [@[] mutableCopy]} mutableCopy];

    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //性质  & 土地出让证明
    NSMutableArray *kinds = [@[
                             @"商业",
                             @"住宅"
                             ] mutableCopy];
    NSMutableArray *cards = [@[
                             @"有",
                             @"无",
                             @"",
                             ] mutableCopy];

    NSMutableArray *a = [NSMutableArray array];
    [(NSArray *)dic[@"性质"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [a addObject: kinds[[obj integerValue]]];
    }];
    
    if (dic[@"其他性质"])
        [a addObject: dic[@"其他性质"]];
    
    if (a.count > 0)
        [result[@"data"] addObject: @{@"key": @"性质", @"value": a}];

    if (dic[@"土地出让证明"])
        [result[@"data"] addObject: @{@"key": @"土地出让证明", @"value": cards[[dic[@"土地出让证明"] integerValue]]}];
   
    if (dic[@"土地面积"])
        [result[@"data"] addObject: @{@"key": @"土地面积", @"value": dic[@"土地面积"]}];
    
    if (dic[@"转让价值"])
        [result[@"data"] addObject: @{@"key": @"转让价值", @"value": dic[@"转让价值"]}];
    
    if (dic[@"覆盖倍数"])
         [result[@"data"] addObject: @{@"key": @"覆盖倍数", @"value": dic[@"覆盖倍数"]}];

    if (dic.count > 0 && self.landAddedCallback) {
        self.landAddedCallback(result);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"土地";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addLandAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)xx
{
    NSLog(@"xx");
}
@end
