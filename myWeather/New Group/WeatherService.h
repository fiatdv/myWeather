//
//  WeatherService.h
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "NetworkService.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherService : NetworkService

- (void)makeGetRequestWithPt:(CLLocationCoordinate2D)pt withIdentifier:(NSString *)identifier;

- (NSURL*) URLForPoint:(CLLocationCoordinate2D)pt;

@end

NS_ASSUME_NONNULL_END
