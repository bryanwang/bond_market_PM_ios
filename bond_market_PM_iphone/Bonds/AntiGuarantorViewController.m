//
//  AntiGuarantorViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "AntiGuarantorViewController.h"

@interface AntiGuarantorViewController ()

@end

@implementation AntiGuarantorViewController

- (void)AntiGuarantor
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"担保保证";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem redBarButtonItemWithtitle:@"完成"  target:self selector:@selector(AntiGuarantor)];
    
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"AntiGuarantorDataBuilder" andData:nil];
    [self setupQuickDialogControllerWithRoot:root];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
