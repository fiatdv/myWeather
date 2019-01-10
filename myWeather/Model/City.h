//
//  City.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject

@property(nonatomic, strong) NSString* city;
@property(nonatomic, strong) NSString* currWeather;
@property(nonatomic, strong) NSString* currTemp;

- (instancetype)init:(NSString*)city weather:(NSString*)weather temp:(NSString*)temp;

@end

NS_ASSUME_NONNULL_END