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
	return [UIImageEffects imageByApplyingBlurToImage:resized_img withRadius:10 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:nil];
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
		result_img = [UIImage imageWithCGImage:result_img.CGImage scale:resized_img.scale orientation:resized_img.imageOrientation];// オリジナル画像のscaleとorientationをセット
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completion( result_img );
		}];
	}];
}






-(UIImage*)resizeImageWithScale:(double)scale{
	int width = self.size.width * scale;
	int height = self.size.height * scale;
	
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



@end
