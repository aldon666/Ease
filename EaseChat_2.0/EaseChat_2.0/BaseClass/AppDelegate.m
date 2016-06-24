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
    
//    [[UINavigationBar appearance] setBarStyle:(UIBarStyleBlack)];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setBarStyle:(UIBarStyleBlack)];
    
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
        [self userAuthenticationFailed];
    }
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
