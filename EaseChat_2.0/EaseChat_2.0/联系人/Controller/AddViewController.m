//
//  AddViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/15.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "AddViewController.h"
#import "EaseChatPrefixHeader.pch"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *rosterUserNameTF;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addFriendButtonAction:(UIButton *)sender {
    EMError *error;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_rosterUserNameTF.text message:@"快餐80,包夜200" error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
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
