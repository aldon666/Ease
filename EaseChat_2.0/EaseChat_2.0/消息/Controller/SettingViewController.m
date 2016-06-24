//
//  SettingViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/20.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//退出登录
- (IBAction)logOffAction:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认注销登录吗" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
        if (!error && info) {
            //关闭自动登录
            [[EaseMob sharedInstance].chatManager disableAutoLogin];
            NSLog(@"退出成功");
            LoginViewController *lo = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:lo animated:YES];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
