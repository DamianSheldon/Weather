//
//  DMLWeatherTableCell.m
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLDailyWeatherCell.h"

static const CGFloat sPadding = 20.0;

@interface DMLDailyWeatherCell ()

@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UIImageView *weatherImageView;
@property (nonatomic) UILabel *maxTemperatureLabel;
@property (nonatomic) UILabel *minTemperatureLabel;

@end

@implementation DMLDailyWeatherCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLabel.textAlignment = NSTextAlignmentLeft;
        _dayLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _dayLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_dayLabel];
        
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_weatherImageView];
        
        _maxTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _maxTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _maxTemperatureLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _maxTemperatureLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_maxTemperatureLabel];
        
        _minTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _minTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _minTemperatureLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _minTemperatureLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_minTemperatureLabel];
        
        [self configureConstraintsForDayLabel];
        [self configureConstraintsForWeatherImageView];
        [self configureConstraintsForMaxTemperatureLabel];
        [self configureConstraintsForMinTemperatureLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dayLabel.text = nil;
    self.weatherImageView.image = nil;
    self.maxTemperatureLabel.text = nil;
    self.minTemperatureLabel.text = nil;
}

#pragma mark - Private Methods

- (void)configureConstraintsForDayLabel
{
    [_dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_weatherImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForWeatherImageView
{
    [_weatherImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_weatherImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForMaxTemperatureLabel
{
    [_maxTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_weatherImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_minTemperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_maxTemperatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForMinTemperatureLabel
{
    [_minTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:2*sPadding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minTemperatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

@end
