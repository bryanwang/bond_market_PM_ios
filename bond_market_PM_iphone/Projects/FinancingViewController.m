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

- (void)bindObject:(id)financing
{
    QRootElement *root = self.qc.quickDialogTableView.root;
    QSelectSection *allsection = (QSelectSection *)[root getSectionForIndex:0];
    QSelectSection *querysection = (QSelectSection *)[root getSectionForIndex:1];

    if ([financing isEqual:@[@"全部"]]) {
        [allsection setSelectedIndexes:[@[@0] mutableCopy]];
    }
    else if ([financing isKindOfClass:[NSArray class]]) {
        NSArray *kinds = [Utils sharedInstance].FinancingArray;
        NSMutableArray *items = [NSMutableArray array];
        [financing enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSInteger index = [kinds indexOfObject:obj];
            if (index >= 0 && index != NSNotFound) {
                [items addObject: [NSNumber numberWithInt:index]];
            }
        }];
        
        [querysection setSelectedIndexes:items];
    }
}

- (id)fetchData
{
    QRootElement *root = self.qc.quickDialogTableView.root;
    QSelectSection *allsection = (QSelectSection *)[root getSectionForIndex:0];
    QSelectSection *querysection = (QSelectSection *)[root getSectionForIndex:1];
    
    if (allsection.selectedItems.count > 0) {
        return @[@"全部"];
    }else {
        return querysection.selectedItems? querysection.selectedItems : @[];
    }
}

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
