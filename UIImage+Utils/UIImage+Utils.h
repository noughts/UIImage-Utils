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

/// 先にリサイズして高速化したblur(非同期)
-(void)imageByApplyingOptimizedBlurWithRadius:(NSInteger)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor queue:(NSOperationQueue*)queue completion:(void (^)(UIImage* result_img))completion;

/// リサイズ
-(UIImage*)resizeImageWithScale:(double)scale;

/// 長辺の長さを指定してリサイズ
-(UIImage*)resizeWithLongSideLength:(NSInteger)length;

/// imageOrientationを変更
// カメラから来た画像はもともと正しく表示されるように設定されているが、picasaインフラにアップロードされると見た目に合わせてレンダリングされimageOrientationが0になるので、
// それを考慮して、どちらの画像でも正しくセットされるようにしてあります
-(UIImage*)imageByApplyingNormalizedOrientation:(UIImageOrientation)orientation;

@end
