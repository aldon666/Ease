//
//  WeatherManager.m
//  weather
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 Aldon. All rights reserved.
//

#import "weatherManager.h"

@implementation WeatherManager

//单例
+ (instancetype)sharedWeatherManager{
    static WeatherManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeatherManager alloc]init];
    });
    return manager;
}

//- (void)returnWeatherByCityName:(NSString *)cityName block:(void (^)(WeatherModel *))handle{
//    
//}

- (void)parserWeather:(NSData *)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *resultDic = dic[@"result"];
    
    //时间,日期
    _realtimeModel = [[RealtimeModel alloc]init];
    [_realtimeModel setValuesForKeysWithDictionary:resultDic[@"realtime"]];

    NSLog(@"%@",_realtimeModel.date);
    //风向
    _windModel = [[WindModel alloc]init];
    NSDictionary *realtimeDic = resultDic[@"realtime"];
    [_windModel setValuesForKeysWithDictionary:realtimeDic[@"wind"]];
    
    //生活
    _lifeModel = [[LifeModel alloc]init];
    [_lifeModel setValuesForKeysWithDictionary:realtimeDic[@"life"]];
    
    //pm 2.5
    _pm252 = [[PM25 alloc]init];
    NSDictionary *pm26 = resultDic[@"pm25"];
    [_pm252 setValuesForKeysWithDictionary:pm26[@"pm25"]];
    
    _weather = [[Weather alloc]init];
    [_weather setValuesForKeysWithDictionary:realtimeDic[@"weather"]];
}

@end
