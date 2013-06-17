//
//  NonPlatformProjectBasicInfoViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "NonPlatformProjectBasicInfoViewController.h"
#import "UseOfFoundsViewController.h"
#import "FinancingViewController.h"
#import "TrustIncreaseViewController.h"


@interface NonPlatformProjectBasicInfoViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, strong) NSMutableDictionary *projectInfo;

@property (nonatomic, strong) UseOfFoundsViewController *useOfFoundsViewController;
@property (nonatomic, strong) FinancingViewController *financingViewController;
@property (nonatomic, strong) TrustIncreaseViewController *trustIncreaseViewController;

@end

@implementation NonPlatformProjectBasicInfoViewController {
    NSNumber *selectedProvince;
    NSNumber *selectedCity;
}

#pragma public methods
- (void)bindObject: (NSDictionary *)obj
{
    NSMutableDictionary *info = [obj mutableCopy];
    self.projectInfo = info;
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
    
    self.trustIncreaseViewController.status = TrustIncreaseEditing;
    self.useOfFoundsViewController.status = UseOfFoundsEditing;
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
}

- (NSMutableDictionary *)fetchData
{
    NSMutableDictionary *newbondInfo = [NSMutableDictionary dictionary];
    [self.root fetchValueUsingBindingsIntoObject:newbondInfo];
    
    return newbondInfo;
}


#pragma private methods
- (TrustIncreaseViewController *)trustIncreaseViewController
{
    if (_trustIncreaseViewController == nil) {
        _trustIncreaseViewController = [[TrustIncreaseViewController alloc]initWithTrustIncreaseStatus:NonPlatformProjectTrustIncrease];
    }
    
    return _trustIncreaseViewController;
}

- (FinancingViewController *)financingViewController
{
    if (_financingViewController == nil) {
        _financingViewController = [[FinancingViewController alloc]init];
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
