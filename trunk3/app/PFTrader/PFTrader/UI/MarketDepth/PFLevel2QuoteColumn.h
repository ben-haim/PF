#import "PFConcreteColumn.h"

#import <UIKit/UIKit.h>

@protocol PFSymbolPriceCellDelegate;

@interface PFLevel2QuoteColumn : PFConcreteColumn

+(id)level2PriceColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;
+(id)level2SizeColumn;
+(id)level2CCYSizeColumnWithSymbolName:( NSString* )symbol_name_;

@end
