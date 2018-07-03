//
//  DMLCollectionViewHandOffLayout.m
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import "DMLCollectionViewHandOffLayout.h"
#import "DMLCollectionViewHandOffLayoutAttributes.h"
#import "DMLCollectionViewDelegateHandOffLayout.h"

static NSString * const sElementHeaderKey = @"Header";
static NSString * const sElementMenuKey = @"Menu";
static NSString * const sElementCellKey = @"Cell";

@interface DMLCollectionViewHandOffLayout ()

@property (nonatomic) NSMutableDictionary *cache;

@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) NSInteger zIndex;
@property (nonatomic) CGRect oldBounds;

@property (nonatomic) NSMutableArray *visibleLayoutAttributes;

@property (nonatomic) CGSize headerSize;
@property (nonatomic) CGSize menuSize;

@end

@implementation DMLCollectionViewHandOffLayout

+ (NSString *)kindOfElement:(DMLHandOffLayoutElement)element
{
    switch (element) {
        case DMLHandOffLayoutElementHeader:
            return @"Kind-DMLHandOffLayoutElementHeader";
            
        case DMLHandOffLayoutElementMenu:
            return @"Kind-DMLHandOffLayoutElementMenu";
        
        case DMLHandOffLayoutElementCell:
            return @"Kind-DMLHandOffLayoutElementCell";
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _cache = [NSMutableDictionary dictionary];
        _contentHeight = 0;
        _zIndex = 0;
        _oldBounds = CGRectZero;
        
        _visibleLayoutAttributes = [NSMutableArray array];
        
        _headerSize = CGSizeZero;
        _menuSize = CGSizeZero;
        
        _headerOverlayMaxAlphaValue = 1.0;
        _minHeaderHeight = 68.0;
    }
    return self;
}

- (Class)layoutAttributesClass
{
    return DMLCollectionViewHandOffLayoutAttributes.class;
}

#pragma mark - Core Layout Process

- (void)prepareLayout
{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
    [self prepareCache];
    self.contentHeight = 0;
    self.zIndex = 0;
    self.oldBounds = self.collectionView.bounds;
    
    id<DMLCollectionViewDelegateHandOffLayout> delegate = (id<DMLCollectionViewDelegateHandOffLayout>)self.collectionView.delegate;
    
    // Header
    DMLCollectionViewHandOffLayoutAttributes *headerAttributes = [DMLCollectionViewHandOffLayoutAttributes layoutAttributesForSupplementaryViewOfKind:[[self class] kindOfElement:DMLHandOffLayoutElementHeader]  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    self.headerSize = [delegate collectionViewReferenceSizeForHeader:self.collectionView handOffLayout:self];
    
    [self prepareElementWithKey:sElementHeaderKey size:self.headerSize attributes:headerAttributes];
    
    // Menu
    DMLCollectionViewHandOffLayoutAttributes *menuAttributes = [DMLCollectionViewHandOffLayoutAttributes layoutAttributesForSupplementaryViewOfKind:[[self class] kindOfElement:DMLHandOffLayoutElementMenu]  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    self.menuSize = [delegate collectionViewReferenceSizeForMenu:self.collectionView handOffLayout:self];
    
    [self prepareElementWithKey:sElementMenuKey size:self.menuSize attributes:menuAttributes];
    
    // Adjust height of header according content offset
    CGFloat yOffset = self.collectionView.contentOffset.y;
    CGFloat hMax = self.headerSize.height - self.minHeaderHeight;
    
    if (yOffset >= self.menuSize.height) {
        CGRect frame = headerAttributes.frame;
        
        if (yOffset <= hMax) {
            frame.size.height -= yOffset - self.menuSize.height;
        }
        else {
            frame.size.height = self.minHeaderHeight;
        }
        headerAttributes.frame = frame;
    }
    
    // Cell
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    
    NSInteger sections = [dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    for (NSInteger i = 0; i < sections; i++) {
        NSInteger rows = [dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        
        for (NSInteger j = 0; j < rows; j++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            DMLCollectionViewHandOffLayoutAttributes *attributes = [DMLCollectionViewHandOffLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            
            CGSize cellSize = [delegate collectionView:self.collectionView handOffLayout:self sizeForItemAtIndexPath:cellIndexPath];
            
            attributes.frame = CGRectMake(0, self.contentHeight, cellSize.width, cellSize.height);
            attributes.zIndex = self.zIndex;
            
            // Set alpha according to contentOffset
            if (!i) {
                if (yOffset > hMax + 0.3 * cellSize.height + j * cellSize.height) {
                    attributes.overlayAlpha = 0;
                }
                else {
                    attributes.overlayAlpha = 1.0;
                }
            }
            
            self.cache[sElementCellKey][cellIndexPath] = attributes;
            
            self.contentHeight = CGRectGetMaxY(attributes.frame);
            self.zIndex += 1;
        }
    }
    
    // Update header zIndex
    headerAttributes.zIndex = self.zIndex++;
    
    // Update menu zIndex
    menuAttributes.zIndex = self.zIndex++;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [self.visibleLayoutAttributes removeAllObjects];
    
    [self.cache enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableDictionary *elementInfos, BOOL * _Nonnull stop) {
        [elementInfos enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, DMLCollectionViewHandOffLayoutAttributes *attributes, BOOL * _Nonnull stop) {
            attributes.transform = CGAffineTransformIdentity;
            
            [self updateSupplementaryViewWithKey:key attributes:attributes collectionView:self.collectionView indexPath:indexPath];
            
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self.visibleLayoutAttributes addObject:attributes];
            }
        }];
    }];
    
    return self.visibleLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cache[sElementCellKey][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:[[self class] kindOfElement:DMLHandOffLayoutElementHeader]]) {
        return self.cache[sElementHeaderKey][indexPath];
    }
    
    if ([elementKind isEqualToString:[[self class] kindOfElement:DMLHandOffLayoutElementMenu]]) {
        return self.cache[sElementMenuKey][indexPath];
    }
    
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (!CGSizeEqualToSize(self.oldBounds.size, newBounds.size)) {
        [self.cache removeAllObjects];
    }
    return YES;
}

