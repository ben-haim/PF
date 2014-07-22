#import "PFTableViewPricePadItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewPricePadItem ()

@property ( nonatomic, assign ) double price;

@end

@implementation PFTableViewPricePadItem

@synthesize price;

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( PFDouble )price_
{
   double min_value_ = 1.0 / pow(10, symbol_.precision);
   
   self = [ super initWithName: title_ value: price_ minValue: min_value_ step: symbol_.pointSize ];
   
   if ( self )
   {
      self.price = price_;
   }
   
   return self;
}

+(id)itemWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( double )price_
{
   return [ [ self alloc ] initWithTitle: title_
                                  symbol: symbol_
                                   price: price_ ];
}

-(void)setValue:( NSString* )value_
{
   [ super setValue: value_ ];
   
   self.price = self.doubleValue;
}

@end
