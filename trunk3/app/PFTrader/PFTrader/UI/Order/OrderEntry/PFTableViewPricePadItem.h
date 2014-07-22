#import "PFTableViewDecimalPadItem.h"

@protocol PFSymbol;

@interface PFTableViewPricePadItem : PFTableViewDecimalPadItem

@property ( nonatomic, assign, readonly ) double price;

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( double )price_;

+(id)itemWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( double )price_;

@end
