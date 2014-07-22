#import "PFTableViewQuantityPadItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

static double PFMinLotsCount = 0.01;
static double PFLotStep = 0.01;

@interface PFTableViewQuantityPadItem ()

@property ( nonatomic, assign ) double lots;

@end

@implementation PFTableViewQuantityPadItem

@synthesize lots;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   return [ self initWithSymbol: symbol_ lots: symbol_.minimalLot ];
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
               lots:( double )lots_
{
   return [ self initWithLots: lots_
                   minimalLot: symbol_.minimalLot
                      lotStep: symbol_.lotStep ];
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
   self = [ super initWithName: [ NSString stringWithFormat: NSLocalizedString( @"QUANTITY_FORMAT", nil ), NSLocalizedString( @"QUANTITY", nil ) ]
                         value: lots_
                      minValue: minimal_lot_
                          step: lot_step_ ];
   
   if ( self )
   {
      self.lots = lots_;
   }
   
   return self;
}

-(void)setValue:( NSString* )value_
{
   [ super setValue: value_ ];
   
   self.lots = self.doubleValue;
}

@end
