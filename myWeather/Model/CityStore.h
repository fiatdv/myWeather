//
//  CityStore.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myWeatherConsts.h"

NS_ASSUME_NONNULL_BEGIN

@class City;

@interface CityStore : NSObject

@property (strong, nonatomic) NSMutableArray *cityStore;

+ (instancetype)shared;

-(void) add:(City*)city;

-(NSInteger) count;

-(City*) objectAtIndex:(NSInteger)index;
-(void) removeObjectAtIndex:(NSInteger)index;

-(void) saveStore;
-(void) loadStore;

@end

NS_ASSUME_NONNULL_END
