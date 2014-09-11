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
	
	
	// 初回のみ時間がかかるようです
	[NNProfiler start:@"resize"];
	[self.image imageByApplyingOptimizedBlurWithRadius:20 tintColor:nil saturationDeltaFactor:1 queue:nil completion:^(UIImage *result_img) {
		self.imageView.image = result_img;
		[NNProfiler end:@"resize"];
	}];
	
}



-(IBAction)hoge:(UISlider*)sender{
	NSDate* s = [NSDate date];
	
	self.imageView.image = [self.image imageByApplyingOptimizedBlurWithRadius:sender.value tintColor:nil saturationDeltaFactor:1];
	
	
	NSLog( @"raduis=%f %f", sender.value, [[NSDate date] timeIntervalSinceDate:s]*1000 );
}





@end
