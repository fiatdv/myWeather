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

static NSString* const networkServiceFindTap = @"networkServiceFindTap";

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UIView *tapNote;
@property (weak, nonatomic) IBOutlet UIView *closeNote;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if([CityStore shared].count == 0) {
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setEnabled:NO];
        
        [_tapNote setHidden:NO];
    }
    //[self loadBackBase];
    
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
    
    NSString* latD = @"30.0";
    NSString* lonD = @"30.0";
    [_map setRegion:MKCoordinateRegionMake(_map.centerCoordinate, MKCoordinateSpanMake(latD.floatValue, lonD.floatValue))];

}

-(void)foundTap:(UITapGestureRecognizer *)recognizer
{
    [_tapNote setHidden:YES];
    
    if([CityStore shared].count == 0)
        [_closeNote setHidden:NO];
    else
        [_closeNote setHidden:YES];

    CGPoint point = [recognizer locationInView:_map];
    CLLocationCoordinate2D tapPoint = [_map convertPoint:point toCoordinateFromView:_map];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = tapPoint;
    [_map addAnnotation:point1];
    
    [_closeButton setEnabled:YES];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.weatherService makeGetRequestWithPt:tapPoint withIdentifier:networkServiceFindTap userInfo:point1];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCityStoreUpdate object:nil];
    });
}

- (IBAction)closeWindow:(id)sender {

    [self dismissViewController];
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
                    
                    if([identifier hasPrefix:networkServiceFindTap]) {
                        
                        City* city = [[City alloc] initWithDict:results];
                        [[CityStore shared] add:city];

                        NSString* title = [NSString stringWithFormat:@"%@:%@",city.name,city.currTemp];
                        [userInfo setTitle:title];
                        
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.map setNeedsDisplay];
//                        });
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
