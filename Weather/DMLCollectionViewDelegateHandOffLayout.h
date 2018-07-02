//
//  DMLCollectionViewDelegateHandOffLayout.h
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DMLCollectionViewHandOffLayout;

@protocol DMLCollectionViewDelegateHandOffLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionViewReferenceSizeForHeader:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout;

- (CGSize)collectionViewReferenceSizeForMenu:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout;

@end
