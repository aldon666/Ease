//
//  ChatViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/18.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatConsoleView.h"
#import <EaseMob.h>

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource,EMChatManagerDelegate>

@property (strong, nonatomic) UITableView *chatTableView;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) ChatConsoleView *chatConsoleView;
@property (strong, nonatomic) NSLayoutConstraint *hahaha;


@end

@implementation ChatViewController

@synthesize chatTableView, conversation, chatConsoleView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKey)];
    
    [self.view addGestureRecognizer:tap];
    
    self.title = self.chatter;
    
    [chatTableView setAllowsSelection:NO];
    
    
    [self registerForKeyboardNotifications];
    
    chatConsoleView = [[ChatConsoleView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40)];
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40 - 64) style:UITableViewStylePlain];
    
    

    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    [self.view addSubview:chatTableView];
   
    __weak typeof(self) weakSelf = self;
    
    chatConsoleView.buttonClicked = ^(NSString * draftText){
        
        [weakSelf sendMessageWithDraftText:draftText];
    };
    
    [self.view addSubview:chatConsoleView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    

    
    
    [self reloadChatRecords];
}
//手势隐藏键盘
- (void)closeKey{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 移除通知中心
    [self removeForKeyboardNotifications];
    
    // 移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


# pragma mark - Send Message
/**
 *  使用草稿发送一条信息
 *
 *  @param draftText 草稿
 */
- (void)sendMessageWithDraftText:(NSString *)draftText {
    
    EMChatText * chatText = [[EMChatText alloc] initWithText:draftText];
    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    // 生成message
    EMMessage * message = [[EMMessage alloc] initWithReceiver:self.chatter bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        
        // 准备发送
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        
        [self reloadChatRecords];
        // 发送完成
    } onQueue:dispatch_get_main_queue()];
}

# pragma mark - Receive Message
/**
 *  当收到了一条消息时
 *
 *  @param message 消息构造体
 */
- (void)didReceiveMessage:(EMMessage *)message {
    
    [self reloadChatRecords];
}

# pragma mark - Reload Chat Records
/**
 *  重新加载TableView上面显示的聊天信息, 并移动到最后一行
 */
- (void)reloadChatRecords {
    
    conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.chatter conversationType:eConversationTypeChat];
    
    [chatTableView reloadData];
    
    if ([conversation loadAllMessages].count > 0) {
        
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[conversation loadAllMessages].count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}

# pragma mark - Keyboard Method
/**
 *  注册通知中心
 */
- (void)registerForKeyboardNotifications
{
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  移除通知中心
 */
- (void)removeForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  键盘将要弹出
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillShow:(NSNotification *)notification {
    
    self.chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 310);
    
    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];

    
    NSDictionary * info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f", keyboardSize.height);
    
    //输入框位置动画加载
    [self begainMoveUpAnimation:keyboardSize.height];
}

/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillHide:(NSNotification *)notification {
    
    
    [self begainMoveUpAnimation:0];
    self.chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];

}

/**
 *  开始执行键盘改变后对应视图的变化
 *
 *  @param height 键盘的高度
 */

- (void)begainMoveUpAnimation:(CGFloat)height {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [chatConsoleView setFrame:CGRectMake(0, self.view.frame.size.height - (height + 40), chatConsoleView.frame.size.width, chatConsoleView.frame.size.height)];
    }];
    
    [self.hahaha setConstant:height + 40];
    
    [chatTableView layoutIfNeeded];
    
    if ([conversation loadAllMessages].count > 1) {
        
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

# pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return conversation.loadAllMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];
    
    EMMessage * message = conversation.loadAllMessages[indexPath.row];
    
    EMTextMessageBody * body = [message.messageBodies lastObject];
    
    if ([message.to isEqualToString:self.chatter]) {
        
        cell.textLabel.text = body.text;
        cell.detailTextLabel.text = @"";
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        
    } else {
        
        cell.textLabel.text = body.text;
        cell.detailTextLabel.text = @"";
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
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
