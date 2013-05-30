//
//  NewBondViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "NewBondViewController.h"
#import <AKSegmentedControl.h>
#import "BondBasicInfoViewController.h"
#import "FinancialIndicatorsViewController.h"
#import "BondRemarkViewController.h"

@interface NewBondViewController ()
@property (nonatomic, strong) BondBasicInfoViewController *bc;
@property (nonatomic, strong) FinancialIndicatorsViewController *fc;
@property (nonatomic, strong) BondRemarkViewController *rc;
@property (nonatomic, strong) AKSegmentedControl *segmentedControl;
@end

@implementation NewBondViewController

- (BondBasicInfoViewController *)bc
{
    if (_bc == nil) {
        QRootElement *root = [BasicDataBuilder create];
        _bc = [[BondBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
        [self.view addSubview:_bc.view];
    }
    return _bc;
}

- (FinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root = [FinanceDataBuilder create];
        _fc = [[FinancialIndicatorsViewController alloc]initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
        [self.view addSubview:_fc.view];
    }
    return _fc;
}

- (BondRemarkViewController *)rc
{
    if (_rc == nil) {
        _rc = [[BondRemarkViewController alloc]initWithNibName:@"BondRemarkViewController" bundle:nil];
        _rc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
        [self.view addSubview:_rc.view];

    }
    return _rc;
}

//隐藏键盘
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
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

- (void)pushNotificationViewContoller: (NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    UIViewController *vc = [info objectForKey:BYCONTROLLERKEY];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationViewContoller:) name:BYPUSHVIEWCONTOLLERNOTIFICATION object:nil];
}

- (void)setUpSegmentedController
{
    CGRect aRect = CGRectMake(0.0f, 0.0f, APP_SCREEN_WIDTH, 44.0f);
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:aRect];
    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    //    segmentedControl.separatorImage = [[UIImage alloc] init];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"segmented-bg.png"];
    [segmentedControl setBackgroundImage:backgroundImage];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"segmented-bg-pressed-left.png"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"segmented-bg-pressed-center.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"segmented-bg-pressed-right.png"];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"基本信息" forState:UIControlStateNormal];
    [btn1 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"财务指标" forState:UIControlStateNormal];
    [btn2 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:@"备注说明" forState:UIControlStateNormal];
    [btn3 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [btn3 setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [segmentedControl setButtonsArray:@[btn1, btn2, btn3]];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    [self.view addSubview:segmentedControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新债录入";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpSegmentedController];
    [self registerNotification];

    [self.segmentedControl setSelectedIndex:0];
    
    RunBlockAfterDelay(0.35f, ^{
        [self changeFormDetail:0];
    });
}

- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self changeFormDetail: index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
