//
//  EquityViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "EquityViewController.h"

@interface EquityViewController ()

@end

@implementation EquityViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EquityDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}

- (void)addEquityAssertBacked
{
    NSMutableDictionary *result = [@{@"type": @"资产抵质押 - 股权", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    if (dic[@"质押金额"])
        [result[@"data"] addObject: @{@"key": @"质押金额", @"value": dic[@"质押金额"]}];
    
    if (dic[@"覆盖倍数"])
        [result[@"data"] addObject: @{@"key": @"覆盖倍数", @"value": dic[@"覆盖倍数"]}];
    
    //股权所有人
    NSMutableArray *array = [NSMutableArray array];
    QSection *section = [root sectionWithKey:@"股权所有人"];
    for (id el in section.elements) {
        if ([el isKindOfClass:[QEntryElement class]]) {
            NSString *textValue = ((QEntryElement *)el).textValue;
            if (textValue.length > 0)
                [array addObject:textValue];
        }
    }
    if (array.count > 0)
      [result[@"data"] addObject: @{@"key": @"股权所有人", @"value":array}];
    
    // 上市公司
    section = [root sectionWithKey:@"上市公司"];
    QSelectSection *selectionSection = (QSelectSection *)section;
    NSArray *selectedItems = [selectionSection.selectedItems copy];
    if (selectedItems.count > 0)
        [result[@"data"] addObject: @{@"key": @"上市公司", @"value":selectedItems}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"股权";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addEquityAssertBacked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
