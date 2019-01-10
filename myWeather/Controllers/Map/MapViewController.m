//
//  MapViewController.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "MapViewController.h"
#import "OriginMapView.h"

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
    
    NSArray* ann = [_map annotations];
    for(MKPointAnnotation* an in ann) {
        NSLog(@"%@",an);
    }
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

@end
