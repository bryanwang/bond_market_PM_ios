//
//  AntiGuarantorViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "AntiGuarantorViewController.h"

@interface AntiGuarantorViewController ()

@end

@implementation AntiGuarantorViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"AntiGuarantorDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)AntiGuarantor
{
    NSMutableDictionary *result = [@{@"type": @"反担保人", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //反担保人
    NSMutableArray *array = [NSMutableArray array];
    QSection *section = [root sectionWithKey:@"反担保人"];
    for (id el in section.elements) {
        if ([el isKindOfClass:[QEntryElement class]]) {
            NSString *textValue = ((QEntryElement *)el).textValue;
            if (textValue.length > 0)
                [array addObject:textValue];
        }
    }
    if (array.count > 0)
        [result[@"data"] addObject: @{@"key": @"反担保人", @"value":array}];
    
    //担保方式
    QSelectSection *s = (QSelectSection *)[root sectionWithKey:@"担保方式"];
    NSMutableArray *items = [s.selectedItems mutableCopy];
    if (dic[@"其他担保方式"])
        [items addObject: dic[@"其他担保方式"]];
    if (items.count > 0)
        [result[@"data"] addObject: @{@"key": @"担保方式", @"value": items}];
    
    if (dic[@"反担保人主体评级"])
        [result[@"data"] addObject: @{@"key": @"反担保人主体评级", @"value": dic[@"反担保人主体评级"]}];
    if (dic[@"反担保人发债情况"])
        [result[@"data"] addObject: @{@"key": @"反担保人发债情况", @"value": dic[@"反担保人发债情况"]}];
    if (dic[@"反担保人发债情况"])
        [result[@"data"] addObject: @{@"key": @"反担保人发债情况", @"value": dic[@"反担保人发债情况"]}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"担保保证";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(AntiGuarantor)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
