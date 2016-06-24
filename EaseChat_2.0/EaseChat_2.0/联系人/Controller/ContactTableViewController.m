//
//  ContactTableViewController.m
//  Chat2
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactTableViewCell.h"
#import "ChatViewController.h"
#import "AddViewController.h"

@interface ContactTableViewController ()<EMChatManagerDelegate,EMChatManagerBuddyDelegate,UISearchResultsUpdating,UISearchControllerDelegate>



//搜索控制器控件
@property (retain ,nonatomic)UISearchController *searchController;
//搜索的结果存放的数组
@property (retain ,nonatomic)NSMutableArray *searchResult;
//用来存放所有好友
@property(strong, nonatomic)NSMutableArray *rosters;


@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人";
    //添加按钮
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loninBtoAC)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //初始化数组
    self.rosters = [NSMutableArray new];
    
    
    //注册
    [self.tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    //调用searchController
    //1、初始化（自己的方法）。
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //2、设置属性
    self.searchController.searchBar.frame = CGRectMake(0, 64, 0, 60);
    //默认是YES
    //设置开始搜索时，背景显示与否，默认YES
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //设置开始搜索时，背景是否被掩盖，默认YES
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    //设置开始搜索时，是否隐藏导航栏，默认YES
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    //设置searchBar 为UITableView的头部视图。
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //背景颜色
    self.searchController.searchBar.backgroundColor = [UIColor orangeColor];
    //设置搜索控制器的代理
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    //设置searchBar 位置自适应
    [self.searchController.searchBar sizeToFit];

}

#pragma mark UISearchResultsUpdating 代理协议中的方法
//UISearchController的searchBar中的内容一旦发生变化, 就会调用该方法. 在其中, 我们可以使用NSPredicate来设置搜索过滤的条件.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    
    [self.searchResult removeAllObjects];
    //谓词NSPredicate(用于判断, YES留下,NO 去掉)
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self.username contains[c] %@",self.searchController.searchBar.text];
    
    
    //将筛选的结果存放到搜索结果数组中
    _searchResult = [self.rosters filteredArrayUsingPredicate:searchPredicate].mutableCopy;
    //刷新表格
    [self.tableView  reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //获取好友列表
    [self getFriendList];
}

//获取好友列表
- (void)getFriendList{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",buddyList);
            //移除原先的所有好友
            [self.rosters removeAllObjects];
            [self.rosters addObjectsFromArray:buddyList];
            [self.tableView reloadData];
        }
    } onQueue:nil];
}

//添加好友方法
- (void)loninBtoAC{
    NSLog(@"添加好友");
    AddViewController * addVC = [[AddViewController alloc] init];
    
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (!self.searchController.active)? _rosters.count :self.searchResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    EMBuddy * buddy = _rosters[indexPath.row];
    
    cell.textLabel.text = buddy.username;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    
    EMBuddy * buddy = _rosters[indexPath.row];
    
    chatVC.chatter = buddy.username;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}




//好友请求
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
