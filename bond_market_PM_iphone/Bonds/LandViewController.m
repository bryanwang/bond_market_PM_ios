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

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"LandTypesDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)addLandAssertBacked
{
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 土地", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //性质
    QSelectSection *s = (QSelectSection *)[root sectionWithKey:@"性质"];
    NSMutableArray *items = [s.selectedItems mutableCopy];
    if (dic[@"其他性质"])
        [items addObject: dic[@"其他性质"]];
    if (items.count > 0)
        [result[@"data"] addObject: @{@"key": @"性质", @"value": items}];
    
    //土地出让证明
    NSMutableArray *cards = [@[
                             @"有",
                             @"无",
                             @"",
                             ] mutableCopy];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
