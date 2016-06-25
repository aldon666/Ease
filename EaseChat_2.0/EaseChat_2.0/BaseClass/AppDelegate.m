//
//  AppDelegate.m
//  Chat2
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "EaseChatPrefixHeader.pch"
#import "ZLCGuidePageView.h"
#import "YYClipImageTool.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *rootVC = [RootViewController sharedRootVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarStyle:(UIBarStyleBlack)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarStyle:(UIBarStyleBlack)];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"USERNAME"];
    NSString *password = [user objectForKey:@"PASSWORD"];
    
    // 注册环信SDK
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"andon#chatdemo" apnsCertName:@""];
    
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName
                                                            password:password
                                                          completion:^(NSDictionary *loginInfo, EMError *error) {
                                                          } onQueue:nil];
    }else {
        // 用户验证失败
        [self userAuthenticationFailed];
    }
    
    
    //判断是否为第一次启动，若为第一次启动这执行引导页
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSArray *arr = @[[UIImage imageNamed:@"image1.jpg"],[UIImage imageNamed:@"image2.jpg"],[UIImage imageNamed:@"image3.jpg"],[UIImage imageNamed:@"image4.jpg"],[UIImage imageNamed:@"image5.jpg"]];
        
        ZLCGuidePageView *pageView = [[ZLCGuidePageView alloc]initWithFrame:self.window.frame WithImages:arr];
        //注意若项目是以navigationController为根视图，请讲guidepage添加在根视图view上
        [self.window addSubview:pageView];
    }
    UIImage *image = [UIImage imageNamed:@"xx1.jpg"];
    [YYClipImageTool addToCurrentView:self.window clipImage:image backgroundImage:@""];
    
    //设置一个图片;
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.window.frame.size.width, self.window.frame.size.height)];
    UIImageView *tooView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    tooView.image = [UIImage imageNamed:@"xx2.jpg"];
    niceView.image = [UIImage imageNamed:@"xx1.jpg"];
    
    //添加到场景
    
    [self.window addSubview:tooView];
    [self.window addSubview:niceView];
    //放到最顶层;
    
    [self.window bringSubviewToFront:niceView];
    [self.window bringSubviewToFront:tooView];
    
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    
    niceView.alpha = 0.0;
    tooView.alpha = 0.5;
    [UIView setAnimationDuration:1];
    [UIView setAnimationRepeatCount:24*366*1000000];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    niceView.alpha = 0.5;
    tooView.alpha = 0.0;
    niceView.frame = CGRectMake(0, 0, 414, 736);
    tooView.frame = CGRectMake(0, 0, 414, 736);
    [UIView commitAnimations];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
}




- (void)userAuthenticationFailed {
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    
    UINavigationController * navigationController = (UINavigationController *)self.window.rootViewController;
    
    [navigationController pushViewController:loginVC animated:NO];
    
}


@end
