#import <UIKit/UIKIt.h>

@interface UIImage (WhiteImage)

-(UIImage*)whiteImage;

@end

@interface UIImage (PFTableView)

+(UIImage*)tableAccessoryIndicatorImage;
+(UIImage*)tableAccessoryIndicatorImageWhite;
+(UIImage*)tableAccessoryIndicatorImageFlipped;
+(UIImage*)tableSectionSeparatorImage;
+(UIImage*)tableHeaderBackgroundImage;

+(UIImage*)topGroupedCellBackgroundImage;
+(UIImage*)bottomGroupedCellBackgroundImage;
+(UIImage*)middleGroupedCellBackgroundImage;
+(UIImage*)singleGroupedCellBackgroundImage;
+(UIImage*)singleGroupedCellBackgroundImageLight;
+(UIImage*)topGroupedCellBackgroundImageLight;
+(UIImage*)singleGroupedCellBackgroundImageSuperLight;

+(UIImage*)positionUpArrowImage;
+(UIImage*)positionDownArrowImage;
+(UIImage*)thinArrowClikImage;
+(UIImage*)thinArrowDefaultImage;

+(UIImage*)topGroupedCellBackgroundBlue;

+(UIImage*)groupedCellBackgroundImageForRow:( NSUInteger )row_
                                  rowsCount:( NSUInteger )rows_count_;

@end
