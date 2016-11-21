//
//  DMLSubtitleTableCell.m
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLSubtitleTableCell.h"

static const CGFloat sPadding = 20.0;

@interface DMLSubtitleTableCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *titleValueLabel;

@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UILabel *subtitleValueLabel;

@end

@implementation DMLSubtitleTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        _titleValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleValueLabel.textAlignment = NSTextAlignmentLeft;
        _titleValueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _titleValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleValueLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        _subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _subtitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_subtitleLabel];
        
        _subtitleValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleValueLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleValueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _subtitleValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_subtitleValueLabel];
        
        [self configureConstraintsForTitleLabel];
        [self configureConstraintsForSubtitleLabel];
        [self configureConstraintsForTitleValueLabel];
        [self configureConstraintsForSubtitleValueLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
    self.titleValueLabel.text = nil;
    
    self.subtitleLabel.text = nil;
    self.subtitleValueLabel.text = nil;
}

#pragma mark - Private Methods

- (void)configureConstraintsForTitleLabel
{
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleValueLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sPadding * 0.5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_titleValueLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForTitleValueLabel
{
    [_titleValueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleValueLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleValueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForSubtitleLabel
{
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-sPadding * 0.5]];
}

- (void)configureConstraintsForSubtitleValueLabel
{
    [_subtitleValueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleValueLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleValueLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleValueLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleValueLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleValueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

@end
