//
//  NetworkService.m
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "NetworkService.h"
#import <UIKit/UIKit.h>

static BOOL sNetworkError = NO;

@implementation NetworkService

#pragma mark Network Requests

- (void)makeGetRequestTo:(NSURL *)url withIdentifier:(NSString *)identifier withKey:(NSString *)key userInfo:(id)userInfo {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //[urlRequest setValue:key forHTTPHeaderField:@"x-api-key"];
    //[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Catch and handle the error so that it
        // does not cause the whole app to crash
        // which may happen if the user loses
        // a connection to the internet
        if (error) {
            showNetworkError();
            NSLog(@"Network Service: dataTaskWithRequest error: %@", error);
            // Commented out the return because the network activity indicator will never stop
            // spinning and the delegate will never be informed that the request finished.
            //            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        [self.delegate networkServiceDelegate:self didFinishRequestWithIdentifier:identifier data:data andError:error userInfo:(id)userInfo];
    }];
    
    [task resume];
}

void showNetworkError() {
    
    if(!sNetworkError) {
        
        sNetworkError = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                           message:@"\nInternet connection is not available.\n\nTry again later."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           sNetworkError = NO;
                                       }];
            [alert addAction:okAction];
            
            UIViewController* topController = topMostController();
            if(topController)
                [topController presentViewController:alert animated:YES completion:nil];
        });
    }
}

UIViewController* topMostController() {
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    return topController;
}

@end
