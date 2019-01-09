//
//  CityViewController.h
//  myWeather
//
//  Created by Felipe on 1/9/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityTable;

NS_ASSUME_NONNULL_BEGIN

@interface CityViewController : UIViewController

@property (weak, nonatomic) IBOutlet CityTable *cityTable;
@end

NS_ASSUME_NONNULL_END
