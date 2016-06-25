//
//  ChatConsoleView.h
//  EasyChat
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClicked)(NSString * draftText);

@interface ChatConsoleView : UIView

@property (nonatomic, copy) ButtonClicked buttonClicked;

@end
