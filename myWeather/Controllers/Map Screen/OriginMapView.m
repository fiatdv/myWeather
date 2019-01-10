//
//  OriginMapView.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "OriginMapView.h"
#import "MapAnnotation.h"

@implementation OriginMapView

- (void)configureWithCoordinates:(CLLocationCoordinate2D)coordinates {
    
    [self setCenterCoordinate:coordinates];
}

- (void)addOriginAnnotation:(NSString*)title {
    
    [self removeAnnotations:self.annotations];
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithTitle:title andLocation:self.centerCoordinate];
    [self addAnnotation:annotation];
    [self showAnnotations:self.annotations animated:YES];
}

@end
