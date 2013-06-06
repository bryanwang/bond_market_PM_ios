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
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"BasicDataBuilder" andData:nil];
        _bc = [[BondBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
        [self.view addSubview:_bc.view];
    }
    return _bc;
}

- (FinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"FinanceDataBuilder" andData:nil];
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





- (NSMutableDictionary *)buildNewbondInfo
{
    NSMutableDictionary *newbondInfo = [[NSMutableDictionary alloc] init];
    [self.bc.root fetchValueUsingBindingsIntoObject:newbondInfo];
    
    newbondInfo[@"FinanceIndex"] = [self.fc buildFinaceIndexJson];
    newbondInfo[@"Remark"] = [self.rc remarkText];
    
    // 处理所有日期字段的格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    newbondInfo[@"QueryFrom"] = [dateFormatter stringFromDate:newbondInfo[@"QueryFrom"]];
    newbondInfo[@"QueryTo"] = [dateFormatter stringFromDate:newbondInfo[@"QueryTo"]];
    
    // 处理省市区字段
    QPickerElement *areaElement = (QPickerElement *)[self.bc.root elementWithKey:@"Area"];
    if ([areaElement.textValue length] > 0) {
        newbondInfo[@"AreaProvince"] = areaElement.items[0][[areaElement.selectedIndexes[0] intValue]];
        newbondInfo[@"AreaCity"] = areaElement.items[1][[areaElement.selectedIndexes[1] intValue]];
        newbondInfo[@"AreaDistrict"] = areaElement.items[2][[areaElement.selectedIndexes[2] intValue]];
    }
    
    // 处理利率区间
    QPickerElement *interestElement = (QPickerElement *)[self.bc.root elementWithKey:@"Interest"];
    if ([interestElement.textValue length] > 0) {
        newbondInfo[@"InterestFrom"] = interestElement.items[0][[interestElement.selectedIndexes[0] intValue]];
        newbondInfo[@"InterestTo"] = interestElement.items[1][[interestElement.selectedIndexes[1] intValue]];
        // 去掉百分号
        newbondInfo[@"InterestFrom"] = [newbondInfo[@"InterestFrom"] substringToIndex:[newbondInfo[@"InterestFrom"] length] - 1];
        newbondInfo[@"InterestTo"] = [newbondInfo[@"InterestTo"] substringToIndex:[newbondInfo[@"InterestTo"] length] - 1];
    }
    return newbondInfo;
}

- (void)submitNewBondInfo
{  
    NSMutableDictionary *newbondInfo = [self buildNewbondInfo];  
   
    // 简称 这个字段必填
    if ([newbondInfo[@"ShortTitle"] length] == 0) {
        [ALToastView toastInView:self.view withText:@"债券简称必填"];
        return;
    }    
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:newbondInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"  > the json string: %@", jsonString);
//
    NSString *userId = [LoginManager sharedInstance].fetchUserId;
    NSDictionary *parameters = @{@"userid": userId, @"newbond": jsonString};
  
    [[PMHttpClient shareIntance] postPath:CREATE_NEWBOND_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"Success"] isEqual: @1]) {
            [ALToastView toastInView:self.view withText:@"新债提交成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ALToastView toastInView:self.view withText:@"网络问题，提交失败"];
    }];
    
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"] highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"] target:self selector:@selector(submitNewBondInfo)];
    ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)(item.customView)) setTitle:@"完成" forState:UIControlStateNormal];
    [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新债录入";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpLeftNavigationButton];
    [self setUpSegmentedController];
    [self registerNotification];

    [self.segmentedControl setSelectedIndex:0];
    
    //bug: 延迟加载 table 信息
    __block NewBondViewController* nc = self;
    RunBlockAfterDelay(0.35f, ^{
        [nc changeFormDetail:0];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
