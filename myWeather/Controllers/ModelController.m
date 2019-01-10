//
//  ModelController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "DataViewController.h"
#import "City.h"
#import "CityStore.h"
#import "WeatherService.h"

/*
 A controller object that manages a simple model.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


static NSString* const networkServiceBackBase = @"networkServiceBackBase";

@interface ModelController ()

//@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation ModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getWeatherAtBackBase];
    }
    return self;
}

-(void) getWeatherAtBackBase {
    
    NSString* lat = @"33.781840";
    NSString* lon = @"-84.387380";
    CLLocationCoordinate2D bb = CLLocationCoordinate2DMake(lat.doubleValue,lon.doubleValue);
    
    [self.weatherService makeGetRequestWithPt:bb withIdentifier:networkServiceBackBase];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    NSInteger count = [[CityStore shared] count];
    if ((count == 0) || (index >= count)) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = [[CityStore shared] objectAtIndex:index];
    dataViewController.dataIndex = @(index);
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return viewController.dataIndex.integerValue;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [[CityStore shared] count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - networkServices

- (WeatherService *)weatherService
{
    if (!_weatherService) {
        _weatherService = [[WeatherService alloc] init];
        _weatherService.session = [NSURLSession sharedSession];
        _weatherService.delegate = self;
    }
    
    return _weatherService;
}

- (void)networkServiceDelegate:(NetworkService *)delegate didFinishRequestWithIdentifier:(NSString *)identifier data:(NSData *)data andError:(NSError *)error {
    
    if (!error) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        @try {
            NSNumber* code = results[@"cod"];
            if(code) {
                if(code.integerValue != 200)
                    NSLog(@"Network Error Received: %@",results);
                else if(code.integerValue == 200) {
                    
                    if([identifier isEqualToString:networkServiceBackBase]) {
                        
                        City* city = [[City alloc] initWithDict:results];
                        [[CityStore shared] add:city];
                        /*
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:kCityStoreUpdate object:nil];
                            
                        });
                         */
                    }
                }
            }
        }
        @catch(NSException *e) {
            NSLog(@"*** Caught Exception in MapViewController: %@",e.description);
        }
    }
}
@end
