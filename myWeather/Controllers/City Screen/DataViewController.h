//
//  DataViewController.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface DataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) id dataObject;
@property (strong, nonatomic) City* city;
@property (strong, nonatomic) NSNumber* dataIndex;

@end

