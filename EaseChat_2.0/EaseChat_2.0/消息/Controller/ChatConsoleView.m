//
//  ChatConsoleView.m
//  EasyChat
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "ChatConsoleView.h"

@interface ChatConsoleView ()

@property (nonatomic, strong) UITextField * draftTextField;
@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation ChatConsoleView

@synthesize draftTextField, sendButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame {
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    
    draftTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 100, frame.size.height - 10)];
    [draftTextField setBorderStyle:(UITextBorderStyleRoundedRect)];
    [draftTextField setPlaceholder:@"说点什么呢"];
    [draftTextField setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:draftTextField];
    
    sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sendButton setFrame:CGRectMake(frame.size.width - 90, 5, 85, frame.size.height - 10)];
    [sendButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:128 / 255.0 alpha:1]];
    [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.layer setCornerRadius:4];
    [sendButton addTarget:self action:@selector(didSendButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:sendButton];
}

- (void)didSendButtonClicked:(UIButton *)sender {
    
    if (self.buttonClicked) {
        self.buttonClicked(draftTextField.text);
    }
    draftTextField.text = @"";
}

- (NSString *)draftText {
    
    return draftTextField.text;
}


@end
