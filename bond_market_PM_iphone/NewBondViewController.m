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

typedef enum BondEditStaus: NSUInteger {
    BondView,
    BondEditing,
    BondCreate
} BondEditStaus;

@interface NewBondViewController ()
@property (nonatomic, strong)NSDictionary *bondInfo;

@property (nonatomic, strong) BondBasicInfoViewController *bc;
@property (nonatomic, strong) FinancialIndicatorsViewController *fc;
@property (nonatomic, strong) BondRemarkViewController *rc;
@property (nonatomic, strong) AKSegmentedControl *segmentedControl;
@property (nonatomic, strong)PopupListComponent *popComponent;

@end

@implementation NewBondViewController

- (id)initWithBond:(NSDictionary *)bond
{
    if( self = [super init] ) {
        self.bondInfo = bond[@"NewBondInfo"];
    }
    return self;
}

- (BondBasicInfoViewController *)bc
{
    if (_bc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"BasicDataBuilder" andData:nil];
        _bc = [[BondBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
    }
    return _bc;
}

- (FinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"FinanceDataBuilder" andData:nil];
        _fc = [[FinancialIndicatorsViewController alloc]initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
    }
    return _fc;
}

- (BondRemarkViewController *)rc
{
    if (_rc == nil) {
        _rc = [[BondRemarkViewController alloc]initWithNibName:@"BondRemarkViewController" bundle:nil];
        _rc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);
    }
    return _rc;
}


- (NSMutableDictionary *)buildNewbondInfo
{
    NSMutableDictionary *newbondInfo = [self.bc fetchData];
    newbondInfo[@"FinanceIndex"] = [self.fc fetchData] ;
    newbondInfo[@"Remark"] = [self.rc fetchData];

    //如果self.bondInfo 不为空 则 操作为update
    //如果self.bondInfo 为空 则 操作为create
    if (self.bondInfo)
        newbondInfo[@"Id"] = self.bondInfo[@"Id"];

    return newbondInfo;
}

- (void)operateNewBondInfo: (id)sender
{
    if (self.popComponent) {
        [self.popComponent hide];
    }
    PopupListComponent *popupList = [[PopupListComponent alloc] init];
    self.popComponent = popupList;
    
    //callbacks
    popupList.choosedItemCallback = ^(int itemid) {
        switch (itemid) {
            case 0:
                [ALToastView toastInView:APP_WINDOW withText:@"进入编辑状态"];
                [self changeBondViewSatatus:BondEditing];
                break;
            case 1:
                [self showDeleteAlertView];
                break;
        }
    };
    popupList.popupDismissedCallback = ^() {
        NSLog(@"dismissed");
    };
    
    //items
    [popupList showAnchoredTo:sender withItems:@[
        [[PopupListComponentItem alloc] initWithCaption:@"修改" image:[UIImage imageNamed:@"operate-edit"] itemId:0],
        [[PopupListComponentItem alloc] initWithCaption:@"删除" image:[UIImage imageNamed:@"operate-delete"] itemId:1]
     ]];
}

- (void)showDeleteAlertView
{
    [self.popComponent hide];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除新债"
                                                   message:@"确定删除?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)deleteBond
{
    NSString *userId = [LoginManager sharedInstance].fetchUserId;
    NSDictionary *parameters = @{@"userid": userId, @"newbondId": self.bondInfo[@"Id"]};
    
    [[PMHttpClient shareIntance] postPath:DELETE_NEWBOND_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"Success"] isEqual: @1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [ALToastView toastInView:APP_WINDOW withText:@"删除成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)cancelEditBond
{
    [ALToastView toastInView:APP_WINDOW withText:@"取消编辑状态"];
    [self changeBondViewSatatus:BondView];
}

- (void)updateBond
{
    [self hideKeyBoard];
    
    NSMutableDictionary *newbondInfo = [self buildNewbondInfo];
    // 简称 这个字段必填
    if ([newbondInfo[@"ShortTitle"] length] == 0) {
        [ALToastView toastInView:self.view withText:@"债券简称必填"];
        return;
    }
    
    NSString *userId = [LoginManager sharedInstance].fetchUserId;
    //转成string
    NSError *error = nil;
    NSData *finance = [NSJSONSerialization dataWithJSONObject:newbondInfo[@"FinanceIndex"] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *financeJsonString = [[NSString alloc] initWithData:finance encoding:NSUTF8StringEncoding];
    newbondInfo[@"FinanceIndex"] = financeJsonString;
    NSData *bond = [NSJSONSerialization dataWithJSONObject:newbondInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSString *bondJsonString = [[NSString alloc] initWithData:bond encoding:NSUTF8StringEncoding];

    NSDictionary *parameters = @{@"userid": userId, @"newbond": bondJsonString};
    
    [[PMHttpClient shareIntance] postPath:UPDATE_NEWBOND_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"Success"] isEqual: @1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [ALToastView toastInView:APP_WINDOW withText:@"提交成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ALToastView toastInView:APP_WINDOW withText:@"网络问题，提交失败"];
    }];
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


- (void)changeBondViewSatatus: (BondEditStaus)status
{
    switch (status) {
        case BondEditing:
            [self.popComponent hide];
            [self setElementsEnable];
            break;
        case BondView:
            [self setElementsDisabled];
            break;
        case BondCreate:
            [self setElementsEnable];
            break;
    }

    [self setUpNavigationButton:status];
    [self.bc.quickDialogTableView reloadData];
    [self.fc.quickDialogTableView reloadData];
}


- (void)setUpNavigationButton: (BondEditStaus)status
{
    //right button
    SEL selector  = nil;
    NSString *title = nil;
    if (status == BondView) {
        selector = @selector(operateNewBondInfo:);
        title = @"操作";
    } else{
        selector = @selector(updateBond);
        title = @"完成";
    }
    
    UIBarButtonItem *item = [UIBarButtonItem
            barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"]
            highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"]
            target:self
            selector:selector];
    ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)(item.customView)) setTitle:title forState:UIControlStateNormal];
    [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];

    self.navigationItem.rightBarButtonItem = item;
    
    //left button
    if (status == BondEditing) {
        UIBarButtonItem *item = [UIBarButtonItem
                                 barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"]
                                 highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"]
                                 target:self
                                 selector:@selector(cancelEditBond)];
        ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [((UIButton *)(item.customView)) setTitle:@"取消" forState:UIControlStateNormal];
        [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
        
       self.navigationItem.leftBarButtonItem = item;
    } else {
        [self addCustomBackButtonWithTitle:@"返回"];
    }
}

- (void)setUpTableView
{
    if (self.bondInfo) {
        self.title = @"新债详情";
        [self.bc bindObject:self.bondInfo];
        
        NSData *financeData = [self.bondInfo[@"FinanceIndex"] dataUsingEncoding:NSUTF8StringEncoding];
        id finance = [NSJSONSerialization JSONObjectWithData:financeData options:0 error:nil];
        [self.fc bindObject:finance];
        
        [self.rc bindObject:self.bondInfo[@"Remark"]];

        [self setElementsDisabled];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新债录入";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpTableView];
    [self changeBondViewSatatus:self.bondInfo? BondView : BondCreate];
    [self setUpSegmentedController];
    [self registerNotification];

    [self.segmentedControl setSelectedIndex:0];
    
    //bug: 延迟加载 table 信息
    __block NewBondViewController* nc = self;
    RunBlockAfterDelay(0.35f, ^{
        [self.view addSubview:self.bc.view];
        [self.view addSubview:self.fc.view];
        [self.view addSubview:self.rc.view];
        
        [nc changeFormDetail:0];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
         [self deleteBond];
    }
}

@end
