#import "PFTableViewQuantityPadItem.h"
#import "PFSettings.h"
#import <ProFinanceApi/ProFinanceApi.h>

static double PFMinLotsCount = 0.01;
static double PFLotStep = 0.01;

@interface PFTableViewQuantityPadItem ()

@property ( nonatomic, assign ) double lots;
@property ( nonatomic, assign ) double lotSize;

@end

@implementation PFTableViewQuantityPadItem

@synthesize lots;
@synthesize lotSize;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   return [ self initWithSymbol: symbol_ lots: symbol_.instrument.minimalLot ];
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
               lots:( double )lots_
{
   BOOL not_use_lots_ = ![ PFSettings sharedSettings ].showQuantityInLots;
   if ( not_use_lots_ )
   {
      self.lotSize = symbol_.instrument.lotSize;
   }
   
   return [ self initWithLots: not_use_lots_ ? lots_ * self.lotSize : lots_
                   minimalLot: not_use_lots_ ? symbol_.instrument.minimalLot * self.lotSize : symbol_.instrument.minimalLot
                      lotStep: not_use_lots_ ? symbol_.instrument.lotStep * self.lotSize : symbol_.instrument.lotStep ];
}

-(id)initWithLots:( double )lots_
{
   return [ self initWithLots: lots_
                   minimalLot: PFMinLotsCount
                      lotStep: PFLotStep ];
}

-(id)initWithLots:( double )lots_
       minimalLot:( double )minimal_lot_
          lotStep:( double )lot_step_
{
   NSString* title_ = lotSize > 0.0 ?
   NSLocalizedString( @"QUANTITY", nil ) :
   [ NSString stringWithFormat: NSLocalizedString( @"QUANTITY_FORMAT", nil ), NSLocalizedString( @"QUANTITY", nil ) ];
   
   self = [ super initWithName: title_
                         value: lots_
                      minValue: minimal_lot_
                          step: lot_step_ ];
   
   if ( self )
   {
      self.lots = self.lotSize > 0 ? lots_ / self.lotSize : lots_;
   }
   
   return self;
}

-(void)setValue:( NSString* )value_
{
   [ super setValue: value_ ];
   
   self.lots = self.lotSize > 0 ? self.doubleValue / self.lotSize : self.doubleValue;
}

@end
