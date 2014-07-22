#import "PFCommissionInterval.h"

@implementation PFCommissionInterval

@synthesize to;
@synthesize from;
@synthesize allPrice;
@synthesize buySellPrice;
@synthesize shortPrice;

-(id)initWithFrom: (int)from_ andTo: (int)to_
{
   from = from_;
   to = to_;
   allPrice = buySellPrice = shortPrice = 0;
   
   return self;
}

-(void)addAllPrice:(double)price_
{
   allPrice += price_;
}

-(void)addBuySellPrice:(double)price_
{
   buySellPrice += price_;
}

-(void)addShortPrice:(double)price_
{
   shortPrice += price_;
}

@end
