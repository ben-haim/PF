#import "PFConcreteColumn.h"

#import <Foundation/Foundation.h>

@protocol PFSymbolPriceCellDelegate;

@interface PFSymbolColumn : PFConcreteColumn

+(id)nameColumn;

+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;
+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;

+(id)bSizeColumn;
+(id)aSizeColumn;

+(id)lastColumn;
+(id)spreadColumn;

+(id)openColumn;
+(id)closeColumn;

+(id)settlementPriceColumn;
+(id)openInterestColumn;

@end
