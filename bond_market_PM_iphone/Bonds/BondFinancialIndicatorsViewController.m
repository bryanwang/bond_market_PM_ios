//
//  BondFinancialIndicatorsViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondFinancialIndicatorsViewController.h"

@interface BondFinancialIndicatorsViewController ()

@end

@implementation BondFinancialIndicatorsViewController


- (void)bindObject: (NSDictionary *)obj
{
    NSMutableDictionary *info = [obj copy];
    [self.quickDialogTableView.root bindToObject:info];
}

- (void)setElementsEnable
{
    for(QSection *section in self.quickDialogTableView.root.sections)
    {
        for(QElement *element in section.elements)
        {
            element.enabled = YES;
        }
    }
}

- (void)setElementsDisable
{
    for(QSection *section in self.quickDialogTableView.root.sections)
    {
        for(QElement *element in section.elements)
        {
            element.enabled = NO;
        }
    }
}

- (NSMutableDictionary *)fetchData
{
    NSMutableDictionary *financeIndex = [NSMutableDictionary dictionary];
    [self.root fetchValueUsingBindingsIntoObject:financeIndex];
    return financeIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
