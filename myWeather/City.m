//
//  City.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)init:(NSString*)city weather:(NSString*)weather temp:(NSString*)temp {
    self = [super init];
    if (self) {
        [self initialize:city weather:weather temp:temp];
    }
    return self;
}

-(void) initialize:(NSString*)city weather:(NSString*)weather temp:(NSString*)temp {
    self.city = city;
    self.currWeather = weather;
    self.currTemp = temp;
}

@end
