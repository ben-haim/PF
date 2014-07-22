#import <UIKit/UIKIt.h>

@interface UIImage (PFTableView)

+(UIImage*)tableAccessoryIndicatorImage;

+(UIImage*)tableSectionSeparatorImage;

+(UIImage*)tableHeaderBackgroundImage;

+(UIImage*)topGroupedCellBackgroundImage;
+(UIImage*)bottomGroupedCellBackgroundImage;
+(UIImage*)middleGroupedCellBackgroundImage;
+(UIImage*)singleGroupedCellBackgroundImage;

+(UIImage*)groupedCellBackgroundImageForRow:( NSUInteger )row_
                                  rowsCount:( NSUInteger )rows_count_;

@end
