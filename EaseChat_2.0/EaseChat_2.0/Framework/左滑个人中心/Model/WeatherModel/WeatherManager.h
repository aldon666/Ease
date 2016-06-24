//
//  WeatherManager.h
//  weather
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 Aldon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RealtimeModel.h"
#import "LifeModel.h"
#import "PM25.h"
#import "WindModel.h"
#import "Weather.h"

@interface WeatherManager : NSObject

@property (strong, nonatomic)WindModel *windModel;
@property (strong, nonatomic)LifeModel *lifeModel;
@property (strong, nonatomic)PM25 *pm252;
@property (strong, nonatomic)RealtimeModel *realtimeModel;
@property (strong, nonatomic)Weather *weather;

+ (instancetype)sharedWeatherManager;


- (void)parserWeather:(NSData *)data;
//- (void)returnWeatherByCityName:(NSString *)cityName
//                          block:(void(^)(WeatherModel *))handle;
@end
