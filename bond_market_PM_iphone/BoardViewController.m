//
//  BoardViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "BoardViewController.h"
#import "NewBondViewController.h"

@interface BoardViewController () 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@end

@implementation BoardViewController

- (IBAction)createBond:(id)sender
{
    NewBondViewController *nc = [[NewBondViewController alloc]init];
    [self.navigationController pushViewController:nc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"nav-logo"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollview.scrollEnabled = YES;
    self.scrollview.contentSize = CGSizeMake(320.0f, 648.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
