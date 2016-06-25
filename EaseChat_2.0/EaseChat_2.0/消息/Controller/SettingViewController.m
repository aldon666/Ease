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
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
