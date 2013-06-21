//
//  BondViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BondViewController.h"
#import <AKSegmentedControl.h>
#import "BondBasicInfoViewController.h"
#import "BondFinancialIndicatorsViewController.h"
#import "BondRemarkInfoViewController.h"

typedef enum BondEditStaus: NSUInteger {
    BondView,
    BondEditing,
    BondCreate
} BondEditStaus;

@interface BondViewController () {
    NSDictionary *storedBondInfo;
}
@property (nonatomic, strong)NSDictionary *bondInfo;

@property (nonatomic, strong) BondBasicInfoViewController *bc;
@property (nonatomic, strong) BondFinancialIndicatorsViewController *fc;
@property (nonatomic, strong) BondRemarkInfoViewController *rc;
@property (nonatomic, strong) AKSegmentedControl *segmentedControl;
@property (nonatomic, strong)PopupListComponent *popComponent;

@end

@implementation BondViewController

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
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _bc;
}

- (BondFinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"FinanceDataBuilder" andData:nil];
        _fc = [[BondFinancialIndicatorsViewController alloc]initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _fc;
}

- (BondRemarkInfoViewController *)rc
{
    if (_rc == nil) {
        _rc = [[BondRemarkInfoViewController alloc]init];
        _rc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _rc;
}


- (NSMutableDictionary *)buildNewbondInfo
{
    NSMutableDictionary *newbondInfo = [self.bc fetchData];
    newbondInfo[@"FinanceIndex"] = [self.fc fetchData] ;
    newbondInfo[@"Remark"] = [self.rc fetchData];

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
                [self applyToDeleteBond];
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


- (void)applyToDeleteBond
{
    //todo: 发送删除申请
    
//    NSString *userId = [LoginManager sharedInstance].fetchUserId;
//    NSDictionary *parameters = @{@"userid": userId, @"newbondId": self.bondInfo[@"Id"]};
//    
//    [[PMHttpClient shareIntance] postPath:DELETE_NEWBOND_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *result = responseObject;
//        if ([result[@"Success"] isEqual: @1]) {
//            [self.navigationController popViewControllerAnimated:YES];
//            [ALToastView toastInView:APP_WINDOW withText:@"删除成功"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
}


- (void)cancelEditBond
{
    //还原数据
    self.bondInfo = [storedBondInfo copy];
    [self bindBondInfo:self.bondInfo];
    //切换状态
    [self changeBondViewSatatus:BondView];
    [ALToastView toastInView:APP_WINDOW withText:@"取消编辑状态"];
}

- (void)showCancelEditBondAlert
{
    [self.popComponent hide];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消编辑"
                                                   message:@"确定取消修改?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)updateBond
{
    [[Utils sharedInstance] hideKeyBoard];
    
    NSMutableDictionary *newbondInfo = [self buildNewbondInfo];
    // 简称 这个字段必填
    if ([newbondInfo[@"ShortTitle"] length] == 0) {
        [ALToastView toastInView:self.view withText:@"债券简称必填"];
        return;
    }
    
    NSString *userId = [LoginManager sharedInstance].fetchUserId;

    //如果self.bondInfo 不为空 则 操作为update
    //如果self.bondInfo 为空 则 操作为create
    if (self.bondInfo)
        newbondInfo[@"Id"] = self.bondInfo[@"Id"];
    
    //转成string
    newbondInfo[@"FinanceIndex"] = [[Utils sharedInstance]convertObjectToJSONStr:newbondInfo[@"FinanceIndex"]];
    NSString *bondJsonString = [[Utils sharedInstance]convertObjectToJSONStr:newbondInfo];

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
            break;
        case 1:
            [self.view bringSubviewToFront:self.fc.view];
            break;
        case 2:
            [self.view bringSubviewToFront:self.rc.view];
            break;
        default:
            [self.view bringSubviewToFront:self.bc.view];
            break;
    }
    
    [[Utils sharedInstance] hideKeyBoard];
}

- (void)segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index = [sender.selectedIndexes lastIndex];
    [self changeFormDetail: index];
}

- (void)setUpSegmentedController
{
    NSArray *titles = @[@"基本信息", @"财务指标", @"备注说明"];
    SEL action = @selector(segmentedControlValueChanged:);
    self.segmentedControl = [[QuickDialogHelper sharedInstance]
                             setUpSegmentedControllWithTitles:titles
                             WithSelectedChangedAcion:action
                             WithTarget:self];
    [self.view addSubview:self.segmentedControl];
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

    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:title target:self selector:selector];
    self.navigationItem.rightBarButtonItem = item;
    
    //left button
    if (status == BondEditing) {
        UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"取消" target:self selector:@selector(showCancelEditBondAlert)];
        self.navigationItem.leftBarButtonItem = item;
    } else {
        [self addCustomBackButtonWithTitle:@"返回"];
    }
}

- (void)bindBondInfo: (NSDictionary *)bondInfo
{
    [self.bc bindObject:bondInfo];
    
    NSData *financeData = [bondInfo[@"FinanceIndex"] dataUsingEncoding:NSUTF8StringEncoding];
    id finance = [NSJSONSerialization JSONObjectWithData:financeData options:0 error:nil];
    [self.fc bindObject:finance];
    
    [self.rc bindObject:bondInfo[@"Remark"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpSegmentedController];
    [self.segmentedControl setSelectedIndex:0];
    
    if (self.bondInfo) {
        //保存原始数据
        storedBondInfo = [self.bondInfo copy];
    
        self.title = @"新债详情";
        [self bindBondInfo:self.bondInfo];
        [self setElementsDisabled];
        [self changeBondViewSatatus:BondView];
    } else {
        self.title = @"新债录入";
        [self changeBondViewSatatus:BondCreate];
    }
    
    //bug: 延迟加载 table 信息
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

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
         [self cancelEditBond];
    }
}

@end
