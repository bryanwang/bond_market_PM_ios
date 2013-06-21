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

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EquityInvestmentProjectsDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

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
    QSelectSection *s = (QSelectSection *)[root sectionWithKey:@"批文"];
    NSMutableArray *items = [s.selectedItems mutableCopy];
    if (dic[@"其他批文"])
        [items addObject: dic[@"其他批文"]];
    if (items.count > 0)
        [result[@"data"] addObject: @{@"key": @"批文", @"value": items}];

    
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
}

@end
