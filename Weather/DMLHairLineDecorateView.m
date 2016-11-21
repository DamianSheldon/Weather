//
//  DMLHairLineDecorateView.m
//  Weather
//
//  Created by DongMeiliang on 31/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "UIImage+DMLAdditions.h"

#import "DMLHairLineDecorateView.h"

@interface DMLHairLineDecorateView ()

@property (nonatomic) UIImageView *hairLineImageView;

@end

@implementation DMLHairLineDecorateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *hairLineImage = [UIImage dml_imageWithColor:[UIColor whiteColor]];
        hairLineImage = [hairLineImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
        
        _hairLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_hairLineImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _hairLineImageView.image = hairLineImage;
        [self.contentView addSubview:_hairLineImageView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hairLineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hairLineImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hairLineImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hairLineImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

@end
