//
//  CXRSplitController.m
//  Chat
//
//  Created by lanou3g on 16/6/12.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "CXRSplitController.h"
#import "RootViewController.h"
//#import "ChatTableViewController.h"
#import "MXMQTableViewController.h"
#import "ContactTableViewController.h"
#import "JKSideSlipView.h"

@interface CXRSplitController ()

@property(strong, nonatomic)UITabBarController *tabBarController;

@end

@implementation CXRSplitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新建一个tabBarController
    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    //将tabBarController交给 CXRSplitController 进行管理
    [self addChildViewController:tabBarController];
    [self.view addSubview:tabBarController.view];
    
    self.tabBarController = tabBarController;
    
//    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
    //给tabBarController 添加三个viewController
    MXMQTableViewController * mxmqController = [[MXMQTableViewController alloc] init];
    [self setItemImageWithController:mxmqController image:@"消息" selectImage:@"消息1" title:@"消息"];
    
    ContactTableViewController * messageController = [[ContactTableViewController alloc] init];
    [self setItemImageWithController:messageController image:@"联系人" selectImage:@"联系人1" title:@"好友"];
    

    
    /**
     *  在这里，我们给tabBarController 添加拖动手势
     *
     *  @return
     */
    
//    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    //添加手势到 tabBarController.view
//    [tabBarController.view addGestureRecognizer:panRecognizer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  设置tabBar的样式
 *
 *  @param viewCotroller 添加模块的ViewController
 *  @param image         设置平常样式图片
 *  @param selectImage   设置显示样式图片
 *  @param title         设置标题名称
 */

- (void)setItemImageWithController:(UIViewController *)viewCotroller image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title {
    
    viewCotroller.title = title;
    

    viewCotroller.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewCotroller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
#pragma mark - 把 UINavigationController 添加到TabBarController 进行管理
    
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:viewCotroller];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"ceshi" style:UIBarButtonItemStylePlain target:self action:@selector(clickHeadImage:)];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [user objectForKey:@"USERIMAGE"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 20;
    [leftBtn addTarget:self action:@selector(clickHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    viewCotroller.navigationItem.leftBarButtonItem = leftButton;
    navController.navigationBar.translucent = NO;
    navController.title = title;
    
    [self.tabBarController addChildViewController:navController];
}


- (void)clickHeadImage:(UIBarButtonItem *)sender {
    RootViewController *rootVC = [RootViewController sharedRootVC];
    NSLog(@"%p", rootVC);
    [rootVC.sideSlipView switchMenu];
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
