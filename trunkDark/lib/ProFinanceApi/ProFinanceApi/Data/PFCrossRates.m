#import "PFCrossRates.h"
#import "PFCrossRate.h"

#import "PFMessage.h"
#import "PFField.h"

@interface PFCrossRates ()

@property ( nonatomic, strong ) NSMutableDictionary* crossRatesDictionary;

@end

@implementation PFCrossRates

@synthesize crossRatesDictionary;

+(PFCrossRates*)sharedRates
{
   static PFCrossRates* shared_rates_ = nil;
   static dispatch_once_t onceToken;
   
   dispatch_once( &onceToken,
                 ^{
                    shared_rates_ = [ PFCrossRates new ];
                    shared_rates_.crossRatesDictionary = [ NSMutableDictionary new ];
                 } );
   
   return shared_rates_;
}

-(void)updateWithMessage:( PFMessage* )message_
{
   for ( PFGroupField* rate_group_ in [ message_ groupFieldsWithId: PFGroupCrossRate ] )
   {
      PFCrossRate* cross_rate_ = [ PFCrossRate objectWithFieldOwner: rate_group_.fieldOwner ];
      (self.crossRatesDictionary)[[ cross_rate_.exp1Name stringByAppendingFormat: @"/%@", cross_rate_.exp2Name ]] = cross_rate_;
   }
}

-(double)priceForCurrency:( NSString* )base_currency_
               toCurrency:( NSString* )to_currency_
{
   if ([base_currency_ isEqualToString: to_currency_])
      return 1.0;

   PFCrossRate* cross_rate_ = (self.crossRatesDictionary)[[ base_currency_ stringByAppendingFormat: @"/%@", to_currency_ ]];

   if (cross_rate_)
      return cross_rate_.price;

   cross_rate_ = (self.crossRatesDictionary)[[ to_currency_ stringByAppendingFormat: @"/%@", base_currency_ ]];

   return (cross_rate_) ? (1.0 / cross_rate_.price) : (-1.0);
}

@end