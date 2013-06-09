//
//  ReceivablesViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "ReceivablesViewController.h"

@interface ReceivablesViewController ()

@end

@implementation ReceivablesViewController

- (void)addReceivalesAssertBacked
{
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
     [root fetchValueIntoObject:result];
    
    //应收账款对象
    result[@"应收账款对象"] = [NSMutableArray array];
    QSection *section = [root sectionWithKey:@"Receivables"];
    for (id el in section.elements) {
        if ([el isKindOfClass:[QEntryElement class]]) {
            NSString *textValue = ((QEntryElement *)el).textValue;
            if (textValue.length > 0)
                [(NSMutableArray *)result[@"应收账款对象"]   addObject: ((QEntryElement *)el).textValue];
        }
    }
    
    if (result.count > 0 && self.receivablesAddedCallback)
        self.receivablesAddedCallback(result);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"应收账款";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addReceivalesAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
