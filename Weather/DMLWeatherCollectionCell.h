//
//  DMLWeatherCollectionCell.h
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLWeatherCollectionCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *hourLabel;
@property (nonatomic, readonly) UILabel *percentLabel;
@property (nonatomic, readonly) UIImageView *weatherImageView;
@property (nonatomic, readonly) UILabel *temperatureLabel;

@end
