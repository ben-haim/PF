#import "UIImage+PFBuySellSelector.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFBuySellSelector)

+(UIImage*)buyButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedBuy" ] symmetricStretchableImage ];
}

+(UIImage*)selectedBuyButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedBuyActive" ] symmetricStretchableImage ];
}

+(UIImage*)sellButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedSell" ] symmetricStretchableImage ];
}

+(UIImage*)selectedSellButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedSellActive" ] symmetricStretchableImage ];
}

@end
