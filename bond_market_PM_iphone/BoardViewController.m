//
//  BoardViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BoardViewController.h"
#import "NewBondViewController.h"
#import "MyBondsViewController.h"
#import "NewPlatformProjectViewController.h"
#import "NewNonPlatformProjectViewController.h"
#import "NonPlatformProjectsViewController.h"

@interface BoardViewController () <UIActionSheetDelegate> {
    UIActionSheet *createProjectActionSheet;
    UIActionSheet *viewProjectActionSheet;
}
@property (strong, nonatomic) IBOutlet UIView *board45;
@property (strong, nonatomic) IBOutlet UIView *board44;

@property (weak, nonatomic) IBOutlet UILabel *inputCount;
@property (weak, nonatomic) IBOutlet UILabel *inputBonus;
@property (weak, nonatomic) IBOutlet UILabel *estimateCount;
@property (weak, nonatomic) IBOutlet UILabel *estimateBonus;

@end

@implementation BoardViewController

- (void)showPlatformProjects
{
    
}

- (void)showNonPlatFormPorjects
{
    NonPlatformProjectsViewController *nc = [[NonPlatformProjectsViewController alloc] init];
    [self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)showProjectActionSheet:(id)sender
{
    viewProjectActionSheet = [[UIActionSheet alloc]
                                initWithTitle:@"项目查看"
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"平台项目", @"非平台项目",nil];
    viewProjectActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [viewProjectActionSheet showInView:self.view];
}

- (void)createNonPlatformProject
{
    NewNonPlatformProjectViewController *nc = [[NewNonPlatformProjectViewController alloc]init];
    [self.navigationController pushViewController:nc animated:YES];
}

- (void)createPlatformProject
{
    NewPlatformProjectViewController *nc = [[NewPlatformProjectViewController alloc]init];
    [self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)createProject:(id)sender {
    createProjectActionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"项目录入"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"平台项目", @"非平台项目",nil];
    createProjectActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [createProjectActionSheet showInView:self.view];
}


- (IBAction)createBond:(id)sender
{
    NewBondViewController *nc = [[NewBondViewController alloc]init];
    [self.navigationController pushViewController:nc animated:YES];
}


- (IBAction)showMybonds:(id)sender
{
    MyBondsViewController *bc = [[MyBondsViewController alloc]init];
    [self.navigationController pushViewController:bc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IPHONE_5) {
        SET_VIEW_Y(self.board45, 150.0f);
        [self.view addSubview:self.board45];
    } else {
        SET_VIEW_Y(self.board44, 150.0f);
        [self.view addSubview:self.board44];
    }
    
    [self.inputBonus setFont:[UIFont BertholdFontOfSize:36]];
    [self.estimateBonus setFont:[UIFont BertholdFontOfSize:36]];
    [self.estimateCount setFont:[UIFont BertholdFontOfSize:22]];
    [self.inputCount setFont:[UIFont BertholdFontOfSize:22]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav-logo"]];
    logo.tag = 10001;
    SET_VIEW_X(logo, 10.0f);
    SET_VIEW_Y(logo, 10.0f);
    [self.navigationController.navigationBar addSubview:logo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *logo = [self.navigationController.navigationBar viewWithTag:10001];
    [logo removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:createProjectActionSheet]) {
        if (buttonIndex == 0) {
            [self createPlatformProject];
        } else if (buttonIndex == 1) {
            [self createNonPlatformProject];
        }
    }
    else {
        if(buttonIndex == 0)
           [self showPlatformProjects];
        else
            [self showNonPlatFormPorjects];
    }
}

@end
