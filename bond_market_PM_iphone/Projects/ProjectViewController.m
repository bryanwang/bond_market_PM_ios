//
//  ProjectViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectBasicInfoViewController.h"
#import "ProjectFinancialIndicatorsViewController.h"
#import "ProjectRemarkViewController.h"
#import "PopupListComponent.h"
#import <AKSegmentedControl.h>


@interface ProjectViewController (){
    NSDictionary *storedProject;
}
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) ProjectBasicInfoViewController *bc;
@property (strong, nonatomic) ProjectFinancialIndicatorsViewController *fc;
@property (strong, nonatomic) ProjectRemarkViewController *rc;

@property (strong, nonatomic)NSMutableDictionary *project;
@property (nonatomic, strong)PopupListComponent *popComponent;

@end

@implementation ProjectViewController

- (id)initWithProject:(NSDictionary *)project
{
    if( self = [super init] ) {
        self.project = project[@"ProjectInfo"];
    }
    return self;
}

- (ProjectBasicInfoViewController *)bc
{
    if (_bc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ProjectBasicDataBuilder" andData:nil];
        _bc = [[ProjectBasicInfoViewController alloc]initWithRoot:root];
        _bc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _bc;
}

- (ProjectFinancialIndicatorsViewController *)fc
{
    if (_fc == nil) {
        QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"ProjectFinanceDataBuilder" andData:nil];
        _fc = [[ProjectFinancialIndicatorsViewController alloc]initWithRoot:root];
        _fc.view.frame = CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 88.0f);
    }
    return _fc;
}

- (ProjectRemarkViewController *)rc
{
    if (_rc == nil) {
        _rc = [[ProjectRemarkViewController alloc]init];
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
            [self.popComponent hide];
            [self setElementsEnable];
            break;
        case ProjectView:
            [self setElementsDisabled];
            break;
        case ProjectCreate:
            [self setElementsEnable];
            break;
    }
    
    [self setUpNavigationButton: status];
    [self.bc.quickDialogTableView reloadData];
    [self.fc.quickDialogTableView reloadData];
}


- (void)cancelEditProject
{
    //还原数据
    self.project = [storedProject copy];
    [self bindProjectInfo: self.project];
    //切换状态
    [self changeProjectViewSatatus:ProjectView];
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


- (NSMutableDictionary *)buildProjectInfo
{
    NSMutableDictionary *project = [self.bc fetchData];
    project[@"FinanceIndex"] = [self.fc fetchData] ;
    project[@"Remark"] = [self.rc fetchData];
    
    return project;
}

- (void)updateProjectInfo
{
    [self hideKeyBoard];
    
    NSMutableDictionary *project = [self buildProjectInfo];
    // 简称 这个字段必填
    if ([project[@"Subject"] length] == 0) {
        [ALToastView toastInView:self.view withText:@"融资主体必填"];
        return;
    }
    
    NSString *userId = [LoginManager sharedInstance].fetchUserId;
    
    //如果self.project 不为空 则 操作为update
    //如果self.project 为空 则 操作为create
    if (self.project)
        project[@"Id"] = self.project[@"Id"];
    
    //转成string
    project[@"FinanceIndex"] = [[QuickDialogHelper sharedInstance]convertObjectToJSONStr:project[@"FinanceIndex"]];
    NSString *projectJsonString = [[QuickDialogHelper sharedInstance]convertObjectToJSONStr:project];
    
    NSDictionary *parameters = @{@"userid": userId, @"project": projectJsonString};
    
    [[PMHttpClient shareIntance] postPath:UPDATE_PROJECT_INTERFACE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"Success"] isEqual: @1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [ALToastView toastInView:APP_WINDOW withText:@"提交成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ALToastView toastInView:APP_WINDOW withText:@"网络问题，提交失败"];
    }];

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
                [self changeProjectViewSatatus:ProjectEditing];
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


- (void)setUpNavigationButton: (ProjectEditStaus)status
{
    //right button
    SEL selector  = nil;
    NSString *title = nil;
    if (status == ProjectView) {
        selector = @selector(operateProjectInfo:);
        title = @"操作";
    } else{
        selector = @selector(updateProjectInfo);
        title = @"完成";
    }
    
    UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:title target:self selector:selector];
    self.navigationItem.rightBarButtonItem = item;
    
    //left button
    if (status == ProjectEditing) {
        UIBarButtonItem *item = [UIBarButtonItem redBarButtonItemWithtitle:@"取消" target:self selector:@selector(showCancelEditProjectAlert)];
        self.navigationItem.leftBarButtonItem = item;
    } else {
        [self addCustomBackButtonWithTitle:@"返回"];
    }
}

- (void)bindProjectInfo: (NSDictionary *)project
{
    [self.bc bindObject:project];
    
    NSData *financeData = [project[@"FinanceIndex"] dataUsingEncoding:NSUTF8StringEncoding];
    id finance = [NSJSONSerialization JSONObjectWithData:financeData options:0 error:nil];
    [self.fc bindObject:finance];
    
    [self.rc bindObject:project[@"Remark"]];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"非平台项目录入";
    
    [self setUpSegmentedController];
    [self.segmentedControl setSelectedIndex:0];
    
    if (self.project) {
        //保存原始数据
        storedProject = [self.project copy];
        
        self.title = @"项目详情";
        [self bindProjectInfo:self.project];
        [self setElementsDisabled];
        [self changeProjectViewSatatus:ProjectView];
    } else {
        self.title = @"非平台项目录入";
        [self changeProjectViewSatatus:ProjectCreate];
    }
    
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
        [self cancelEditProject];
    }
}

@end
