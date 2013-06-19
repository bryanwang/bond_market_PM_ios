//
//  PlatformProjectViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "PlatformProjectViewController.h"
#import <AKSegmentedControl.h>


@interface PlatformProjectViewController ()
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) PlatformProjectBasicInfoViewController *bc;
@property (strong, nonatomic) PlatformProjectFinancialIndicatorsViewController *fc;
@property (strong, nonatomic) PlatformProjectRemarkViewController *rc;

@property (strong, nonatomic)NSMutableDictionary *platformProject;

@end

@implementation PlatformProjectViewController

- (id)initWithPlatformProject: (NSDictionary *)platformProject
{
    if( self = [super init] ) {
        self.platformProject = platformProject[@"ProjectInfo"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"平台项目录入";
}


- (PlatformProjectBasicInfoViewController *)bc
{
    if (_bc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"PlatformProjectBasicDataBuilder" andData:nil];
        _bc = [[PlatformProjectBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _bc;
}

- (PlatformProjectFinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"PlatformProjectFinanceDataBuilder" andData:nil];
        _fc = [[PlatformProjectFinancialIndicatorsViewController alloc] initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _fc;
}

- (PlatformProjectRemarkViewController *)rc
{
    if (_rc == nil) {
        _rc = [[PlatformProjectRemarkViewController alloc]init];
        _rc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _rc;
}



@end
