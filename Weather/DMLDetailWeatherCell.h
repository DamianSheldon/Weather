//
//  DMLSubtitleTableCell.h
//  Weather
//
//  Created by DongMeiliang on 27/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLDetailWeatherCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *leftTitleLabel;
@property (nonatomic, readonly) UILabel *leftValueLabel;

@property (nonatomic, readonly) UILabel *rightTitleLabel;
@property (nonatomic, readonly) UILabel *rightValueLabel;

@property (nonatomic, readonly) UIView *separatorLineView;

@end
