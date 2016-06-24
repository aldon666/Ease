//
//  WindModel.h
//  weather
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 Aldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindModel : NSObject
//wind
@property (copy, nonatomic)NSString *windspeed;//风速
@property (copy, nonatomic)NSString *direct;//风向
@property (copy, nonatomic)NSString *power;//风力
@end
