//
//  WeatherService.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "WeatherService.h"
#import "CityStore.h"
#import "City.h"

static NSString* const weatherURL = @"http://api.openweathermap.org/data/2.5/weather";
static NSString* const apiKey = @"a4ae2495b1086cf372587e0c51e507df";

@implementation WeatherService

- (NSURL *) URLForPoint:(CLLocationCoordinate2D)pt
{
    NSString* urlStr = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&APPID=%@&units=metric",weatherURL,pt.latitude,pt.longitude,apiKey];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"URLForPoint url = %@", url.absoluteString);
    return url;
}

- (void)makeGetRequestWithPt:(CLLocationCoordinate2D)pt withIdentifier:(NSString *)identifier userInfo:(id)userInfo {

    NSURL* url = [self URLForPoint:pt];
    
    [self makeGetRequestTo:url withIdentifier:identifier withKey:apiKey userInfo:userInfo];
}

@end
