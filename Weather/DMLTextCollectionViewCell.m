//
//  DMLTextCollectionViewCell.m
//  Weather
//
//  Created by Meiliang Dong on 2018/7/2.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import "DMLTextCollectionViewCell.h"
#import "DMLCollectionViewHandOffLayoutAttributes.h"

static CGFloat const sMargin = 20.0;

@interface DMLTextCollectionViewCell ()

@property (nonatomic) UITextView *textView;

@property (nonatomic) UIView *topHairLineView;
@property (nonatomic) UIView *bottomHairLineView;

@end

@implementation DMLTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:nil];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_textView];
        
        _topHairLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topHairLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _topHairLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topHairLineView];
        
        _bottomHairLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomHairLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomHairLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomHairLineView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sMargin]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sMargin]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sMargin*0.5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-sMargin*0.5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_topHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    DMLCollectionViewHandOffLayoutAttributes *attributes = (DMLCollectionViewHandOffLayoutAttributes *)layoutAttributes;
    self.textView.alpha = attributes.overlayAlpha;
    
    self.topHairLineView.alpha = attributes.overlayAlpha;
    self.bottomHairLineView.alpha = attributes.overlayAlpha;
}

@end
