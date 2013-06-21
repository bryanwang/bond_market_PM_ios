//
//  ProjectBasicInfoViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectBasicInfoViewController.h"
#import "UseOfFoundsViewController.h"
#import "FinancingMethodViewController.h"
#import "TrustIncreaseViewController.h"


@interface ProjectBasicInfoViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, strong) NSMutableDictionary *projectInfo;

@property (nonatomic, strong) UseOfFoundsViewController *useOfFoundsViewController;
@property (nonatomic, strong) FinancingMethodViewController *financingViewController;
@property (nonatomic, strong) TrustIncreaseViewController *trustIncreaseViewController;

@end

@implementation ProjectBasicInfoViewController {
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
    if(info[@"ValidFrom"] && ![info[@"ValidFrom"] isEqual:[NSNull null]])
        info[@"ValidFrom"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] dateFromString: info[@"ValidFrom"] ];
    
    //询价有效期截止
    if(info[@"ValidTo"] && ![info[@"ValidTo"] isEqual:[NSNull null]])
        info[@"ValidTo"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] dateFromString: info[@"ValidTo"] ];
    
    //融资成本
    if (info[@"CostFrom"] && ![info[@"CostFrom"] isEqual:[NSNull null]]) {
        info[@"CostFrom"] = [NSString stringWithFormat:@"%@%%\t%@%%", info[@"CostFrom"], info[@"CostTo"]];
    }
    
    //区域
    if (info[@"AreaProvince"] && ![info[@"AreaProvince"] isEqual:[NSNull null]]) {
        info[@"Area"] = [NSString stringWithFormat:@"%@\t%@\t%@", info[@"AreaProvince"], info[@"AreaCity"], info[@"AreaDistrict"]];
    }

    //增信方式
    if (info[@"TrustIncrease"]) {
        id trustIncrease= [[Utils sharedInstance] convertJSONStrToObject:info[@"TrustIncrease"]];
        [self.trustIncreaseViewController bindObject:trustIncrease];
    }
    
    //资金用途
    if (info[@"UseOfFunds"]) {
        id useOfFunds= [[Utils sharedInstance] convertJSONStrToObject:info[@"UseOfFunds"]];
        [self.useOfFoundsViewController bindObject:useOfFunds];
    }
    
    //融资方式
    if (info[@"FinancingMethod"]) {
        id financingMethod= [[Utils sharedInstance] convertJSONStrToObject:info[@"FinancingMethod"]];
        [self.financingViewController bindObject:financingMethod];
    }
    
    self.projectInfo = info;
    [self.quickDialogTableView.root bindToObject:info];
}


- (NSMutableDictionary *)fetchData
{
    NSMutableDictionary *project = [NSMutableDictionary dictionary];
    [self.root fetchValueUsingBindingsIntoObject:project];
    
    // 处理所有日期字段的格式
    project[@"ValidFrom"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] stringFromDate:project[@"ValidFrom"]];
    project[@"ValidTo"] = [[[QuickDialogHelper sharedInstance] fulldateFormater] stringFromDate:project[@"ValidTo"]];
    
    // 处理省市区字段
    QPickerElement *areaElt = (QPickerElement *)[self.root elementWithKey:@"Area"];
    NSArray *areaArray = [areaElt.value componentsSeparatedByString:@"\t"];
    if (areaArray.count > 0) {
        project[@"AreaProvince"] = areaArray[0];
        project[@"AreaCity"] = areaArray[1];
        project[@"AreaDistrict"] = areaArray[2];
    }
    
    // 融资成本
    QPickerElement *costEl = (QPickerElement *)[self.root elementWithKey:@"Cost"];
    NSArray *interestArray = [costEl.value componentsSeparatedByString:@"\t"];
    if (interestArray.count > 0) {
        project[@"CostFrom"] = [interestArray[0] substringToIndex:[interestArray[0] length] - 1];
        project[@"CostTo"] = [interestArray[1] substringToIndex:[interestArray[1] length] - 1];
    }
    
    //增信方式
    NSMutableArray *trustIncreaseArray = [self.trustIncreaseViewController fetchData];
    project[@"TrustIncrease"] = [[Utils sharedInstance] convertObjectToJSONStr:trustIncreaseArray];
    
    //资金用途
    NSMutableArray *useOfFundsArray = [self.useOfFoundsViewController fetchData];
    project[@"UseOfFunds"] = [[Utils sharedInstance] convertObjectToJSONStr:useOfFundsArray];;
    
    //融资方式
    id financing = [self.financingViewController fetchData];
    project[@"FinancingMethod"] = [[Utils sharedInstance] convertObjectToJSONStr:financing];;
    
    return project;
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
    self.useOfFoundsViewController.status = UseOfFoundsEditing;
    self.financingViewController.status = FinancingMethodEditing;
}

- (void)setElementsDisable
{
    for(QSection *section in self.quickDialogTableView.root.sections)
    {
        for(QElement *element in section.elements)
        {
            if (![element.key isEqual: @"TrustIncrease"]
                    && ![element.key isEqual: @"UseOfFunds"]
                    && ![element.key isEqual: @"FinancingMethod"])
                element.enabled = NO;
        }
    }

    self.trustIncreaseViewController.status = TrustIncreaseNormal;
    self.useOfFoundsViewController.status = UseOfFoundsNormal;
    self.financingViewController.status = FinancingMethodNormal;
}


#pragma private methods
- (TrustIncreaseViewController *)trustIncreaseViewController
{
    if (_trustIncreaseViewController == nil) {
        _trustIncreaseViewController = [[TrustIncreaseViewController alloc]initWithTrustIncreaseStatus:NonPlatformProjectTrustIncrease];
    }
    
    return _trustIncreaseViewController;
}

- (FinancingMethodViewController *)financingViewController
{
    if (_financingViewController == nil) {
        _financingViewController = [[FinancingMethodViewController alloc]init];
    }
    return _financingViewController;
}

- (UseOfFoundsViewController *)useOfFoundsViewController
{
    if (_useOfFoundsViewController == nil) {
        _useOfFoundsViewController = [[UseOfFoundsViewController alloc]init];
    }
    return _useOfFoundsViewController;
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

- (void)showUseOfFunds: (QElement *)element
{
    id vc = [self.view.superview nextResponder];
    [((UIViewController *)vc).navigationController pushViewController:self.useOfFoundsViewController animated:YES];
}

- (void)showFinancingMethods: (QElement *)element
{
    id vc = [self.view.superview nextResponder];
    [((UIViewController *)vc).navigationController pushViewController:self.financingViewController animated:YES];
}

@end
