//
//  DMLMenu.m
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import <UIImageView+AFNetworking.h>

#import "DMLMenu.h"
#import "DMLWeatherCollectionCell.h"
#import "DMLCollectionViewHandOffLayoutAttributes.h"

static NSString *const sWeatherCollectionCellIdentifier = @"sWeatherCollectionCellIdentifier";
static NSString *const sWeatherIconBaseURLString = @"http://openweathermap.org/img/w/";

static NSInteger const sTodayEveryHourAndSunRiseSetItems = 26;

static const CGFloat sHourWeatherViewHeight = 96.0;
static const CGFloat sDayLabelHeight = 27.0;
static const CGFloat sItemWidth = 75.0;
static const CGFloat sStandarPadding = 20.0;

@interface DMLMenu ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *hourlyWeatherCollectionView;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *hourDateFormatter;

@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UILabel *maxTemperatureLabel;
@property (nonatomic) UILabel *minTemperatureLabel;

@property (nonatomic) UIView *topHairLineView;
@property (nonatomic) UIView *bottomHairLineView;

@property (nonatomic, copy) NSArray *listOfHourWeather;

@end

@implementation DMLMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"EEEE";
        
        _hourDateFormatter = [[NSDateFormatter alloc] init];
        _hourDateFormatter.dateFormat = @"HH";
        
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _dayLabel.textAlignment = NSTextAlignmentLeft;
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.text = [NSString stringWithFormat:@"%@ Today", [self.dateFormatter stringFromDate:[NSDate date]]];
        [self addSubview:_dayLabel];
        
        _maxTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maxTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _maxTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _maxTemperatureLabel.textColor = [UIColor whiteColor];
        _maxTemperatureLabel.text = @"-";
        [self addSubview:_maxTemperatureLabel];
        
        _minTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_minTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _minTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _minTemperatureLabel.textColor = [UIColor whiteColor];
        _minTemperatureLabel.text = @"-";
        [self addSubview:_minTemperatureLabel];
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _hourlyWeatherCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [_hourlyWeatherCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _hourlyWeatherCollectionView.backgroundColor = [UIColor clearColor];
        _hourlyWeatherCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_hourlyWeatherCollectionView registerClass:[DMLWeatherCollectionCell class] forCellWithReuseIdentifier:sWeatherCollectionCellIdentifier];
        
        _hourlyWeatherCollectionView.dataSource = self;
        _hourlyWeatherCollectionView.delegate = self;
        [self addSubview:_hourlyWeatherCollectionView];
        
        _topHairLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topHairLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _topHairLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topHairLineView];
        
        _bottomHairLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomHairLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomHairLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomHairLineView];
        
        // Configure constraints
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sStandarPadding]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_maxTemperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sDayLabelHeight]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_minTemperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sStandarPadding * 0.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dayLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sStandarPadding]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dayLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dayLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_hourlyWeatherCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    DMLCollectionViewHandOffLayoutAttributes *attributes = (DMLCollectionViewHandOffLayoutAttributes *)layoutAttributes;
    
    self.dayLabel.alpha = attributes.overlayAlpha;
    self.maxTemperatureLabel.alpha = attributes.overlayAlpha;
    self.minTemperatureLabel.alpha = attributes.overlayAlpha;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DMLWeatherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sWeatherCollectionCellIdentifier forIndexPath:indexPath];
    
    NSUInteger mappedIndex = indexPath.row / 3;// Per three hour forecast
    
    if (mappedIndex < self.listOfHourWeather.count) {
        NSDictionary *hourForecastWeather = self.listOfHourWeather[mappedIndex];
        NSArray *weathers = hourForecastWeather[@"weather"];
        if (weathers.count > 0) {
            NSDictionary *weather = weathers.firstObject;
            
            NSString *weatherIconString = [NSString stringWithFormat:@"%@%@.png", sWeatherIconBaseURLString, weather[@"icon"]];
            
            [cell.weatherImageView setImageWithURL:[NSURL URLWithString:weatherIconString]];
        }
        
        NSDictionary *temp = hourForecastWeather[@"main"];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%@", temp[@"temp"]];
        
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour value:indexPath.row toDate:[NSDate date] options:0];
        cell.hourLabel.text = [self.hourDateFormatter stringFromDate:date];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return sTodayEveryHourAndSunRiseSetItems;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(sItemWidth, sHourWeatherViewHeight);
}

- (void)configureTemperatureWithDict:(NSDictionary *)dict
{
    NSDictionary *main = dict[@"main"];
    self.maxTemperatureLabel.text = [NSString stringWithFormat:@"%@", main[@"temp_max"]];
    self.minTemperatureLabel.text = [NSString stringWithFormat:@"%@", main[@"temp_min"]];
}

- (void)updateWithNewDataSource:(NSArray *)newData
{
    self.listOfHourWeather = newData;
    [self.hourlyWeatherCollectionView reloadData];
}

@end
