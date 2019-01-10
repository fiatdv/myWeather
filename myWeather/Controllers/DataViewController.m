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

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    City* city = self.dataObject;
    self.cityLabel.text = city.city;
    self.weatherLabel.text = city.currWeather;
    self.temperatureLabel.text = city.currTemp;
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

@end
