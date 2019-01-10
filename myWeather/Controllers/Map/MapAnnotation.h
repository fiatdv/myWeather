//
//  MapAnnotation.h
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithTitle:(NSString *)annotationTitle andLocation:(CLLocationCoordinate2D)location;

@end

NS_ASSUME_NONNULL_END
