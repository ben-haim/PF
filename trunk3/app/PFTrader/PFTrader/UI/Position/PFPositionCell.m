#import "PFPositionCell.h"

#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "NSDate+Timestamp.h"
#import "PFInstrumentTypeConversion.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFPositionNetPlCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.topLabel showColouredValue: position_.netPl precision: position_.symbol.instrument.precisionExp1 dashIfValueZero: YES ];
   self.bottomLabel.text = [ NSString stringWithPrice: position_.openPrice symbol: position_.symbol ];
}

@end

@implementation PFPositionGrossPlCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.topLabel showColouredValue: position_.grossPl precision: position_.symbol.instrument.precisionExp1 dashIfValueZero: YES ];
   [ self.bottomLabel showColouredValue: position_.plTicks precision: 1 ];
}

@end

@implementation PFPositionCommissionCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.topLabel.text = [ NSString stringWithAmount: (position_.commission == 0.0) ? (0.0) : (-1 * position_.commission)
                                            lotStep: position_.symbol.instrument.lotStepExp1 ];
   [ self.bottomLabel showColouredValue: position_.swap precision: position_.symbol.instrument.precisionExp1 ];
}

@end

@implementation PFPositionSlCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   NSString* price_string_ = [ NSString stringWithPrice: position_.stopLossPrice symbol: position_.symbol ];
   
   self.topLabel.text = position_.stopLossOrder.orderType == PFOrderTrailingStop ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", position_.positionId ];
}

@end

@implementation PFPositionTpCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.topLabel.text = [ NSString stringWithPrice: position_.takeProfitPrice symbol: position_.symbol ];

   self.bottomLabel.text = NSStringForAssetClass( position_.symbol.instrument.type );
}

@end

@implementation PFPositionAccountCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = position_.account.name;
}

@end

@implementation PFPositionExpirationDateCell

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = position_.symbol.instrument.isFutures || position_.symbol.instrument.isOption ? [ position_.expirationDate shortDateString ] : @"-";
}

@end
