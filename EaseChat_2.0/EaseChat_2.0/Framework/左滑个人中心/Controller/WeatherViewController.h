//
//  WeatherViewController.h
//  EaseChat_2.0
//
//  Created by lanou3g on 16/6/23.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *cityNameTF;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windPower;
@property (weak, nonatomic) IBOutlet UILabel *advise;

@property (weak, nonatomic) IBOutlet UILabel *pm251;
@property (weak, nonatomic) IBOutlet UILabel *quality;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UIImageView *backImgview;

@end
