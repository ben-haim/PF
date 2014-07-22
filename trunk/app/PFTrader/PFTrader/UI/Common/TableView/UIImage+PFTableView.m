#import "UIImage+PFTableView.h"

#import "UIIMage+Stretch.h"

@implementation UIImage (PFTableView)

+(UIImage*)tableAccessoryIndicatorImage
{
   return [ UIImage imageNamed: @"PFAccessoryIndicator" ];
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
