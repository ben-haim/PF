
#import "TiledBackground.h"


@implementation TiledBackground
@synthesize image = image_;

- (void)dealloc 
{
    [image_ release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
	if(image_==nil)
	{
        // Initialization code
        self.image = [UIImage imageNamed:@"panel_background_tile.gif"];
	}
    // Drawing code
    CGImageRef image = CGImageRetain(image_.CGImage);
	
    CGRect imageRect;
    imageRect.origin = CGPointMake(0.0, 0.0);
    imageRect.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	
    CGContextRef context = UIGraphicsGetCurrentContext();       
    CGContextClipToRect(context, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height));      
    CGContextDrawTiledImage(context, imageRect, image);
    CGImageRelease(image);
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
