//
//  CityViewController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"
#import "CityViewController.h"
#import "City.h"
#import "CityStore.h"
#import "HelpViewController.h"

static NSString* const kRefreshCityStore = @"kRefreshCityStore";
static NSString* const kRefreshCity = @"kRefreshCity";

@interface HomeViewController ()

@property (strong, nonatomic) NSTimer* timer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self getWeatherAtBackBase];
    [self refreshCityStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewCity:) name:kViewCity object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForekground) name:kApplicationWillEnterForeground object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:kApplicationWillEnterBackground object:nil];

    [self setupTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self releaseTimer];
}

-(void)didEnterForekground {
    [self refreshCityStore];
    [self setupTimer];
}

-(void)didEnterBackground {
    [self releaseTimer];
}

-(void) setupTimer {
    
    if(!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(refreshCityStore) userInfo:nil repeats:YES];
    
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void) releaseTimer {
    
    [_timer invalidate];
    _timer = nil;
}

-(void) getWeatherAtBackBase {
    
    NSNumber* lat = @(33.781840);
    NSNumber* lon = @(-84.387380);
    
    City* atl = [[City alloc] init:@"BackBase" lat:lat lon:lon];
    [[CityStore shared] add:atl];

//    CLLocationCoordinate2D bb = CLLocationCoordinate2DMake(lat.doubleValue,lon.doubleValue);
//    [self.weatherService makeGetRequestWithPt:bb withIdentifier:networkServiceBackBase];
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
    if(dict && dict[@"city"])
        city = dict[@"city"];
    if(!city)
        return;
    
    CityViewController *vc = (CityViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    vc.city = city;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];

    [self presentViewController:vc animated:NO completion:nil];
}

-(void) refreshCityStore {
    
    for(int i = 0 ; i < [[CityStore shared] count]; i++) {
        City* city = [[CityStore shared] objectAtIndex:i];
        if(city && city.hasCoords) {
            CLLocationCoordinate2D coords = [city getCoords];
            [self.weatherService makeGetRequestWithPt:coords withIdentifier:kRefreshCityStore userInfo:self];
        }
    }
}

-(void) refreshCity:(City*)city {
    
    if(city && city.hasCoords) {
        CLLocationCoordinate2D coords = [city getCoords];
        [self.weatherService makeGetRequestWithPt:coords withIdentifier:kRefreshCity userInfo:self];
    }
}

- (IBAction)showHelp:(id)sender {

    HelpViewController *vc = (HelpViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
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

- (void)networkServiceDelegate:(NetworkService *)delegate didFinishRequestWithIdentifier:(NSString *)identifier data:(NSData *)data andError:(NSError *)error userInfo:(id)userInfo {
    
    if (!error) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        @try {
            NSNumber* code = results[@"cod"];
            if(code) {
                if(code.integerValue != 200)
                    NSLog(@"Network Error Received: %@",results);
                else if(code.integerValue == 200) {
                    
                    if([identifier hasPrefix:kRefreshCity]) {
                        
                        City* city = [[City alloc] initWithDict:results];
                        [[CityStore shared] add:city];
                        
                        if([identifier hasPrefix:kRefreshCity]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCityTable object:nil];
                        }
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
