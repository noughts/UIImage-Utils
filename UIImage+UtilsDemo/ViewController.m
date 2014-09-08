#import "ViewController.h"
#import "UIImageEffects.h"

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
	self.image = [self resizeCGImage:self.image scale:0.1];
    [self updateImage:nil];
    
    [self showAlertForFirstRun];
    
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



-(UIImage*)resizeCGImage:(UIImage*)image scale:(double)scale {
	int width = image.size.width * scale;
	int height = image.size.height * scale;
	
	CGImageRef ref = image.CGImage;
	
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(ref);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 CGImageGetBitsPerComponent(ref),
												 CGImageGetBytesPerRow(ref),
												 colorspace,
												 CGImageGetBitmapInfo(ref));
	CGColorSpaceRelease(colorspace);
	
	if(context == NULL)
		return nil;
	
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage* output_img = [UIImage imageWithCGImage:imgRef scale:image.scale orientation:image.imageOrientation];
	CGImageRelease(imgRef);
	
	return output_img;
}


//| ----------------------------------------------------------------------------
- (void)updateImage:(id)sender
{
	NSDate* s = [NSDate date];
    NSString *effectText = @"";
    UIImage *effectImage = nil;
    
    switch (self.imageIndex)
    {
        case 0:
            effectImage = self.image;
            break;
        case 1:
            effectImage = [UIImageEffects imageByApplyingLightEffectToImage:self.image];
            effectText = NSLocalizedString(@"Light", @"");
            self.effectLabel.textColor = [UIColor darkTextColor];
            break;
        case 2:
            effectImage = [UIImageEffects imageByApplyingExtraLightEffectToImage:self.image];
            effectText = NSLocalizedString(@"Extra light", @"");
            self.effectLabel.textColor = [UIColor darkTextColor];
            break;
        case 3:
            effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:self.image];
            effectText = NSLocalizedString(@"Dark", @"");
            self.effectLabel.textColor = [UIColor lightTextColor];
            break;
        case 4:
            effectImage = [UIImageEffects imageByApplyingTintEffectWithColor:[UIColor blueColor] toImage:self.image];
            effectText = NSLocalizedString(@"Color tint", @"");
            self.effectLabel.textColor = [UIColor lightTextColor];
            break;
    }
    
    self.imageView.image = effectImage;
    self.effectLabel.text = effectText;
    
	NSLog( @"%f", [[NSDate date] timeIntervalSinceDate:s]*1000 );
}


//| ----------------------------------------------------------------------------
- (IBAction)nextEffect:(id)sender
{
    self.imageIndex++;
    
    if (self.imageIndex > 4)
    {
        self.imageIndex = 0;
    }
	
    [self updateImage:sender];
}


//| ----------------------------------------------------------------------------
- (void)showAlertForFirstRun
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString *DidFirstRunKey = @"DidFirstRun";
    BOOL didFirstRun = [userDefaults boolForKey:DidFirstRunKey];
    if (!didFirstRun)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tap to change image effect", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
        [alert show];
        [userDefaults setBool:YES forKey:DidFirstRunKey];
    }
}


@end
