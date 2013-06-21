//
//  PlatformProjectViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "PlatformProjectViewController.h"
#import <AKSegmentedControl.h>
#import <PopupListComponent.h>


@interface PlatformProjectViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) PlatformProjectBasicInfoViewController *bc;
@property (strong, nonatomic) PlatformProjectFinancialIndicatorsViewController *fc;
@property (strong, nonatomic) PlatformProjectRemarkViewController *rc;

@property (strong, nonatomic) NSMutableDictionary *platformProject;
@property (nonatomic, strong) PopupListComponent *popComponent;

@end

@implementation PlatformProjectViewController{
    NSDictionary *storedPlatformProject;
}

- (id)initWithPlatformProject: (NSDictionary *)platformProject
{
    if( self = [super init] ) {
        self.platformProject = platformProject[@"ProjectInfo"];
    }
    return self;
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

- (void)bindPlatformProjectInfo: (NSDictionary *)platformProject
{
    [self.bc bindObject:platformProject];
    
    NSData *financeData = [platformProject[@"FinanceIndex"] dataUsingEncoding:NSUTF8StringEncoding];
    id finance = [NSJSONSerialization JSONObjectWithData:financeData options:0 error:nil];
    [self.fc bindObject:finance];
    
    [self.rc bindObject:platformProject[@"Remark"]];
}

- (void)applyToDeleteProject
{
    //todo:apply to delete project
}

- (void)operateProjectInfo: (id)sender
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
                [self changePlatformProjectViewSatatus:PlatformProjectEditing];
                break;
            case 1:
                [self applyToDeleteProject];
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


- (void)setUpNavigationButton: (PlatformProjectEditStaus)status
{
    //right button
    SEL selector  = nil;
    NSString *title = nil;
    if (status == PlatformProjectView) {
        selector = @selector(operateProjectInfo:);
        title = @"操作";
    } else{
        selector = @selector(updateProjectInfo);
        title = @"完成";
    }
    
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:title target:self selector:selector];
    self.navigationItem.rightBarButtonItem = item;
    
    //left button
    if (status == PlatformProjectEditing) {
        UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"取消" target:self selector:@selector(showCancelEditProjectAlert)];
        self.navigationItem.leftBarButtonItem = item;
    } else {
        [self addCustomBackButtonWithTitle:@"返回"];
    }
}


- (void)changePlatformProjectViewSatatus: (PlatformProjectEditStaus)status
{
    switch (status) {
        case PlatformProjectEditing:
            [self.popComponent hide];
            [self setElementsEnable];
            break;
        case PlatformProjectView:
            [self setElementsDisabled];
            break;
        case PlatformProjectCreate:
            [self setElementsEnable];
            break;
    }
    
    [self setUpNavigationButton: status];
    [self.bc.quickDialogTableView reloadData];
    [self.fc.quickDialogTableView reloadData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"平台项目录入";
    
    [self setUpSegmentedController];
    [self.segmentedControl setSelectedIndex:0];
    
    if (self.platformProject) {
        //保存原始数据
        storedPlatformProject = [self.platformProject copy];
     
        self.title = @"项目详情";
        [self bindPlatformProjectInfo:self.platformProject];
        [self setElementsDisabled];
        [self changePlatformProjectViewSatatus:PlatformProjectView];
    } else {
        self.title = @"平台项目录入";
        [self changePlatformProjectViewSatatus:PlatformProjectCreate];
    }
    
    RunBlockAfterDelay(.3, ^{
        [self.view addSubview:self.bc.view];
        [self.view addSubview:self.fc.view];
        [self.view addSubview:self.rc.view];
        
        [self changeFormDetail:0];
    });

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



- (NSMutableDictionary *)buildPlatformProjectInfo
{
    NSMutableDictionary *platformProject = [self.bc fetchData];
    platformProject[@"FinanceIndex"] = [self.fc fetchData] ;
    platformProject[@"Remark"] = [self.rc fetchData];
    
    return platformProject;
}

- (void)updateProjectInfo
{
    [[Utils sharedInstance] hideKeyBoard];
    
    NSMutableDictionary *platformProject = [self buildPlatformProjectInfo];
    // 简称 这个字段必填
    if ([platformProject[@"Subject"] length] == 0) {
        [ALToastView toastInView:self.view withText:@"融资主体必填"];
        return;
    }
    
    NSString *userId = [LoginManager sharedInstance].fetchUserId;
    
    //如果self.project 不为空 则 操作为update
    //如果self.project 为空 则 操作为create
    if (self.platformProject)
        platformProject[@"Id"] = self.platformProject[@"Id"];
    
    //转成string
    platformProject[@"FinanceIndex"] = [[Utils sharedInstance] convertObjectToJSONStr:platformProject[@"FinanceIndex"]];
    NSString *projectJsonString = [[Utils sharedInstance] convertObjectToJSONStr:platformProject];
    
    NSDictionary *parameters = @{@"userid": userId, @"platformproject": projectJsonString};
    
    [[PMHttpClient shareIntance] postPath:UPDATE_PLATFORMPROJECT_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"Success"] isEqual: @1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [ALToastView toastInView:APP_WINDOW withText:@"提交成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ALToastView toastInView:APP_WINDOW withText:@"网络问题，提交失败"];
    }];
    
}


- (void)cancelEditProject
{
    //还原数据
    self.platformProject = [storedPlatformProject copy];
    [self bindPlatformProjectInfo: self.platformProject];
    //切换状态
    [self changePlatformProjectViewSatatus:PlatformProjectView];
    [ALToastView toastInView:APP_WINDOW withText:@"取消编辑状态"];
}

- (void)showCancelEditProjectAlert
{
    [self.popComponent hide];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消编辑"
                                                   message:@"确定取消修改?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    [alert show];
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self cancelEditProject];
    }
}


@end
