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

@interface BoardViewController ()
@property (strong, nonatomic) IBOutlet UIView *board45;
@property (strong, nonatomic) IBOutlet UIView *board44;

@property (weak, nonatomic) IBOutlet UILabel *totalEntryFee;
@property (weak, nonatomic) IBOutlet UILabel *totalDeductFee;
@property (weak, nonatomic) IBOutlet UILabel *totalEntryCount;
@property (weak, nonatomic) IBOutlet UILabel *totalDeductCount;

@end

@implementation BoardViewController

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
    
//    NSArray* fontArrays = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    for(NSString* temp in fontArrays) {
//        NSLog(@"Font name  = %@", temp);
//    }
    
    [self.totalDeductFee setFont:[UIFont fontWithName:CONDENSED_FONT size:36.0f]];
    [self.totalEntryFee setFont:[UIFont fontWithName:CONDENSED_FONT size:36.0f]];
    [self.totalEntryCount setFont:[UIFont fontWithName:CONDENSED_FONT size:22.0f]];
    [self.totalDeductCount setFont:[UIFont fontWithName:CONDENSED_FONT size:22.0f]];
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
    // Dispose of any resources that can be recreated.
}

@end
