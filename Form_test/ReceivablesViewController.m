//
//  ReceivablesViewController.m
//  Form_test
//
//  Created by Bruce yang on 13-5-29.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "ReceivablesViewController.h"

@interface ReceivablesViewController ()

@end

@implementation ReceivablesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleEquityAddButtonTapped: (QElement *)element
{
    QRootElement *root = self.root;
    QSection  *section = [root getSectionForIndex:0];
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"应收账款对象"];
    [section insertElement:e1 atIndex: section.elements.count - 1];
    [self.quickDialogTableView reloadData];
}

@end
