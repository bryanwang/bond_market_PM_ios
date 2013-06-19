//
//  FinancingMethodViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "FinancingMethodViewController.h"

@interface FinancingMethodViewController ()

@end

@implementation FinancingMethodViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"FinancingDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)setStatus:(FinancingMethodEditStatus)status
{
    _status = status;
    QRootElement *root = self.qc.quickDialogTableView.root;
    
    if (status == FinancingMethodEditing) {
        for(QSection *section in root.sections)
        {
            for(QElement *element in section.elements)
            {
                element.enabled = YES;
            }
        }
    } else {
        for(QSection *section in root.sections)
        {
            for(QElement *element in section.elements)
            {
                    element.enabled = NO;
            }
        }
    }
    
    [self.qc.quickDialogTableView reloadData];
}


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
        [(NSArray *)financing enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {
            NSUInteger index = [kinds indexOfObject:obj];
            if (index != NSNotFound)
                [items addObject: [NSNumber numberWithInt:index]];
        }];
        
        NSLog(@"%@", items);
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
    [self setUpSeletedRole];
}

@end
