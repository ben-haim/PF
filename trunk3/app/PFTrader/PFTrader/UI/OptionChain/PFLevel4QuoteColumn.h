#import "PFConcreteColumn.h"

@protocol PFSymbolPriceCellDelegate;

@interface PFLevel4QuoteColumn : PFConcreteColumn

+(id)strikeColumn;

+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;
+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;

+(id)lastAndVolumeColumn;
+(id)askSizeAndBidSizeColumn;
+(id)deltaAndGammaColumn;
+(id)vegaAndThetaColumn;

@end
