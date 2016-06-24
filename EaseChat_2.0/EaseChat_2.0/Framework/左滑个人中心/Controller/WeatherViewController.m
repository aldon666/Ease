//
//  WeatherViewController.m
//  EaseChat_2.0
//
//  Created by lanou3g on 16/6/23.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherManager.h"
@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestWeatherByCityName:(NSString *)cityName{
    NSString *str = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.avatardata.cn/Weather/Query?key=cc046c4a64b243139a83f026fd9bd433&cityname=%@",str];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[WeatherManager sharedWeatherManager]parserWeather:data];
            
            NSString *date1 = [WeatherManager sharedWeatherManager].realtimeModel.date;
            NSLog(@"%@",[WeatherManager sharedWeatherManager].realtimeModel);
            _date.text = [NSString stringWithFormat:@"%@",date1];
            _weather.text = [WeatherManager sharedWeatherManager].weather.info;
            _temperature.text = [NSString stringWithFormat:@"%@℃",[WeatherManager sharedWeatherManager].weather.temperature];
            _windDirection.text = [NSString stringWithFormat:@"风向:%@",[WeatherManager sharedWeatherManager].windModel.direct];
            _windSpeed.text = [NSString stringWithFormat:@"风速:%@",[WeatherManager sharedWeatherManager].windModel.windspeed];
            _windPower.text = [NSString stringWithFormat:@"风力:%@",[WeatherManager sharedWeatherManager].windModel.power];
            
            _pm251.text = [WeatherManager sharedWeatherManager].pm252.pm25;
            _quality.text = [WeatherManager sharedWeatherManager].pm252.quality;
            _des.text = [WeatherManager sharedWeatherManager].pm252.des;
            
            _city.text = _cityNameTF.text;
            
            self.backImgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[WeatherManager sharedWeatherManager].weather.info]];
        });
    }];
    [task resume];
}
- (IBAction)demand:(UIButton *)sender {
    if (_cityNameTF.text == nil || [_cityNameTF.text  isEqual: @""]) {
        return;
    }else{
    [self requestWeatherByCityName:_cityNameTF.text];
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.cityNameTF resignFirstResponder];
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
