//
//  DMLHeader.h
//  Weather
//
//  Created by Meiliang Dong on 2018/6/27.
//  Copyright © 2018 Meiliang Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLHeader : UICollectionReusableView

@property (nonatomic, readonly) UILabel *locationLabel;
@property (nonatomic, readonly) UILabel *weatherLabel;
@property (nonatomic, readonly) UILabel *temperatureLabel;

@end
