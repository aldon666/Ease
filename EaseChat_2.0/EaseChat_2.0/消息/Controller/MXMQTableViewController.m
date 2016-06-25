//
//  MXMQTableViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/16.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "MXMQTableViewController.h"
#import "MXMQTableViewCell.h"
#import "ChatViewController.h"
#import "YYClipImageTool.h"


@interface MXMQTableViewController ()<EMChatManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSMutableArray *rosters;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation MXMQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化数组
    self.rosters = [NSMutableArray new];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"MXMQTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIImage *image = [UIImage imageNamed:@"xx1.jpg"];
    [YYClipImageTool addToCurrentView:self.view clipImage:image backgroundImage:@""];
    
    self.view.backgroundColor = [UIColor clearColor];
    // self.view.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"snowbg.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    
    //方法每秒钟调用60次
    /*
     CADisplayLink用来重绘，绘图
     NSTimer用于计时，重复调用
     
     */
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleAction:)];
    //
    //    self.displayLink.frameInterval = 0.5;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.displayLink invalidate];
    self.displayLink = nil;
}
- (void)handleAction:(CADisplayLink *)displayLink{
    
    UIImage *image = [UIImage imageNamed:@"樱花瓣2"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat scale = arc4random_uniform(100) / 100.0;
    imageView.transform = CGAffineTransformMakeScale(scale, scale);
    CGSize winSize = self.view.bounds.size;
    CGFloat x = arc4random_uniform(winSize.width);
    CGFloat y = - imageView.frame.size.height;
    imageView.center = CGPointMake(x, y);
    
    [self.view addSubview:imageView];
    [UIView animateWithDuration:arc4random_uniform(10) animations:^{
        CGFloat toX = arc4random_uniform(winSize.width);
        CGFloat toY = imageView.frame.size.height * 0.5 + winSize.height;
        
        imageView.center = CGPointMake(toX, toY);
        imageView.transform = CGAffineTransformRotate(imageView.transform, arc4random_uniform(M_PI * 2));
        
        imageView.alpha = 15;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
  }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.tabBarController.title = @"消息";
    
    [self reloadConversations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

/**
 *  数据刷新方法
 */
- (void)reloadConversations {
    [self.rosters removeAllObjects];
    [self.rosters addObjectsFromArray:[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES]];
    [self.tableView reloadData];
}


#pragma ChatManager Delegate

/**
 *  收到信息的回调方法
 */

- (void)didReceiveMessage:(EMMessage *)message {
    
    [self reloadConversations];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _rosters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXMQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    EMBuddy * buddy = _rosters[indexPath.row];
//    
//    cell.textLabel.text = buddy.username;
////    cell.textLabel.text = @"测试数据";
    
    EMConversation *conversation = self.rosters[indexPath.row];
    cell.textLabel.text = conversation.chatter;                   
    EMMessage *message = [conversation latestMessage];
    EMTextMessageBody *body = [message.messageBodies lastObject];
    cell.detailTextLabel.text = body.text;
  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ChatViewController * chatVC = [[ChatViewController alloc] init];
    
//    EMBuddy * buddy = _rosters[indexPath.row];
//    
//    chatVC.chatter = buddy.username;
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    
    EMConversation *conversation = self.rosters[indexPath.row];
    
    chatVC.chatter = conversation.chatter;
    
    
    
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        
        EMConversation *conversation = self.rosters[indexPath.row];
        
        chatVC.chatter = conversation.chatter;

        [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatVC.chatter deleteMessages:YES append2Chat:YES];
        NSLog(@"删除成功");
        [self.rosters removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    return @[action1];
}


- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的好友请求 !", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        EMError *error;
        
        //同意好友请求的方法
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            NSLog(@"发送同意成功");
        }
        
    }];
    
    UIAlertAction *refuse = [UIAlertAction actionWithTitle:@"叔叔不约" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        EMError *error;
        
        //拒绝好友请求的方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"叔叔不约" error:&error] && !error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    
    [alert addAction:action];
    [alert addAction:refuse];
    
    [self showDetailViewController:alert sender:nil];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
