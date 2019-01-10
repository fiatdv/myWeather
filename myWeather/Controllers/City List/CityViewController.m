//
//  CityViewController.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "CityViewController.h"
#import "MapViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeWindow:(id)sender {
    
    MapViewController *vc = (MapViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];

    // Dismiss:
    // [self dismissViewControllerAnimated:YES completion:nil];
}

@end
