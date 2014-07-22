#import "PFConcreteColumn.h"

#import <UIKit/UIKit.h>

@protocol PFSymbolPriceCellDelegate;

@interface PFLevel2QuoteColumn : PFConcreteColumn

+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;
+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;

+(id)bSizeColumn;
+(id)aSizeColumn;

@end
