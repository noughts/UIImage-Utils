//
//  UIImage+Utils.h
//  UIImage+UtilsDemo
//
//  Created by noughts on 2014/09/08.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

/// 先にリサイズして高速化したblur
-(UIImage*)imageByApplyingOptimizedBlurWithRadius:(NSInteger)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

@end
