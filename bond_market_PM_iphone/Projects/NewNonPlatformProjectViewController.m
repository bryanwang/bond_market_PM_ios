//
//  NewNonPlatformProjectViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "NewNonPlatformProjectViewController.h"
#import "NonPlatformProjectBasicInfoViewController.h"
#import "NonPlatformProjectFinancialIndicatorsViewController.h"
#import "NonPlatformProjectRemarkViewController.h"
#import <AKSegmentedControl.h>

@interface NewNonPlatformProjectViewController ()
@property (strong, nonatomic)AKSegmentedControl *segmentedControl;
@property (strong, nonatomic)NonPlatformProjectBasicInfoViewController *bc;
@property (strong, nonatomic)NonPlatformProjectFinancialIndicatorsViewController *fc;
@property (strong, nonatomic)NonPlatformProjectRemarkViewController *rc;

@property (strong, nonatomic)NSMutableDictionary *project;

@end

@implementation NewNonPlatformProjectViewController

- (id)initWithProject:(NSDictionary *)project
{
    if( self = [super init] ) {
        self.project = project[@"ProjectInfo"];
    }
    return self;
}

- (NonPlatformProjectBasicInfoViewController *)bc
{
    if (_bc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ProjectBasicDataBuilder" andData:nil];
        _bc = [[NonPlatformProjectBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _bc;
}

- (NonPlatformProjectFinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ProjectFinanceDataBuilder" andData:nil];
        _fc = [[NonPlatformProjectFinancialIndicatorsViewController alloc]initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _fc;
}

- (NonPlatformProjectRemarkViewController *)rc
{
    if (_rc == nil) {
        _rc = [[NonPlatformProjectRemarkViewController alloc]init];
        _rc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _rc;
}


- (void)changeFormDetail: (NSUInteger)index
{
    switch (index) {
        case 0:
            [self.view bringSubviewToFront:self.bc.view];
            [self hideKeyBoard];
            break;
        case 1:
            [self.view bringSubviewToFront:self.fc.view];
            [self hideKeyBoard];
            break;
        case 2:
            [self.view bringSubviewToFront:self.rc.view];
            [self hideKeyBoard];
            break;
        default:
            [self.view bringSubviewToFront:self.bc.view];
            [self hideKeyBoard];
            break;
    }
}

- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self changeFormDetail: index];
}

- (void)setUpSegmentedController
{
    CGRect aRect = CGRectMake(0.0f, 0.0f, APP_SCREEN_WIDTH, 44.0f);
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:aRect];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"sort-bar"];
    [segmentedControl setBackgroundImage:backgroundImage];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"sort-bar-01-sel"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"sort-bar-01-sel"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"sort-bar-01-sel"];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"基本信息" forState:UIControlStateNormal];
    btn1.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn1 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn1 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn1 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn2 = [[UIButton alloc] init];
    btn2.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn2 setTitle:@"财务指标" forState:UIControlStateNormal];
    [btn2 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn2 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn2 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn3 = [[UIButton alloc] init];
    btn3.titleLabel.font =  [UIFont systemFontOfSize: 14.0];
    [btn3 setTitle:@"备注说明" forState:UIControlStateNormal];
    [btn3 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateHighlighted];
    [btn3 setTitleColor:RGBCOLOR(186, 13, 17) forState:UIControlStateSelected];
    [btn3 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [segmentedControl setButtonsArray:@[btn1, btn2, btn3]];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    [self.view addSubview:segmentedControl];
}


- (void)setElementsDisabled
{
    [self.bc setElementsDisable];
    [self.fc setElementsDisable];
    [self.rc setElementsDisable];
}


- (void)setElementsEnable
{
    [self.bc setElementsEnable];
    [self.fc setElementsEnable];
    [self.rc setElementsEnable];
}

- (void)changeProjectViewSatatus: (ProjectEditStaus)status
{
    switch (status) {
        case ProjectEditing:
            [self setElementsEnable];
            break;
        case ProjectView:
            [self setElementsDisabled];
            break;
        case ProjectCreate:
            [self setElementsEnable];
            break;
    }
    
    [self.bc.quickDialogTableView reloadData];
    [self.fc.quickDialogTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"非平台项目录入";
    
    [self setUpSegmentedController];
    [self.segmentedControl setSelectedIndex:0];
    
    //todo:..
    [self changeProjectViewSatatus:ProjectCreate];
    
    RunBlockAfterDelay(.3, ^{
        [self.view addSubview:self.bc.view];
        [self.view addSubview:self.fc.view];
        [self.view addSubview:self.rc.view];
        
        [self changeFormDetail:0];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end