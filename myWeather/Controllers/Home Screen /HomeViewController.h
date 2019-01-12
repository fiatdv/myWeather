//
//  CityViewController.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherService.h"

@class CityTable;

NS_ASSUME_NONNULL_BEGIN

static NSString* const kViewCity = @"kViewCity";

@interface HomeViewController : UIViewController <NetworkServiceDelegate>

@property (weak, nonatomic) IBOutlet CityTable *cityTable;

@property (strong, nonatomic) WeatherService *weatherService;

@end

NS_ASSUME_NONNULL_END
