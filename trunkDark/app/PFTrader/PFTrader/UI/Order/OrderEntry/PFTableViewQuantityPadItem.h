#import "PFTableViewDecimalPadItem.h"

@protocol PFSymbol;

@interface PFTableViewQuantityPadItem : PFTableViewDecimalPadItem

@property ( nonatomic, assign, readonly ) double lots;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
               lots:( double )lots_;

-(id)initWithLots:( double )lots_;

@end
