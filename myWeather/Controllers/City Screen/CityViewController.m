//
//  CityViewController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "CityViewController.h"
#import "City.h"
#import "HomeViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if(!_city && _dataObject)
        _city = _dataObject;

    self.cityLabel.text = _city.name;
    self.weatherLabel.text = [_city.currWeather capitalizedString];
    self.temperatureLabel.text = _city.currTemp;

    if(_city.getWeatherIcon)
        self.weatherIcon.image  = _city.getWeatherIcon;
    
    self.rainChanceLabel.text = _city.rainChance;
    self.humidityLabel.text = _city.humidity;
    self.windLabel.text = _city.wind;
    self.precipitationLabel.text = _city.windDirection;
}

- (IBAction)showCities:(id)sender {

    HomeViewController *vc = (HomeViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)closeWindow:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
