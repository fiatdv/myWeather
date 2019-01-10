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

-(instancetype) initWithDict:(NSDictionary*)dict {
    self = [super init];
    @try {
        _store = dict.copy;
        
        //TODO: Addl error checking...
        
        NSArray* wArray = _store[@"weather"];
        NSDictionary* weather = (wArray)? wArray.firstObject : nil;
        
        NSDictionary* main = _store[@"main"];
        id t = main[@"temp"];
        NSString* temp = @"-";
        if([t isKindOfClass:[NSString class]])
            temp = t;
        else {
            NSNumber* k = t;
            NSNumber* f = @((k.integerValue * 1.8) + 32);
//            NSNumber* c = @((k.integerValue - 32) / 1.8);
            temp = [[NSString alloc] initWithFormat:@"%3d",f.intValue];
        }
        
        [self initialize:_store[@"name"]
                 weather:weather[@"description"]
                    temp:temp];
    }
    @catch(NSException* e) {
        // TODO:Handle error
        NSLog(@"*** Caught Exception in City:initWithDict: %@",e.description);
    }
    return self;
}

@end
