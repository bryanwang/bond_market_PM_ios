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

- (void)addEnhancements
{
    NSMutableDictionary *result = [@{@"type": @"内部增级", @"data": [@[] mutableCopy]} mutableCopy];
    
    //read data from table
    QRootElement *root = self.qc.quickDialogTableView.root ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [root fetchValueIntoObject:dic];
    
    //内部增级
    NSArray *kinds =[Utils sharedInstance].EnhancementsProperties;
    NSMutableArray *a = [NSMutableArray array];
    [(NSArray *)dic[@"内部增级"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [a addObject: kinds[[obj integerValue]]];
    }];
    if (a.count > 0)
        [result[@"data"] addObject: @{@"key": @"内部增级", @"value": a}];
    
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
    
    QRootElement *root = [[QRootElement alloc] initWithJSONFile:@"EnhancementsDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
