//
//  LoginViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/15.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()
{
    NSMutableArray *_arr;
    
}

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)onTimer
{
    UIImageView *snow=nil;
    
    if (_arr.count>0) {
        //取雪花
        snow=[_arr firstObject];
        [_arr removeObject:snow];
    }else{
        //创建雪花
        snow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"雪花"]];
        [self.view addSubview:snow];
        //[snow release];
        
    }
    snow.frame=CGRectMake(arc4random()%(320-50+1), -50, 50, 50);
    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(snow)];
    [UIView setAnimationDuration:5];
    snow.frame=CGRectMake(arc4random()%(320-50+1), 736, 50, 50);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
    
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *snow=(__bridge UIImageView *)context;
    
    [_arr addObject:snow];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[UIColor blackColor];
    _arr=[[NSMutableArray alloc]initWithCapacity:0];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}
//登录按钮的响应事件
- (IBAction)loginButtonAction:(UIButton *)sender {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:_userNameTF.text forKey:@"USERNAME"];
    [user setObject:_passwordTF.text forKey:@"PASSWORD"];
    NSString *userName = [user objectForKey:@"USERNAME"];
    NSString *password = [user objectForKey:@"PASSWORD"];
        __weak typeof(self) weakSelf = self;
    
    // 用户登录的异步Block方法
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
            [weakSelf autoLogin];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"登陆成功");
        } else {
            
            // 显示错误信息的警告
            [weakSelf showAlertControllerWithError:error];
        }
    } onQueue:dispatch_get_main_queue()];
   

}

- (void)autoLogin{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setObject:_userNameTF.text forKey:@"USERNAME"];
//    [user setObject:_passwordTF.text forKey:@"PASSWORD"];
//    NSString *userName = [user objectForKey:@"USERNAME"];
//    NSString *password = [user objectForKey:@"PASSWORD"];
    [[EaseMob sharedInstance].chatManager enableAutoLogin];
//    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
//    if (isAutoLogin) {
//        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName
//                                                            password:password
//                                                          completion:^(NSDictionary *loginInfo, EMError *error) {
//                                                          } onQueue:nil];
//    }
}


//注册按钮的响应事件
- (IBAction)registButtonAction:(UIButton *)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    
     [self presentViewController:registerVC animated:YES completion:nil];
    
}
//点击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}
// 显示警告控制器使用一个错误信息
# pragma mark - Error Alert Controller
- (void)showAlertControllerWithError:(EMError *)error {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:actionCancel];
    
    [self showDetailViewController:alertController sender:nil];
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
