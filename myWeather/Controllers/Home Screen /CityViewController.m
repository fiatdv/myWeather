//
//  CityViewController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "CityViewController.h"
#import "MapViewController.h"
#import "DataViewController.h"
#import "City.h"
#import "CityStore.h"

static NSString* const networkServiceBackBase = @"networkServiceBackBase";

@interface CityViewController ()

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getWeatherAtBackBase];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewCity:) name:kViewCity object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:applicationWillEnterForeground object:nil];
}

-(void) getWeatherAtBackBase {
    
    NSString* lat = @"33.781840";
    NSString* lon = @"-84.387380";
    CLLocationCoordinate2D bb = CLLocationCoordinate2DMake(lat.doubleValue,lon.doubleValue);
    
    [self.weatherService makeGetRequestWithPt:bb withIdentifier:networkServiceBackBase];
}

- (IBAction)closeWindow:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCity:(id)sender {
    
    MapViewController *vc = (MapViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
}

-(void) viewCity:(NSNotification *)notification {

    City* city = nil;
    NSDictionary* dict = notification.userInfo;
    if(dict) {
        city = dict[@"city"];
    }
    
    DataViewController *vc = (DataViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    
    vc.city = city;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];

    [self presentViewController:vc animated:NO completion:nil];
}

-(void) applicationWillEnterForeground {

    for(int i = 0 ; i < [[CityStore shared] count]; i++) {
        City* city = [[CityStore shared] objectAtIndex:i];
        if(city && city.hasCoords) {
            CLLocationCoordinate2D coords = [city getCoords];
            [self.weatherService makeGetRequestWithPt:coords withIdentifier:networkServiceBackBase];
        }
    }
}

#pragma mark - networkServices

- (WeatherService *)weatherService
{
    if (!_weatherService) {
        _weatherService = [[WeatherService alloc] init];
        _weatherService.session = [NSURLSession sharedSession];
        _weatherService.delegate = self;
    }
    
    return _weatherService;
}

- (void)networkServiceDelegate:(NetworkService *)delegate didFinishRequestWithIdentifier:(NSString *)identifier data:(NSData *)data andError:(NSError *)error {
    
    if (!error) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        @try {
            NSNumber* code = results[@"cod"];
            if(code) {
                if(code.integerValue != 200)
                    NSLog(@"Network Error Received: %@",results);
                else if(code.integerValue == 200) {
                    
                    if([identifier isEqualToString:networkServiceBackBase]) {
                        
                        City* city = [[City alloc] initWithDict:results];
                        [[CityStore shared] add:city];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCityStoreUpdate object:nil];
                    }
                }
            }
        }
        @catch(NSException *e) {
            NSLog(@"*** Caught Exception in MapViewController: %@",e.description);
        }
    }
}
@end
