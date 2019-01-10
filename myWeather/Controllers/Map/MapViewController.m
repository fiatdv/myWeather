//
//  MapViewController.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "MapViewController.h"
#import "OriginMapView.h"
#import "NetworkService.h"
#import "CityStore.h"
#import "City.h"

static NSString* const weatherURL = @"http://api.openweathermap.org/data/2.5/weather";
static NSString* const apiKey = @"a4ae2495b1086cf372587e0c51e507df";

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadBackBase];
    
    //NSString* fromCity = @"Atlanta";
    //NSString* fromState = @"GA";
    //[self reloadMapWithCity:fromCity andState:fromState];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_map addGestureRecognizer:tapRecognizer];
}

-(void) loadBackBase {

    NSString* lat = @"33.781840";
    NSString* lon = @"-84.387380";
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat.doubleValue,lon.doubleValue);
    [_map configureWithCoordinates:coords];
    
    NSString* aTitle = @"BackBase";
    [_map addOriginAnnotation:aTitle];
    
    NSString* latD = @"0.1";
    NSString* lonD = @"0.1";
    [_map setRegion:MKCoordinateRegionMake(_map.centerCoordinate, MKCoordinateSpanMake(latD.floatValue, lonD.floatValue))];

}

-(void)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:_map];
    CLLocationCoordinate2D tapPoint = [_map convertPoint:point toCoordinateFromView:_map];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = tapPoint;
    [_map addAnnotation:point1];
    
    [self.networkService makeGetRequestTo:[self URLForPoint:tapPoint] withIdentifier:@"foundTap" withKey:apiKey];

    // Show Busy Dialog... interrupt main ui
    
//    NSArray* ann = [_map annotations];
//    for(MKPointAnnotation* an in ann) {
//        NSLog(@"%@",an);
//    }
}

- (NSURL *)URLForPoint:(CLLocationCoordinate2D)pt
{
    NSString* urlStr = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&APPID=%@&units=metric",weatherURL,pt.latitude,pt.longitude,apiKey];

    NSURL *url = [NSURL URLWithString:urlStr];

    NSLog(@"URLForPoint url = %@", url.absoluteString);
    return url;
}

- (void)reloadMapWithCity:(NSString*)fromCity andState:(NSString*)fromState {
    
    if(fromCity && fromState) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *addressString = [NSString stringWithFormat:@"%@, %@", fromCity, fromState];
        
        [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if(error)
                return;
            
            if(placemarks) {
                CLPlacemark *placemark = [placemarks firstObject];
                [self displayMapForCoordinates:placemark.location.coordinate];
            }
        }];
    }
}

- (void)displayMapForCoordinates:(CLLocationCoordinate2D)coordinates
{
    if (!(coordinates.latitude == 0 && coordinates.longitude == 0)) {
        [_map configureWithCoordinates:coordinates];
        [_map setRegion:MKCoordinateRegionMake(_map.centerCoordinate, MKCoordinateSpanMake(0.06, 0.06))];
        NSString* aTitle = @"Here";
        [_map addOriginAnnotation:aTitle];
    }
}

-(void) dismissViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeWindow:(id)sender {

    [self dismissViewController];
}

#pragma mark - networkServices

- (NetworkService *)networkService
{
    if (!_networkService) {
        _networkService = [[NetworkService alloc] init];
        _networkService.session = [NSURLSession sharedSession];
        _networkService.delegate = self;
    }
    
    return _networkService;
}

- (void)networkServiceDelegate:(NetworkService *)delegate didFinishRequestWithIdentifier:(NSString *)identifier data:(NSData *)data andError:(NSError *)error {
    
    if (!error) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        @try {
            NSNumber* code = results[@"cod"];
            if(code) {
                if(code.integerValue != 200)
                    NSLog(@"Network Error Received: %@",results);
                else if(code.integerValue == 200){
                    City* city = [[City alloc] initWithDict:results];
                    [[CityStore shared] add:city];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewController];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCityStoreUpdate object:nil];

                    });
                }
            }
        }
        @catch(NSException *e) {
            NSLog(@"*** Caught Exception in MapViewController: %@",e.description);
        }
    }
}


@end
