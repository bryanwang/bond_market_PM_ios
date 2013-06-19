//
//  GuaranteeViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "GuaranteeViewController.h"

@interface GuaranteeViewController ()

@end

@implementation GuaranteeViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"GuaranteeDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)addGuarantee
{
    NSMutableDictionary *result = [@{@"type": @"保证担保", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //性质
    NSArray *kinds =[Utils sharedInstance].SecurityWays;
    NSMutableArray *a = [NSMutableArray array];
    [(NSArray *)dic[@"担保方式"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [a addObject: kinds[[obj integerValue]]];
    }];
    if (dic[@"其他担保方式"])
        [a addObject: dic[@"其他担保方式"]];
    if (a.count > 0)
        [result[@"data"] addObject: @{@"key": @"担保方式", @"value": a}];
    
    //担保方
    NSMutableArray *array = [NSMutableArray array];
    QSection *section = [root sectionWithKey:@"Guarantee"];
    for (id el in section.elements) {
        if ([el isKindOfClass:[QEntryElement class]]) {
            NSString *textValue = ((QEntryElement *)el).textValue;
            if (textValue.length > 0)
                [array addObject:textValue];
        }
    }
    if (array.count > 0)
        [result[@"data"] addObject: @{@"key": @"担保方", @"value":array}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"担保保证";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addGuarantee)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
