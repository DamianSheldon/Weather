//
//  DMLCollectionViewHandOffLayoutAttributes.m
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import "DMLCollectionViewHandOffLayoutAttributes.h"

@implementation DMLCollectionViewHandOffLayoutAttributes

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath
{
    DMLCollectionViewHandOffLayoutAttributes *handOffLayoutAttributes = [super layoutAttributesForCellWithIndexPath:indexPath];
    [handOffLayoutAttributes commonInit];

    return handOffLayoutAttributes;
}

+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath
{
    DMLCollectionViewHandOffLayoutAttributes *handOffLayoutAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    [handOffLayoutAttributes commonInit];

    return handOffLayoutAttributes;
}

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath
{
    DMLCollectionViewHandOffLayoutAttributes *handOffLayoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    [handOffLayoutAttributes commonInit];
    
    return handOffLayoutAttributes;
}

- (void)commonInit
{
    self.initialOrigin = CGPointZero;
    self.overlayAlpha = 0;
}

#pragma mark - Override

- (id)copyWithZone:(nullable NSZone *)zone
{
    DMLCollectionViewHandOffLayoutAttributes *copy = [super copyWithZone:zone];
    copy.initialOrigin = self.initialOrigin;
    copy.overlayAlpha = self.overlayAlpha;
    
    return copy;
}

- (BOOL)isEqual:(id)object
{
    DMLCollectionViewHandOffLayoutAttributes *other = (DMLCollectionViewHandOffLayoutAttributes *)object;
    
    if (!CGPointEqualToPoint(self.initialOrigin, other.initialOrigin)) {
        return NO;
    }
    
    if (self.overlayAlpha != other.overlayAlpha) {
        return NO;
    }
    
    return [super isEqual:object];
}

@end
