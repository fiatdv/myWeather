//
//  DataViewController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "DataViewController.h"
#import "City.h"
#import "CityViewController.h"

static const CGFloat viewHeight = 350;

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_scrollView setScrollEnabled:YES];
    [self setScrollContentSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceDidRotate:(NSNotification *)notification
{
    [self setScrollContentSize];
}

- (void)setScrollContentSize {
    
    CGRect rec = _scrollContentView.frame;
    rec.size.height = viewHeight;
    _scrollContentView.frame = rec;
    _scrollView.contentSize = rec.size;
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

    CityViewController *vc = (CityViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    
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
