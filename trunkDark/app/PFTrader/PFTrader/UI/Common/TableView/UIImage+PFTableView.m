#import "UIImage+PFTableView.h"
#import "UIIMage+Stretch.h"

@implementation UIImage (WhiteImage)

-(UIImage*)whiteImage
{
   CGRect rect_;
   
   rect_.origin.x = rect_.origin.y = 0;
   rect_.size = [ self size ];
   
   UIGraphicsBeginImageContextWithOptions( rect_.size, NO, 0.f );
   CGContextRef context_ = UIGraphicsGetCurrentContext();
   CGContextSetInterpolationQuality( context_,  kCGInterpolationHigh );
   CGContextConcatCTM( context_, CGAffineTransformMake( 1, 0, 0, -1, 0, rect_.size.height ) );
   CGContextClipToMask( context_, rect_, [ self CGImage ] );
   CGContextSetFillColorWithColor( context_, [ [ UIColor whiteColor ] CGColor ] );
   CGContextFillRect( context_, rect_ );
   UIImage* white_image_ = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   
   return white_image_;
}

@end

@implementation UIImage (PFTableView)

+(UIImage*)tableAccessoryIndicatorImage
{
   return [ UIImage imageNamed: @"PFAccessoryIndicator" ];
}

+(UIImage*)tableAccessoryIndicatorImageWhite
{
   return [ [ UIImage tableAccessoryIndicatorImage ] whiteImage ];
}

+(UIImage*)tableAccessoryIndicatorImageFlipped
{
   UIImage* source_image_ = [ UIImage tableAccessoryIndicatorImage ];
   
   return [ UIImage imageWithCGImage: source_image_.CGImage
                               scale: source_image_.scale
                         orientation: UIImageOrientationUpMirrored ];
}

+(UIImage*)tableSectionSeparatorImage
{
   return [ [ UIImage imageNamed: @"PFTableViewSeparatorLine" ] symmetricStretchableImage ];
}

+(UIImage*)tableHeaderBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFTableHeaderView" ] symmetricStretchableImage ];
}

+(UIImage*)topGroupedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFTopGroupedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)bottomGroupedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFBottomGroupedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)middleGroupedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFMiddleGroupedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)singleGroupedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFSingleGroupedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)singleGroupedCellBackgroundImageLight
{
   return [ [ UIImage imageNamed: @"PFSingleGroupedCellBackgroundLight" ] symmetricStretchableImage ];
}

+(UIImage*)thinArrowClikImage
{
   return [ [ UIImage imageNamed: @"PFThinArrowClik" ] symmetricStretchableImage ];
}

+(UIImage*)thinArrowDefaultImage
{
   return [ [ UIImage imageNamed: @"PFThinArrowDefault" ] symmetricStretchableImage ];
}

+(UIImage*)positionUpArrowImage
{
   return [ UIImage imageNamed: @"PFPositionUp" ];
}

+(UIImage*)positionDownArrowImage
{
   return [ UIImage imageNamed: @"PFPositionDown" ];
}

+(UIImage*)topGroupedCellBackgroundImageLight
{
   return [ [ UIImage imageNamed: @"PFTopGroupedCellBackgroundLight" ] symmetricStretchableImage ];
}

+(UIImage*)singleGroupedCellBackgroundImageSuperLight
{
   return [ [ UIImage imageNamed: @"PFSingleGroupedCellBackgroundSuperLight" ] symmetricStretchableImage ];
}

+(UIImage*)topGroupedCellBackgroundBlue
{
   return [ [ UIImage imageNamed: @"PFTopGroupedCellBackgroundBlue" ] symmetricStretchableImage ];
}

+(UIImage*)groupedCellBackgroundImageForRow:( NSUInteger )row_
                                  rowsCount:( NSUInteger )rows_count_
{
   if ( rows_count_ == 1 )
   {
      return [ UIImage singleGroupedCellBackgroundImage ];
   }
   else if ( row_ == 0 )
   {
      return [ UIImage topGroupedCellBackgroundImage ];
   }
   else if ( row_ == rows_count_ - 1 )
   {
      return [ UIImage bottomGroupedCellBackgroundImage ];
   }
   else
   {
      return [ UIImage middleGroupedCellBackgroundImage ];
   }

   return nil;
}

@end
