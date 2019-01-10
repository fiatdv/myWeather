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

static NSString* const urlStr = @"http://api.openweathermap.org/data/2.5/weather";
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

//    NSArray* ann = [_map annotations];
//    for(MKPointAnnotation* an in ann) {
//        NSLog(@"%@",an);
//    }
}

- (NSURL *)URLForPoint:(CLLocationCoordinate2D)pt
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSString* queryString = [NSString stringWithFormat:@"lat=%f&lon=%f&APPID=%@&units=metric",pt.latitude,pt.longitude,apiKey];
    if(queryString) {
        queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:queryString relativeToURL:url];
    }
    
    if(!url.absoluteString)
        NSLog(@"");
    
    NSLog(@"URLForPoint url = %@", url.absoluteString);
    return url;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)closeWindow:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
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
        NSLog(@"Received: %@",results);
    }
}


@end
