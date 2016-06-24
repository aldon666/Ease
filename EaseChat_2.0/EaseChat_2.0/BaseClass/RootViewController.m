//
//  RootViewController.m
//  Chat
//
//  Created by lanou3g on 16/6/12.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "RootViewController.h"
#import "CXRSplitController.h"
#import "MenuView.h"
#import <EaseMob.h>

#import "LoginViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "WeatherViewController.h"
@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate,EMChatManagerBuddyDelegate>


@property(strong, nonatomic)UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *conversations;


@end

@implementation RootViewController

+(instancetype)sharedRootVC{
    static RootViewController *rootVC = nil;
    if (rootVC == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            rootVC = [[RootViewController alloc]init];
        });
    }
    return rootVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CXRSplitController * splitViewController = [[CXRSplitController alloc] init];
    //将splitViewController的控制器和根视图都交由跟控制器进行管理
    [self addChildViewController:splitViewController];
    [self.view addSubview:splitViewController.view];
    
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self];
    
    _sideSlipView.backgroundColor = [UIColor redColor];
    
    MenuView *menu = [MenuView menuView];
    
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        NSLog(@"click");
        [_sideSlipView hide];
        if (indexPath.row == 0) {
            NSLog(@"我的二维码");
        }
        if (indexPath.row == 1) {
            WeatherViewController *weatherVC = [[WeatherViewController alloc]init];
            [self.navigationController pushViewController:weatherVC animated:YES];
        }
        if (indexPath.row == 2) {
            NSLog(@"我的相册");
        }
        if (indexPath.row == 3) {
            NSLog(@"我的文件");
        }
        if (indexPath.row == 4) {
            SettingViewController *setVC = [[SettingViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }];
    menu.items = @[@{@"title":@"我的二维码",@"imagename":@"二维码"},@{@"title":@"天气",@"imagename":@"钱包"},@{@"title":@"我的相册",@"imagename":@"相册"},@{@"title":@"我的文件",@"imagename":@"文件"},@{@"title":@"我的设置",@"imagename":@"设置"}];
    
    [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
    
    self.messageTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _conversations = [NSMutableArray new];
    
}



- (void)switchTouched{
    [_sideSlipView switchMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.tabBarController.title = @"消息";
    
    [self reloadConversations];
}

# pragma mark - reload Conversations
/**
 *  刷新数据的方法
 */
- (void)reloadConversations {
    
    [_conversations removeAllObjects];
    
    [_conversations addObjectsFromArray:[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES]];
    
    [_messageTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


# pragma mark - Chat Manager Delegate
/**
 *  当收到信息时的回调方法
 *
 *  @param message 信息构造体
 */
- (void)didReceiveMessage:(EMMessage *)message {
    
    [self reloadConversations];
}

# pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    EMConversation * conversation = _conversations[indexPath.row];
    
    cell.textLabel.text = conversation.chatter;
    
    EMMessage * message = [conversation latestMessage];
    
    EMTextMessageBody * body = [message.messageBodies lastObject];
    
    cell.detailTextLabel.text = body.text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    
    EMConversation *conversation = _conversations[indexPath.row];
    
    chatVC.chatter = conversation.chatter;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

# pragma mark - Receive Buddy
/**
 *  当收到好友请求的回调方法
 *
 *  @param username 来自请求的账号
 *  @param message  携带的请求信息
 */
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
        
        EMError * error;
        
        // 同意好友请求的方法
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            
            NSLog(@"发送同意成功");
        }
    }];
    
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"滚" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        EMError * error;
        
        // 拒绝好友请求的方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"滚, 快滚!" error:&error] && !error) {
            
            NSLog(@"发送拒绝成功");
        }
        
    }];
    
    [alertController addAction:acceptAction];
    [alertController addAction:rejectAction];
    
    [self showDetailViewController:alertController sender:nil];
    
}












/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username{
    
}

/*!
 @method
 @brief 好友请求被拒绝时的回调
 @discussion
 @param username 之前发出的好友请求被用户username拒绝了
 */
- (void)didRejectedByBuddy:(NSString *)username{
    
}

/*!
 @method
 @brief 接受好友请求成功的回调
 @discussion
 @param username 登录用户接受了"username发过来的好友请求"成功的回调
 */
- (void)didAcceptBuddySucceed:(NSString *)username{
    
}

/*!
 @method
 @brief 登录的用户被好友从列表中删除了
 @discussion
 @param username 删除的好友username
 */
- (void)didRemovedByBuddy:(NSString *)username{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
