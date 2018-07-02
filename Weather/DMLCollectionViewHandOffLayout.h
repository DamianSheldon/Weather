//
//  DMLCollectionViewHandOffLayout.h
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DMLHandOffLayoutElement) {
    DMLHandOffLayoutElementHeader,
    DMLHandOffLayoutElementMenu,
    DMLHandOffLayoutElementCell
};

@interface DMLCollectionViewHandOffLayout : UICollectionViewLayout

+ (NSString *)kindOfElement:(DMLHandOffLayoutElement)element;

@property (nonatomic) CGFloat minHeaderHeight; // Default is 68
@property (nonatomic) CGFloat headerOverlayMaxAlphaValue; // Default is 1.0

@end
