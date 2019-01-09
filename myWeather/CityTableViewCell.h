//
//  CityTableViewCell.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

NS_ASSUME_NONNULL_BEGIN

@interface CityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

-(void) initialize:(City*)city;

@end

NS_ASSUME_NONNULL_END
