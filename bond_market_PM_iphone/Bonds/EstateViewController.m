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

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EstateTypesDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)addEstateAssertBacked
{
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 房产", @"data": [@[] mutableCopy]} mutableCopy];
    
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
    
    //房产证
    if (dic[@"房产证"])
        [result[@"data"] addObject: @{@"key": @"房产证", @"value": dic[@"房产证"]}];
    
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
