#import "PFTableViewMoneyItem.h"

#import "PFTableViewMoneyItemCell.h"

@implementation PFTableViewMoneyItem

@synthesize amount;
@synthesize currency;
@synthesize colorSign;

-(id)initWithTitle:( NSString* )title_
            amount:( double )amount_
          currency:( NSString* )currency_
         colorSign:( BOOL )color_sign_
{
   self = [ super initWithAction: nil
                           title: title_ ];
   if ( self )
   {
      self.amount = amount_;
      self.currency = currency_;
      self.colorSign = color_sign_;
   }
   return self;
}

+(id)itemWithTitle:( NSString* )title_
            amount:( double )amount_
          currency:( NSString* )currency_
         colorSign:( BOOL )color_sign_
{
   return [ [ self alloc ] initWithTitle: title_
                                  amount: amount_
                                currency: currency_
                               colorSign: color_sign_ ];
}

-(Class)cellClass
{
   return [ PFTableViewMoneyItemCell class ];
}

@end
