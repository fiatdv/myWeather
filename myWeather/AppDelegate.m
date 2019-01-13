//
//  AppDelegate.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "AppDelegate.h"
#import "myWeatherConsts.h"
#import "CityStore.h"
#import "HomeViewController.h"
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[CityStore shared] loadStore];

    if([CityStore shared].count == 0)
        [self showMapScreen];
//    else
//        [self showHomeScreen];
    
    return YES;
}

-(void) showHomeScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *vc = (HomeViewController*) [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self.window makeKeyAndVisible];
    
    [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
}

-(void) showMapScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *vc = (MapViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    [self.window makeKeyAndVisible];
    
    [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[CityStore shared] saveStore];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationWillEnterBackground object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[CityStore shared] loadStore];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationWillEnterForeground object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CityStore shared] saveStore];
}


@end
