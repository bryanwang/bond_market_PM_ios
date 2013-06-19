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
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSMutableDictionary *info = [obj mutableCopy];
    
    //处理所有数字
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null]) {
            info[key] = [NSString stringWithFormat:@"%@", obj];
        }
    }];
    
    //询价有效期
    if(info[@"ValidFrom"] && ![info[@"ValidFrom"] isEqual:[NSNull null]])
        info[@"ValidFrom"] = [dateFormatter dateFromString: info[@"ValidFrom"] ];
    
    //询价有效期截止
    if(info[@"ValidTo"] && ![info[@"ValidTo"] isEqual:[NSNull null]])
        info[@"ValidTo"] = [dateFormatter dateFromString: info[@"ValidTo"] ];
    
    //融资成本
    if (info[@"CostFrom"] && ![info[@"CostFrom"] isEqual:[NSNull null]]) {
        info[@"CostFrom"] = [NSString stringWithFormat:@"%@%%\t%@%%", info[@"CostFrom"], info[@"CostTo"]];
    }
    
    //区域
    if (info[@"AreaProvince"] && ![info[@"AreaProvince"] isEqual:[NSNull null]]) {
        info[@"Area"] = [NSString stringWithFormat:@"%@\t%@\t%@", info[@"AreaProvince"], info[@"AreaCity"], info[@"AreaDistrict"]];
    }

    NSError *error = nil;
    //增信方式
    if (info[@"TrustIncrease"]) {
        NSData *trustIncreaseData = [info[@"TrustIncrease"] dataUsingEncoding:NSUTF8StringEncoding];
        id trustIncrease = [NSJSONSerialization JSONObjectWithData:trustIncreaseData options:0 error:&error];
        [self.trustIncreaseViewController bindObject:trustIncrease];
    }
    
    //资金用途
    if (info[@"UseOfFunds"]) {
        NSData *useOfFundsData = [info[@"UseOfFunds"] dataUsingEncoding:NSUTF8StringEncoding];
        id useOfFunds = [NSJSONSerialization JSONObjectWithData:useOfFundsData options:0 error:&error];
        [self.useOfFoundsViewController bindObject:useOfFunds];
    }
    
    //融资方式
    if (info[@"FinancingMethod"]) {
        NSData *financingMethodData = [info[@"FinancingMethod"] dataUsingEncoding:NSUTF8StringEncoding];
        id financingMethod = [NSJSONSerialization JSONObjectWithData:financingMethodData options:0 error:&error];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    project[@"ValidFrom"] = [dateFormatter stringFromDate:project[@"ValidFrom"]];
    project[@"ValidTo"] = [dateFormatter stringFromDate:project[@"ValidTo"]];
    
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
    NSError *error = nil;
    NSData *trustIncreaseData = [NSJSONSerialization dataWithJSONObject:trustIncreaseArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *trustIncreaseJsonStr = [[NSString alloc] initWithData:trustIncreaseData encoding:NSUTF8StringEncoding];
    
    project[@"trustIncrease"] = trustIncreaseJsonStr;
    
    //资金用途
    NSMutableArray *useOfFundsArray = [self.useOfFoundsViewController fetchData];
    NSData *useOfFundsData = [NSJSONSerialization dataWithJSONObject:useOfFundsArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *useOfFundsJsonStr = [[NSString alloc] initWithData:useOfFundsData encoding:NSUTF8StringEncoding];
    
    project[@"UseOfFunds"] = useOfFundsJsonStr;
    
    //融资方式
    id financing = [self.financingViewController fetchData];
    NSData *financingMethodData = [NSJSONSerialization dataWithJSONObject:financing options:NSJSONWritingPrettyPrinted error:&error];
    NSString * financingMethodJsonStr = [[NSString alloc] initWithData:financingMethodData encoding:NSUTF8StringEncoding];
    
    project[@"FinancingMethod"] = financingMethodJsonStr;
    
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
            if (![element.key isEqual: @"TrustIncrease"])
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

- (void)fetchProvinces
{
    @autoreleasepool {
        NSArray *ps = [Utils sharedInstance].Arears;
        NSMutableArray *array = [NSMutableArray array];
        [ps enumerateObjectsUsingBlock:^(id p, NSUInteger index, BOOL*stop) {
            [array addObject:p[@"state"]];
        }];
        
        self.provinces = [array copy];
    }
}

- (void)fetchCitiesWithProvincesIndex: (NSInteger)index
{
    @autoreleasepool {
        NSArray *cs = [Utils sharedInstance].Arears[index][@"cities"];
        NSMutableArray *array = [NSMutableArray array];
        [cs enumerateObjectsUsingBlock:^(id c, NSUInteger index, BOOL*stop) {
            [array addObject:c[@"city"]];
        }];
        
        self.cities = [array copy];
    }
}

- (void)fetchAreasWithCityIndex: (NSInteger)cindex AndProvincesIndex: (NSInteger )pindex
{
    @autoreleasepool {
        NSArray *as  =[Utils sharedInstance].Arears[pindex][@"cities"][cindex][@"areas"];
        NSMutableArray *array = [NSMutableArray array];
        [as enumerateObjectsUsingBlock:^(id a, NSUInteger index, BOOL*stop) {
            [array addObject:a];
        }];
        
        if (array.count == 0) {
            [array addObject:@""];
        }
        
        self.areas = [array copy];
    }
}


- (void)displayViewControllerForRoot:(QRootElement *)element {
    QuickDialogController *newController = [QuickDialogController controllerForRoot:element];
    [super displayViewController:newController];
}

- (void)setupAreaPicker
{
    selectedProvince = @0;
    selectedCity = @0;
    
    //地区选择器
    QPickerElement *element = (QPickerElement *)[self.root elementWithKey:@"Area"];
    
    [self fetchProvinces];
    [self fetchCitiesWithProvincesIndex:[selectedProvince integerValue] ];
    [self fetchAreasWithCityIndex:[selectedCity integerValue] AndProvincesIndex:[selectedProvince integerValue]];
    
    NSArray *provinces = [self.provinces copy];
    NSArray *cities = [self.cities copy];
    NSArray *areas = [self.areas copy];
    element.items =  @[provinces, cities, areas];
    element.onValueChanged = ^(QRootElement *el) {
        QPickerElement *p =  (QPickerElement *)el;
        //provinces selected index
        NSNumber *pi = p.selectedIndexes[0];
        //cities selected index
        NSNumber *ci = p.selectedIndexes[1];
        if ([pi integerValue] != [selectedProvince integerValue]) { //if provinces selected index changed, set cities and areas selected index to 0
            [p selectRow:0 inComponent:1 animated:NO];
            [p selectRow:0 inComponent:2 animated:NO];
            
            selectedCity = @0;
            selectedProvince = pi;
        } else if ([ci integerValue] != [selectedCity integerValue]) {//if cities selected index changed, set areas selected index to 0
            [p selectRow:0 inComponent:2 animated:NO];
            selectedCity = ci;
        }
        
        [self fetchCitiesWithProvincesIndex:[pi integerValue]];
        [self fetchAreasWithCityIndex:[ci integerValue] AndProvincesIndex: [pi integerValue]];
        p.items =  @[self.provinces, self.cities, self.areas];
        
        [p reloadAllComponents];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAreaPicker];
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

- (void)showFinancing: (QElement *)element
{
    id vc = [self.view.superview nextResponder];
    [((UIViewController *)vc).navigationController pushViewController:self.financingViewController animated:YES];
}

@end
