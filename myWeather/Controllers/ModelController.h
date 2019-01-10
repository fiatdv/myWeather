//
//  ModelController.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherService.h"

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource, NetworkServiceDelegate>

@property (strong, nonatomic) WeatherService *weatherService;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

