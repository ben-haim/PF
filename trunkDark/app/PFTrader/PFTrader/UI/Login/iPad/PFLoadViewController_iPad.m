#import "PFLoadViewController_iPad.h"

@implementation PFLoadViewController_iPad

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskLandscape;
}

@end
