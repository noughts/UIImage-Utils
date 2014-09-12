#import "ViewController.h"
#import "UIImageEffects.h"

#import "UIImage+Utils.h"
#import <mach/mach.h>
#import <mach/mach_time.h>
#import <NNProfiler/NNProfiler.h>
#import "UIImageEffects.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *effectLabel;

@property (nonatomic) UIImage *image;
@property (nonatomic) int imageIndex;

@end


@implementation ViewController

//| ----------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = [UIImage imageNamed:@"cheetah1136.png"];
	self.image = [UIImage imageWithCGImage:self.image.CGImage scale:1 orientation:UIImageOrientationDown];
	
	self.imageView.image = [self.image resizeImageWithScale:0.3];
	
//	return;

	
	[self testApplyOrientation];
}


-(void)testApplyOrientation{
	UIImage* img = [UIImage imageNamed:@"cheetah1136.png"];
	// カメラから来た画像をシミュレート(Portlait)
//	img = [self rotateImage:img angle:90];
//	img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationRight];
//	img = [img imageByApplyingOrientation:UIImageOrientationRight];
	
	img = [self rotateImage:img angle:180];
	img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDown];
	img = [img imageByApplyingOrientation:UIImageOrientationDown];
	
//	img = [self rotateImage:img angle:270];
//	img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationLeft];
//	img = [img imageByApplyingOrientation:UIImageOrientationUp];
	
	
	_imageView.image = img;
}



-(void)testResize{
	UIImage* hoge = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:UIImageOrientationRight];
	hoge = [hoge resizeImageWithScale:0.5];
}


-(void)testBlur{
	// 初回のみ時間がかかるようです
	[NNProfiler start:@"resize"];
	[self.image imageByApplyingOptimizedBlurWithRadius:2 tintColor:nil saturationDeltaFactor:1 queue:nil completion:^(UIImage *result_img) {
		self.imageView.image = result_img;
		[NNProfiler end:@"resize"];
	}];
}






-(IBAction)hoge:(UISlider*)sender{
	NSDate* s = [NSDate date];
	
	self.imageView.image = [self.image imageByApplyingOptimizedBlurWithRadius:sender.value tintColor:nil saturationDeltaFactor:1];
	NSLog( @"%@", NSStringFromCGSize(self.imageView.image.size) );
	NSLog( @"raduis=%f %f", sender.value, [[NSDate date] timeIntervalSinceDate:s]*1000 );
}












- (UIImage*)rotateImage:(UIImage*)img angle:(int)angle{
    CGImageRef      imgRef = [img CGImage];
    CGContextRef    context;
    
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.height, img.size.width), YES, img.scale);
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, M_PI_2);
            break;
        case 180:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.width, img.size.height), YES, img.scale);
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.height, img.size.width), YES, img.scale);
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI_2);
            break;
        default:
            return img;
            break;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage*    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}



@end
