//
//  LoginViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "LoginViewController.h"
#import "BoardViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIView *loginPanel;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnlogin;
@property (weak, nonatomic) IBOutlet UIButton *btnforget;
@property (weak, nonatomic) IBOutlet UIButton *btnregister;
@property (strong, nonatomic) IBOutlet UIImageView *bgnormal;
@property (strong, nonatomic) IBOutlet UIImageView *bgrentina;

@end

@implementation LoginViewController

- (IBAction)login:(id)sender {
    NSString *mobile = self.mobile.text;
    NSString *password = self.password.text;
    
    BoardViewController *bc = [[BoardViewController alloc]initWithNibName:@"BoardViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:bc];
    [self presentViewController:nc animated:YES completion:nil];

//    NSDictionary *params = @{@"mobile": mobile, @"pwd": password, @"role": @"1"};
//    [[PMHttpClient shareIntance]postPath:LOGIN_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *result = (NSDictionary *)responseObject;
//        if ([result[@"Account"][@"Role"] integerValue] == 1) {
//            //save mobile
//            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:USER_DEFAULTS_MOBILE_KEY];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            BoardViewController *bc = [[BoardViewController alloc]initWithNibName:@"BoardViewController" bundle:nil];
//            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:bc];
//            [self presentViewController:nc animated:YES completion:nil];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
}

- (void)viewTapped: (id)sender
{
    [[Utils sharedInstance] hideKeyBoard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tap];
    
    if (IS_IPHONE_5) {
        [self.view addSubview:self.bgrentina];
        SET_VIEW_Y(self.loginPanel, 180.0f);
    }
    else {
        [self.view addSubview:self.bgnormal];
        SET_VIEW_Y(self.loginPanel, 100.0f);
    }
    
    [self.view addSubview:self.loginPanel];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_MOBILE_KEY];
    if (mobile)
        self.mobile.text = mobile;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
