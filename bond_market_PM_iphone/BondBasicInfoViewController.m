//
//  ViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondBasicInfoViewController.h"
#import "TrustIncreaseViewController.h"
#import "CreateTrustIncreaseViewController.h"


@interface BondBasicInfoViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@end

@implementation BondBasicInfoViewController {
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
    if(info[@"QueryFrom"] && ![info[@"QueryFrom"] isEqual:[NSNull null]])
        info[@"QueryFrom"] = [dateFormatter dateFromString: info[@"QueryFrom"] ];
    
    //询价有效期截止
    if(info[@"QueryTo"] && ![info[@"QueryTo"] isEqual:[NSNull null]])
        info[@"QueryTo"] = [dateFormatter dateFromString: info[@"QueryTo"] ];
    
    //利率期间
    if (info[@"InterestFrom"] && ![info[@"InterestFrom"] isEqual:[NSNull null]]) {
        info[@"Interest"] = [NSString stringWithFormat:@"%@%%\t%@%%", info[@"InterestFrom"], info[@"InterestTo"]];
    }
    
    //区域
    if (info[@"AreaProvince"] && ![info[@"AreaProvince"] isEqual:[NSNull null]]) {
        info[@"Area"] = [NSString stringWithFormat:@"%@\t%@\t%@", info[@"AreaProvince"], info[@"AreaCity"], info[@"AreaDistrict"]];
    }
    
    [self.quickDialogTableView.root bindToObject:info];
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
}

- (NSMutableDictionary *)fetchData
{
    NSMutableDictionary *newbondInfo = [NSMutableDictionary dictionary];
    [self.root fetchValueUsingBindingsIntoObject:newbondInfo];
    
    // 处理所有日期字段的格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    newbondInfo[@"QueryFrom"] = [dateFormatter stringFromDate:newbondInfo[@"QueryFrom"]];
    newbondInfo[@"QueryTo"] = [dateFormatter stringFromDate:newbondInfo[@"QueryTo"]];
    
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
    
    return newbondInfo;
}


#pragma private methods
- (void)fetchProvinces
{
    @autoreleasepool {
        NSArray *ps = [Utils sharedInstance].arears;
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
        NSArray *cs = [Utils sharedInstance].arears[index][@"cities"];
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
        NSArray *as  =[Utils sharedInstance].arears[pindex][@"cities"][cindex][@"areas"];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedProvince = @0;
    selectedCity = @0;
  
    QSection *section = [self.root getSectionForIndex:0];
    //地区选择器
    QPickerElement *element = (QPickerElement *)[section getVisibleElementForIndex:3];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma quick dialog ation control
- (void)showTrustWays:(QElement *)element
{
    CreateTrustIncreaseViewController *cc = [[CreateTrustIncreaseViewController alloc]initWithNibName:@"CreateTrustWaysViewController" bundle:nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:cc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}



@end
