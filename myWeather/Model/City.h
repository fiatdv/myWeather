//
//  City.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject

@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* currWeather;
@property(nonatomic, strong) NSString* currTemp;
@property(nonatomic, strong) NSNumber* latitude;
@property(nonatomic, strong) NSNumber* longitude;
@property(nonatomic, strong) NSDictionary* store;
@property(nonatomic, strong) UIImage* icon;

-(instancetype)init:(NSString*)name weather:(NSString*)weather temp:(NSString*)temp;

-(instancetype) init:(NSString*)name lat:(NSNumber*)lat lon:(NSNumber*)lon;

-(instancetype) initWithDict:(NSDictionary*)dict;

-(BOOL) hasCoords;
-(CLLocationCoordinate2D) getCoords;

-(NSString*) getWeatherIconName;
-(UIImage*) getWeatherIcon;
-(void) setWeatherIcon:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
