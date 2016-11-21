//
//  DMLWeatherCollectionCell.m
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLWeatherCollectionCell.h"

static const CGFloat sPadding = 4.0;
static const CGFloat sHourLabelHeight = 24.0;
static const CGFloat sPercentLabelHeight = 14.0;
static const CGFloat sImageViewWidth = 32.0;

@interface DMLWeatherCollectionCell ()

@property (nonatomic) UILabel *hourLabel;
@property (nonatomic) UILabel *percentLabel;
@property (nonatomic) UIImageView *weatherImageView;
@property (nonatomic) UILabel *temperatureLabel;

@end

@implementation DMLWeatherCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _hourLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _hourLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_hourLabel];
        
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _percentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_percentLabel];
        
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_weatherImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:_weatherImageView];
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _temperatureLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_temperatureLabel];
        
        [self configureConstraintsForHourLabel];
        [self configureConstraintsForPercentLabel];
        [self configureConstraintsForWeatherImageView];
        [self configureConstraintsForTemperatureLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.hourLabel.text = nil;
    self.percentLabel.text = nil;
    self.weatherImageView.image = nil;
    self.temperatureLabel.text = nil;
}

#pragma mark - Private Methods

- (void)configureConstraintsForHourLabel
{
    [_hourLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hourLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hourLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hourLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hourLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sHourLabelHeight]];
}

- (void)configureConstraintsForPercentLabel
{
    [_percentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_percentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_percentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_percentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_hourLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_percentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sPercentLabelHeight]];
}

- (void)configureConstraintsForWeatherImageView
{
    [_weatherImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_percentLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sImageViewWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_weatherImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForTemperatureLabel
{
    [_temperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_weatherImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

@end
