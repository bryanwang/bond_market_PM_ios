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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollview.scrollEnabled = YES;
    self.scrollview.contentSize = CGSizeMake(320.0f, 648.0f);

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
