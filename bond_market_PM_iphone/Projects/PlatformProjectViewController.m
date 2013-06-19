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
//@property (strong, nonatomic) ProjectBasicInfoViewController *bc;
//@property (strong, nonatomic) ProjectFinancialIndicatorsViewController *fc;
//@property (strong, nonatomic) ProjectRemarkViewController *rc;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
