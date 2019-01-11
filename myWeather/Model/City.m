//
//  City.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)init:(NSString*)name weather:(NSString*)weather temp:(NSString*)temp {
    self = [super init];
    if (self) {
        [self initialize:name weather:weather temp:temp];
    }
    return self;
}

-(instancetype) init:(NSString*)name lat:(NSNumber*)lat lon:(NSNumber*)lon {
    self = [super init];
    if (self) {
        self.name = name;
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}

-(void) initialize:(NSString*)name weather:(NSString*)weather temp:(NSString*)temp {
    self.name = (name && name.length > 0)? name : @"Unknown";
    self.currWeather = (weather && weather.length > 0)? weather : @"Unknown";
    self.currTemp = (temp && temp.length > 0)? temp : @"-";
}

-(instancetype) initWithDict:(NSDictionary*)dict {
    self = [super init];
    @try {
        _store = dict.copy;
        
        // city
        NSString* name = (_store[@"name"])? _store[@"name"] : @"";
        
        // weather
        NSArray* wArray = _store[@"weather"];
        NSDictionary* wDict = (wArray)? wArray.firstObject : nil;
        NSString* weather = (wDict[@"description"])? wDict[@"description"] : @"";
        
        // temp:
        NSDictionary* main = _store[@"main"];
        id t = main[@"temp"];
        NSString* temp = @"-";
        if([t isKindOfClass:[NSString class]])
            temp = t;
        else if([t isKindOfClass:[NSNumber class]]) {
            NSNumber* k = t;
            NSNumber* f = @(round((k.doubleValue * 1.8) + 32));
            //NSNumber* c = @(round((doubleValue - 32) / 1.8));
            temp = [[NSString alloc] initWithFormat:@"%3d",f.intValue];
        }
        
        [self initialize:name
                 weather:weather
                    temp:temp];
        
        id h = main[@"humidity"];
        _humidity = @"-";
        if(h && ([h isKindOfClass:[NSNumber class]]))
            _humidity = [NSString stringWithFormat:@"%3d%%",((NSNumber*)h).intValue];
 
        _rainChance = @"-"; // TODO: _rainChance not rain volume
        id p = _store[@"rain"];
        if(p && ([p isKindOfClass:[NSDictionary class]])) {
            id v = p[@"1h"];
            if(v && ([v isKindOfClass:[NSNumber class]]))
                _rainChance = [NSString stringWithFormat:@"%3.2f /h",((NSNumber*)v).floatValue];
        }
        
        _wind = @"-";
        _windDirection = @"-";
        id w = _store[@"wind"];
        if(w && ([w isKindOfClass:[NSDictionary class]])) {
            id s = w[@"speed"];
            if(s && ([s isKindOfClass:[NSNumber class]]))
                _wind = [NSString stringWithFormat:@"%3d m/s",((NSNumber*)s).intValue];
            s = w[@"deg"];
            if(s && ([s isKindOfClass:[NSNumber class]]))
                _windDirection = [NSString stringWithFormat:@"%3d deg",((NSNumber*)s).intValue];
        }
        
        
    }
    @catch(NSException* e) {
        // TODO:Handle error
        NSLog(@"*** Caught Exception in City:initWithDict: %@",e.description);
    }
    return self;
}

-(BOOL) hasCoords {
    return ((_store != nil) || (_latitude && _longitude));
}

-(CLLocationCoordinate2D) getCoords {

    if(!_latitude || !_longitude)
        return [self getCoordsFromStore];
    
    return CLLocationCoordinate2DMake(_latitude.doubleValue,_longitude.doubleValue);
}

-(CLLocationCoordinate2D) getCoordsFromStore {
    
    NSNumber* lat = @(0);
    NSNumber* lon = @(0);
    
    // coord:
    if(_store) {
        NSDictionary* coord = _store[@"coord"];
        if(coord) {
            lat = (coord[@"lat"]) ? coord[@"lat"] : lat;
            lon = (coord[@"lon"]) ? coord[@"lon"] : lon;
            _latitude = lat;
            _longitude = lon;
        }
    }
    
    return CLLocationCoordinate2DMake(lat.doubleValue,lon.doubleValue);
}

-(NSString*) getWeatherIconName {
    
    if(!_store)
        return nil;
    
    NSArray* wArray = _store[@"weather"];
    if(!wArray || wArray.count == 0)
        return nil;

    NSDictionary* weather = wArray.firstObject;
    if(!weather || !weather[@"icon"])
        return nil;

    NSString* icon = weather[@"icon"];
    if(!icon || icon.length == 0)
        return nil;
    
    return icon;
}

-(UIImage*) getWeatherIcon {
    return _icon;
}

-(void) setWeatherIcon:(UIImage*)image {
    _icon = image;
}

@end
