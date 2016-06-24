//
//  RealtimeModel.h
//  weather
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 Aldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealtimeModel : NSObject
//time
@property (copy, nonatomic)NSString *time;//时间

@property (copy, nonatomic)NSString *date;//日期
@property (copy, nonatomic)NSString *city_name;//城市
@property (copy, nonatomic)NSString *week;//星期
@property (copy, nonatomic)NSString *moon;//农历



@end
