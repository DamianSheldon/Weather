//
//  DMLMenu.h
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLMenu : UICollectionReusableView

@property (nonatomic, readonly) UICollectionView *hourlyWeatherCollectionView;

@property (nonatomic, readonly) UILabel *dayLabel;
@property (nonatomic, readonly) UILabel *maxTemperatureLabel;
@property (nonatomic, readonly) UILabel *minTemperatureLabel;

- (void)configureTemperatureWithDict:(NSDictionary *)dict;

- (void)updateWithNewDataSource:(NSArray *)newData;

@end
