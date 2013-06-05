//
//  BYQuickDialogWrappedViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BYQuickDialogWrappedViewController.h"

@interface BYQuickDialogWrappedViewController ()

@end

@implementation BYQuickDialogWrappedViewController

- (BYQuickDialogWrappedViewController *)initWithRoot:(QRootElement *)rootElement
{
    self = [super init];
    if (self) {
        self.qc = [[BYBaseQuickDialogViewController alloc]initWithRoot:rootElement];
        UIView *bv = [[UIView alloc]initWithFrame:self.view.bounds];
        bv.backgroundColor = RGBCOLOR(224, 221, 215);
        self.qc.quickDialogTableView.backgroundView =bv;
        self.qc.view.frame = self.view.bounds;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.qc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
