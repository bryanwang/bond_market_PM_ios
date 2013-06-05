//
//  CreateTrustWaysViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "CreateTrustWaysViewController.h"
#import "TrustWaysViewController.h"

@interface CreateTrustWaysViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *noitemTips;

@end

@implementation CreateTrustWaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"增信方式";
    
    [self setUpLeftNavigationButton];
    //todo: 判断是有已经增添过增信方式 显示
}

-  (void)addTrustWay
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"TrutWaysDataBuilder" andData:nil];
    TrustWaysViewController *tc = [[TrustWaysViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:tc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];
}

- (void)setUpLeftNavigationButton
{
    UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"] highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"] target:self selector:@selector(addTrustWay)];
    ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)(item.customView)) setTitle:@"新增" forState:UIControlStateNormal];
    [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
    
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
