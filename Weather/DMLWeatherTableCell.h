//
//  DMLWeatherTableCell.h
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLWeatherTableCell : UITableViewCell

@property (nonatomic, readonly) UILabel *dayLabel;
@property (nonatomic, readonly) UIImageView *weatherImageView;
@property (nonatomic, readonly) UILabel *maxTemperatureLabel;
@property (nonatomic, readonly) UILabel *minTemperatureLabel;

@end
