//
//  DMLSubtitleTableCell.m
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLDetailWeatherCell.h"

static const CGFloat sPadding = 20.0;

@interface DMLDetailWeatherCell ()

@property (nonatomic) UILabel *leftTitleLabel;
@property (nonatomic) UILabel *leftValueLabel;

@property (nonatomic) UILabel *rightTitleLabel;
@property (nonatomic) UILabel *rightValueLabel;

@property (nonatomic) UIView *separatorLineView;

@end

@implementation DMLDetailWeatherCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _leftTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _leftTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_leftTitleLabel];
        
        _leftValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftValueLabel.textAlignment = NSTextAlignmentLeft;
        _leftValueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _leftValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_leftValueLabel];
        
        _rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightTitleLabel.textAlignment = NSTextAlignmentLeft;
        _rightTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _rightTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_rightTitleLabel];
        
        _rightValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightValueLabel.textAlignment = NSTextAlignmentLeft;
        _rightValueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _rightValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_rightValueLabel];
        
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_separatorLineView];
        
        [self configureConstraintsForLeftTitleLabel];
        [self configureConstraintsForRightTitleLabel];
        [self configureConstraintsForLeftValueLabel];
        [self configureConstraintsForRightValueLabel];
        [self configureConstraintsForSeperatorLineView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.leftTitleLabel.text = nil;
    self.leftValueLabel.text = nil;
    
    self.rightTitleLabel.text = nil;
    self.rightValueLabel.text = nil;
    
    self.separatorLineView.hidden = NO;
}

#pragma mark - Private Methods

- (void)configureConstraintsForLeftTitleLabel
{
    [_leftTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightTitleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_rightTitleLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sPadding * 0.5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftTitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_leftValueLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForLeftValueLabel
{
    [_leftValueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftValueLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_leftTitleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_leftTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_leftValueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-sPadding * 0.5]];
}

- (void)configureConstraintsForRightTitleLabel
{
    [_rightTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_leftTitleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_leftTitleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForRightValueLabel
{
    [_rightValueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightValueLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_rightTitleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_leftValueLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightValueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_leftValueLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForSeperatorLineView
{
    _separatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
}

@end
