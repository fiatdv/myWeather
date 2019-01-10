//
//  MapViewController.h
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OriginMapView;

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet OriginMapView *map;
@end

NS_ASSUME_NONNULL_END
