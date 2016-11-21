//
//  UIImage+DMLAdditions.m
//  Weather
//
//  Created by DongMeiliang on 31/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "UIImage+DMLAdditions.h"

@implementation UIImage (DMLAdditions)

+ (UIImage *)dml_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
