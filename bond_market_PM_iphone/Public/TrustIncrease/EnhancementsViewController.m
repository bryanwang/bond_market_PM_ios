//
//  EnhancementsViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "EnhancementsViewController.h"

@interface EnhancementsViewController ()

@end

@implementation EnhancementsViewController

- (id)init
{
    self = [super init];
    if (self) {
        QRootElement *root = [[QRootElement alloc]initWithJSONFile:@"EnhancementsDataBuilder" andData:nil];
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:root];
        self.qc.view.frame = self.view.bounds;
    }
    
    return self;
}


- (void)addEnhancements
{
    NSMutableDictionary *result = [@{@"type": @"内部增级", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //内部增级
    QSelectSection *s = (QSelectSection *)[root sectionWithKey:@"内部增级"];
    NSMutableArray *items = [s.selectedItems mutableCopy];
    if (items.count > 0)
        [result[@"data"] addObject: @{@"key": @"内部增级", @"value": items}];
    
    if (dic[@"其他内部增级"])
       [result[@"data"] addObject: @{@"key": @"其他", @"value": dic[@"其他内部增级"]}];
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:result forKey:BYTRUSTINCREASEKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPOPVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:info];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"内部增级";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(addEnhancements)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
