//
//  PM25.h
//  weather
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 Aldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PM25 : NSObject
#pragma pm 2.5
@property (copy, nonatomic)NSString *pm25;//pm2.5
@property (copy, nonatomic)NSString *quality;//污染程度
@property (copy, nonatomic)NSString *des;//建议
@end
