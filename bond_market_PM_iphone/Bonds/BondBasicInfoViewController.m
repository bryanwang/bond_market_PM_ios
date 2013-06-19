//
//  ViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondBasicInfoViewController.h"
#import "AddTrustIncreaseViewController.h"


@interface BondBasicInfoViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, strong) NSMutableDictionary *bondInfo;

@end

@implementation BondBasicInfoViewController {
    NSNumber *selectedProvince;
    NSNumber *selectedCity;
}

#pragma public methods
- (void)bindObject: (NSDictionary *)obj
{
    NSMutableDictionary *info = [obj mutableCopy];
    //处理所有数字
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null]) {
            info[key] = [NSString stringWithFormat:@"%@", obj];
        }
    }];
    
    //询价有效期
    if(info[@"QueryFrom"] && ![info[@"QueryFrom"] isEqual:[NSNull null]])
        info[@"QueryFrom"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] dateFromString: info[@"QueryFrom"] ];
    
    //询价有效期截止
    if(info[@"QueryTo"] && ![info[@"QueryTo"] isEqual:[NSNull null]])
        info[@"QueryTo"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] dateFromString: info[@"QueryTo"] ];
    
    //利率期间
    if (info[@"InterestFrom"] && ![info[@"InterestFrom"] isEqual:[NSNull null]]) {
        info[@"Interest"] = [NSString stringWithFormat:@"%@%%\t%@%%", info[@"InterestFrom"], info[@"InterestTo"]];
    }
    
    //区域
    if (info[@"AreaProvince"] && ![info[@"AreaProvince"] isEqual:[NSNull null]]) {
        info[@"Area"] = [NSString stringWithFormat:@"%@\t%@\t%@", info[@"AreaProvince"], info[@"AreaCity"], info[@"AreaDistrict"]];
    }
    
    //增信方式
    if (info[@"TrustIncrease"]) {
        id trustIncreaseArray = [[QuickDialogHelper sharedInstance] convertJSONStrToObject:info[@"TrustIncrease"]];
        [self.trustIncreaseViewController bindObject: trustIncreaseArray];
    }
    
    self.bondInfo = info;
    [self.quickDialogTableView.root bindToObject:info];
}


- (NSMutableDictionary *)fetchData
{
    NSMutableDictionary *newbondInfo = [NSMutableDictionary dictionary];
    [self.root fetchValueUsingBindingsIntoObject:newbondInfo];
    
    // 处理所有日期字段的格式
    newbondInfo[@"QueryFrom"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] stringFromDate:newbondInfo[@"QueryFrom"]];
    newbondInfo[@"QueryTo"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] stringFromDate:newbondInfo[@"QueryTo"]];
    
    // 处理省市区字段
    QPickerElement *areaElt = (QPickerElement *)[self.root elementWithKey:@"Area"];
    NSArray *areaArray = [areaElt.value componentsSeparatedByString:@"\t"];
    if (areaArray.count > 0) {
        newbondInfo[@"AreaProvince"] = areaArray[0];
        newbondInfo[@"AreaCity"] = areaArray[1];
        newbondInfo[@"AreaDistrict"] = areaArray[2];
    }
    
    // 处理利率区间
    QPickerElement *interestEl = (QPickerElement *)[self.root elementWithKey:@"Interest"];
    NSArray *interestArray = [interestEl.value componentsSeparatedByString:@"\t"];
    if (interestArray.count > 0) {
        newbondInfo[@"InterestFrom"] = [interestArray[0] substringToIndex:[interestArray[0] length] - 1];
        newbondInfo[@"InterestTo"] = [interestArray[1] substringToIndex:[interestArray[1] length] - 1];
    }
    
    //增信方式
    NSMutableArray *trustIncreaseArray = [self.trustIncreaseViewController fetchData];
    newbondInfo[@"trustIncrease"] = [[QuickDialogHelper sharedInstance]convertObjectToJSONStr:trustIncreaseArray];
    
    return newbondInfo;
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
    
    self.trustIncreaseViewController.status = TrustIncreaseEditing;
}

- (void)setElementsDisable
{
    for(QSection *section in self.quickDialogTableView.root.sections)
    {
        for(QElement *element in section.elements)
        {
            if (![element.key isEqual: @"TrustIncrease"])
                element.enabled = NO;
        }
    }
    
    self.trustIncreaseViewController.status = TrustIncreaseNormal;
}


#pragma private methods
- (TrustIncreaseViewController *)trustIncreaseViewController
{
    if (_trustIncreaseViewController == nil) {
        _trustIncreaseViewController = [[TrustIncreaseViewController alloc]initWithTrustIncreaseStatus:BondTrustIncrease];
    }
    
    return _trustIncreaseViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QPickerElement *arearsPicker = (QPickerElement *)[self.root elementWithKey:@"Area"];
    [[QuickDialogHelper sharedInstance]setUpArearsPickerRoles:arearsPicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma quick dialog ation control
- (void)showTrustWays:(QElement *)element
{
    id vc = [self.view.superview nextResponder];
    [((UIViewController *)vc).navigationController pushViewController:self.trustIncreaseViewController animated:YES];
}

@end
