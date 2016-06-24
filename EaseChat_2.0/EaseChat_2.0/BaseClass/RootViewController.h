//
//  RootViewController.h
//  Chat2
//  Chat
//
//  Created by lanou3g on 16/6/12.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSideSlipView.h"
@interface RootViewController : UIViewController


+(instancetype)sharedRootVC;

@property (strong, nonatomic)JKSideSlipView *sideSlipView;



@end
