//
//  DMLHeader.m
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import "DMLHeader.h"
#import "DMLCollectionViewHandOffLayoutAttributes.h"

@interface DMLHeader ()

@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *weatherLabel;
@property (nonatomic) UILabel *temperatureLabel;

@end

@implementation DMLHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = [UIFont systemFontOfSize:22];
        _locationLabel.text = @"--";
        [self addSubview:_locationLabel];
        
        _weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_weatherLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.font = [UIFont systemFontOfSize:16];
        _weatherLabel.text = @"--";
        [self addSubview:_weatherLabel];
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_temperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:72];
        _temperatureLabel.text = @"--";
        [self addSubview:_temperatureLabel];
        
        // Configure constraints
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_locationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_locationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:40.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_weatherLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_weatherLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_locationLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_weatherLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
//    self.backgroundColor = [UIColor brownColor];
    
    DMLCollectionViewHandOffLayoutAttributes *attributes = (DMLCollectionViewHandOffLayoutAttributes *)layoutAttributes;
    
    self.temperatureLabel.alpha = attributes.headerOverlayAlpha;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

@end