#pragma mark - Private Method

- (void)prepareCache
{
    [self.cache removeAllObjects];
    
    self.cache[sElementHeaderKey] = [NSMutableDictionary dictionary];
    self.cache[sElementMenuKey] = [NSMutableDictionary dictionary];
    self.cache[sElementCellKey] = [NSMutableDictionary dictionary];
}

- (void)prepareElementWithKey:(NSString *)key size:(CGSize)size attributes:(DMLCollectionViewHandOffLayoutAttributes *)attributes
{
    attributes.initialOrigin = CGPointMake(0, self.contentHeight);
    attributes.frame = CGRectMake(0, self.contentHeight, size.width, size.height);
    attributes.zIndex = self.zIndex;
    
    self.zIndex += 1;
    
    self.contentHeight = CGRectGetMaxY(attributes.frame);
    
    self.cache[key][attributes.indexPath] = attributes;
}

- (void)updateSupplementaryViewWithKey:(NSString *)key attributes:(DMLCollectionViewHandOffLayoutAttributes *)attributes collectionView:(UICollectionView *)cv indexPath:(NSIndexPath *)indexPath
{
    if ([key isEqualToString:sElementHeaderKey]) {
        CGFloat ty = MAX(0, cv.contentOffset.y);
        attributes.transform = CGAffineTransformMakeTranslation(0, ty);

        CGFloat distanceAffectAlpha = MIN(self.minHeaderHeight, ty);
        CGFloat alpha = self.headerOverlayMaxAlphaValue - distanceAffectAlpha/self.minHeaderHeight;

        attributes.overlayAlpha = alpha;
    }
    
    if ([key isEqualToString:sElementMenuKey]) {
        CGFloat ty = MAX(attributes.initialOrigin.y - self.minHeaderHeight, cv.contentOffset.y) - self.headerSize.height + self.minHeaderHeight;
        
        attributes.transform = CGAffineTransformMakeTranslation(0, ty);
        
        CGFloat yDelta = MAX(0, cv.contentOffset.y);
        
        CGFloat distanceAffectAlpha = MIN(self.minHeaderHeight, yDelta);
        CGFloat alpha = self.headerOverlayMaxAlphaValue - distanceAffectAlpha/self.minHeaderHeight;
        
        attributes.overlayAlpha = alpha;
    }
}

@end
