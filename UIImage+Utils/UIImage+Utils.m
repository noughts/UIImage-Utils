//
//  UIImage+Utils.m
//  UIImage+UtilsDemo
//
//  Created by noughts on 2014/09/08.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "UIImage+Utils.h"
#import "UIImageEffects.h"

@implementation UIImage (Utils)

static NSOperationQueue* _imageProcessing_queue;


+(NSOperationQueue*)imageProcessingQueue{
	if( !_imageProcessing_queue ){
		_imageProcessing_queue = [[NSOperationQueue alloc] init];
		_imageProcessing_queue.maxConcurrentOperationCount = 1;
	}
	return _imageProcessing_queue;
}


/// 先にリサイズして高速化したblur
-(UIImage*)imageByApplyingOptimizedBlurWithRadius:(NSInteger)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor{
	if( blurRadius == 0 ){
		return self;
	}
	blurRadius++;
	UIImage* resized_img = [self resizeImageWithScale:1.0/blurRadius];
	UIImage* blured_img = [UIImageEffects imageByApplyingBlurToImage:resized_img withRadius:10 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:nil];
	blured_img = [UIImage imageWithCGImage:blured_img.CGImage scale:self.scale/blurRadius orientation:self.imageOrientation];// オリジナル画像のscaleとorientationをセット
	return blured_img;
}

/// 先にリサイズして高速化したblur(非同期)
-(void)imageByApplyingOptimizedBlurWithRadius:(NSInteger)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor queue:(NSOperationQueue*)queue completion:(void (^)(UIImage* result_img))completion{
	if( blurRadius == 0 ){
		completion( nil );
		return;
	}
	blurRadius++;
	
	if( !queue ){
		queue = [UIImage imageProcessingQueue];
	}
	
	[queue addOperationWithBlock:^{
		UIImage* resized_img = [self resizeImageWithScale:1.0/blurRadius];
		UIImage* result_img = [UIImageEffects imageByApplyingBlurToImage:resized_img withRadius:10 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:nil];
		result_img = [UIImage imageWithCGImage:result_img.CGImage scale:self.scale/blurRadius orientation:self.imageOrientation];// オリジナル画像のscaleとorientationをセット
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completion( result_img );
		}];
	}];
}


/// imageOrientationを変更
// カメラから来た画像はもともと正しく表示されるように設定されているが、picasaインフラにアップロードされると見た目に合わせてレンダリングされimageOrientationが0になるので、
// それを考慮して、どちらの画像でも正しくセットされるようにしてあります
-(UIImage*)imageByApplyingOrientation:(UIImageOrientation)orientation{
	UIImageOrientation fixedOrientation = orientation;
	if( self.imageOrientation == 0 ){
		switch (orientation) {
			case UIImageOrientationUp:// 0
				fixedOrientation = UIImageOrientationUp;// 0
				break;
			case UIImageOrientationDown:// 1
				fixedOrientation = UIImageOrientationDown;// 1
				break;
			case UIImageOrientationLeft:// 2
				fixedOrientation = UIImageOrientationLeft;// 2
				break;
			case UIImageOrientationRight:// 3
				fixedOrientation = UIImageOrientationRight;// 3
				break;
			default:
				break;
		}
	}
	if( self.imageOrientation == 1 ){
		switch (orientation) {
			case UIImageOrientationUp:// 0
				fixedOrientation = UIImageOrientationDown;// 1
				break;
			case UIImageOrientationDown:// 1
				fixedOrientation = UIImageOrientationUp;// 0
				break;
			case UIImageOrientationLeft:// 2
				fixedOrientation = UIImageOrientationLeft;// 2
				break;
			case UIImageOrientationRight:// 3
				fixedOrientation = UIImageOrientationRight;// 3
				break;
			default:
				break;
		}
	}
	if( self.imageOrientation == 2 ){
		switch (orientation) {
			case UIImageOrientationUp:// 0
				fixedOrientation = UIImageOrientationLeft;// 2
				break;
			case UIImageOrientationDown:// 1
				fixedOrientation = UIImageOrientationRight;// 3
				break;
			case UIImageOrientationLeft:// 2
				fixedOrientation = UIImageOrientationUp;// 0
				break;
			case UIImageOrientationRight:// 3
				fixedOrientation = UIImageOrientationDown;// 1
				break;
			default:
				break;
		}
	}
	if( self.imageOrientation == 3 ){
		switch (orientation) {
			case UIImageOrientationUp:// 0
				fixedOrientation = UIImageOrientationRight;// 3
				break;
			case UIImageOrientationDown:// 1
				fixedOrientation = UIImageOrientationLeft;// 2
				break;
			case UIImageOrientationLeft:// 2
				fixedOrientation = UIImageOrientationDown;// 1
				break;
			case UIImageOrientationRight:// 3
				fixedOrientation = UIImageOrientationUp;// 0
				break;
			default:
				break;
		}
	}

	return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:fixedOrientation];
}


/// リサイズ
-(UIImage*)resizeImageWithScale:(double)scale{
	if( scale > 1 ){
		return self;
	}
	int width = self.size.width * scale;
	int height = self.size.height * scale;
	if( self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight ){
		// 横方向に回転するときはwidthとheightを逆にする
		width = self.size.height * scale;
		height = self.size.width * scale;
	}
	
	
	CGImageRef ref = self.CGImage;
	
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(ref);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(ref), CGImageGetBytesPerRow(ref), colorspace, CGImageGetBitmapInfo(ref));
	CGColorSpaceRelease(colorspace);
	
	if(context == NULL)
		return nil;
	
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage* output_img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imgRef);
	
	return output_img;
}



/// 長辺の長さを指定してリサイズ
-(UIImage*)resizeWithLongSideLength:(NSInteger)length{
	double scale;
	if( self.size.width > self.size.height ){
		// 横長
		scale = length / self.size.width;
	} else {
		// 縦長
		scale = length / self.size.height;
	}
	return [self resizeImageWithScale:scale];
}





















@end
