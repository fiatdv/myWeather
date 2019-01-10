//
//  OriginMapView.h
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OriginMapView : MKMapView

- (void)configureWithCoordinates:(CLLocationCoordinate2D)coordinates;
- (void)addOriginAnnotation:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
