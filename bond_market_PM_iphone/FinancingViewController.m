//
//  FinancingViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "FinancingViewController.h"

@interface FinancingViewController ()

@end

@implementation FinancingViewController

- (void)setUpSeletedRole
{
    QRootElement *root = self.qc.quickDialogTableView.root;
    __weak QSelectSection *allsection = (QSelectSection *)[root getSectionForIndex:0];
    __weak QSelectSection *querysection = (QSelectSection *)[root getSectionForIndex:1];
    allsection.onSelected = ^{
        NSMutableArray *items = [NSMutableArray array];
        if (allsection.selectedIndexes.count == allsection.items.count) {
            for (QElement *el in querysection.elements) {
                [items addObject: [NSNumber numberWithInt:((QSelectItemElement *)el).index]];
            }
            querysection.selectedIndexes = items;
        } else {
            [querysection setSelectedIndexes:items];
        }
        
        [self.qc.quickDialogTableView reloadData];
    };
    
    querysection.onSelected = ^{
        if (querysection.selectedIndexes.count > 0 && querysection.selectedIndexes.count != allsection.items.count) {
            [allsection setSelectedIndexes:[NSMutableArray array]];
        }
        
        [self.qc.quickDialogTableView reloadData];
    };
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"融资方式";
    QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"FinancingDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
    [self setUpSeletedRole];
}

@end
