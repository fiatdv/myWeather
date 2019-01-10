//
//  MapAnnotation.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;

- (instancetype)initWithTitle:(NSString *)annotationTitle andLocation:(CLLocationCoordinate2D)location {
    
    self = [super init];
    if (self) {
        title = annotationTitle;
        coordinate = location;
    }
    
    return self;
}

@end
