//
//  CityStore.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "CityStore.h"
#import "City.h"

static NSString* const kCityStoreNSUserDefaults = @"kCityStoreNSUserDefaults";

@implementation CityStore

+ (instancetype)shared
{
    static dispatch_once_t once;
    static id shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init {
    self = [super init];
    _cityStore = [[NSMutableArray alloc] initWithCapacity:10];
    
    //[self initTestValues];
    
    return self;
}

-(void) initTestValues {
    
    City* city1 = [[City alloc] init:@"Atlanta" weather:@"Cloudy" temp:@"75"];
    City* city2 = [[City alloc] init:@"Naples" weather:@"Clear" temp:@"80"];
    City* city3 = [[City alloc] init:@"Weston" weather:@"Rainy" temp:@"85"];

    [self add:city1];
    [self add:city2];
    [self add:city3];
}

-(void) add:(City*)city {
    if(!city)
        return;
    
    // Could be a bit smarter... like keep the timestamp and update only after some time...
    
    for(City* tmp in _cityStore) {
        if([tmp.name isEqualToString:city.name]) {
            [_cityStore removeObject:tmp];
            break;
        }
    }
    
    [_cityStore addObject:city];

    NSArray *sortedArray = [_cityStore sortedArrayUsingComparator:^NSComparisonResult(City* a, City* b) {
        return [[a name] compare:[b name]];
    }];
    
    _cityStore = sortedArray.mutableCopy;
}

-(NSInteger) count {
    return (_cityStore && _cityStore.count)? _cityStore.count : 0;
}

-(City*) objectAtIndex:(NSInteger)index {

    City* city = nil;
    
    @try {
        city = [_cityStore objectAtIndex:index];
    }
    @catch(NSException* e) {
        NSLog(@"Caught Exception at CityStore");
    }
    
    return city;
}

-(void) removeObjectAtIndex:(NSInteger)index {
    
    City* city = [self objectAtIndex:index];
    if(city)
        [_cityStore removeObject:city];
}

-(void) saveStore {

    if(!_cityStore)
        return;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:_cityStore.count];
    
    for(City* tmp in _cityStore) {
        if([tmp hasCoords]) {
            CLLocationCoordinate2D coords = [tmp getCoords];
            NSDictionary* dict = @{@"name":tmp.name,
                                   @"lat":@(coords.latitude),
                                   @"lon":@(coords.longitude)};
            [arr addObject:dict];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:kCityStoreNSUserDefaults];
    
    _cityStore = nil;   // Release store
}

-(void) loadStore {

    NSArray* arr = [[NSUserDefaults standardUserDefaults] objectForKey:kCityStoreNSUserDefaults];
    
    _cityStore = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for(NSDictionary* dict in arr) {
        City* city = [[City alloc] init:dict[@"name"] lat:dict[@"lat"] lon:dict[@"lon"]];
        [self add:city];
    }
}

@end
