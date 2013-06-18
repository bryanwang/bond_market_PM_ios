//
//  LoginViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-3.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "LoginViewController.h"
#import "BoardViewController.h"
#import "define.h"

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
    [self hideKeyBoard];
    
    NSString *mobile = self.mobile.text;
    NSString *password = self.password.text;
    
    if ([mobile trim].length == 0 || [password trim].length == 0) {
        [ALToastView toastInView:APP_ROOT_VIEW withText:@"手机号密码不能为空!"];
        return;
    }
    
    NSDictionary *params = @{@"mobile": mobile, @"pwd": password, @"role": @"1"};
    [[PMHttpClient shareIntance]postPath:LOGIN_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary *account = result[@"Account"];
        //user is pm
        if (account && [account[@"Role"] integerValue] == 1) {
            [[LoginManager sharedInstance] saveLoginUserInfo:account];
            
            BoardViewController *bc = [[BoardViewController alloc]initWithNibName:@"BoardViewController" bundle:nil];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:bc];
            [self presentViewController:nc animated:YES completion:nil];
        }
        else {
            [ALToastView toastInView:APP_ROOT_VIEW withText:@"登录失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //todo: 
    }];
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
    
    NSString *mobile = [[LoginManager sharedInstance] fetchUserMobile];
    if (mobile)
        self.mobile.text = mobile;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
