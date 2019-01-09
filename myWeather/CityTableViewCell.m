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

-(void) initialize:(City*)city {
    
    if(!city)
        return;
    
    self.cityLabel.text = city.city;
    self.temperatureLabel.text = city.currTemp;
}
@end
