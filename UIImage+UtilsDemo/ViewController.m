#import "ViewController.h"
#import "UIImageEffects.h"

#import "UIImage+Utils.h"
#import <mach/mach.h>
#import <mach/mach_time.h>

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1)
    {
        // There was a bug in iOS versions 7.0.x which caused vImage buffers
        // created using vImageBuffer_InitWithCGImage to be initialized with data
        // that had the reverse channel ordering (RGBA) if BOTH of the following
        // conditions were met:
        //      1) The vImage_CGImageFormat structure passed to
        //         vImageBuffer_InitWithCGImage was configured with
        //         (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
        //         for the bitmapInfo member.  That is, if you wanted a BGRA
        //         vImage buffer.
        //      2) The CGImage object passed to vImageBuffer_InitWithCGImage
        //         was loaded from an asset catalog.
        //
        // To reiterate, this bug only affected images loaded from asset
        // catalogs.
        //
        // The workaround is to setup a bitmap context, draw the image, and
        // capture the contents of the bitmap context in a new image.
        UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
        [self.image drawAtPoint:CGPointZero];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}



-(IBAction)hoge:(UISlider*)sender{
	NSDate* s = [NSDate date];
	
	self.imageView.image = [self.image imageByApplyingOptimizedBlurWithRadius:sender.value tintColor:nil saturationDeltaFactor:1];
	
	
	NSLog( @"%f", [[NSDate date] timeIntervalSinceDate:s]*1000 );
}





@end
