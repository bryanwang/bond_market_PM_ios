//
//  ViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondBasicInfoViewController.h"
#import "TrustWaysViewController.h"
#import "CreateTrustWaysViewController.h"


@interface BondBasicInfoViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@end

@implementation BondBasicInfoViewController {
    QElement *areaElement;
    NSNumber *selectedProvince;
    NSNumber *selectedCity;
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
        NSLog(@"%@", as);
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
    CreateTrustWaysViewController *cc = [[CreateTrustWaysViewController alloc]initWithNibName:@"CreateTrustWaysViewController" bundle:nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:cc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}



@end
