//
//  CityTableViewCell.m
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "CityTableViewCell.h"
#import "City.h"

@implementation CityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initialize:(City*)city at:(NSInteger)row {
    
    if(!city)
        return;
    
    if(row % 2 != 0)
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:.33];
    else {
        self.backgroundColor = [UIColor colorWithRed:189/255.0f green:229/255.0f blue:251/255.0f alpha:1];
    }

    self.cityLabel.text = city.name;
    self.temperatureLabel.text = city.currTemp;
    
    [self setWeatherIcon:city];
}

-(void) setWeatherIcon:(City*)city {
    
    if(!city)
        return;

    UIImage* image = [city getWeatherIcon];
    if(image) {
        [self.weatherImage setImage:image];
        return;
    }
    
    
    NSString* iconName = [city getWeatherIconName];
    if(!iconName)
        return;
    
    NSString* urlStr = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",iconName];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlStr]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithData:data];
            [city setWeatherIcon:image];
            [self.weatherImage setImage:image];
            [self setNeedsDisplay];
        });
    });
}
@end
