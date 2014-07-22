#import "PFPositionCell_iPad.h"

#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFPositionNetPlCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.valueLabel showColouredValue: position_.netPl precision: position_.symbol.instrument.precisionExp1 dashIfValueZero: YES ];
}

@end

@implementation PFPositionOpenPriceCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = [ NSString stringWithPrice: position_.openPrice symbol: position_.symbol ];
}

@end

@implementation PFPositionGrossPlCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.valueLabel showColouredValue: position_.grossPl precision: position_.symbol.instrument.precisionExp1 dashIfValueZero: YES ];
}

@end

@implementation PFPositionPlTicksCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.valueLabel showColouredValue: position_.plTicks precision: 1 ];
}

@end

@implementation PFPositionCommissionCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = [ NSString stringWithAmount: (position_.commission == 0.0) ? (0.0) : (-1 * position_.commission)
                                              lotStep: position_.symbol.instrument.lotStepExp1 ];
}

@end

@implementation PFPositionSwapsCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self.valueLabel showColouredValue: position_.swap precision: position_.symbol.instrument.precisionExp1 ];
}

@end

@implementation PFPositionSlCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   NSString* price_string_ = [ NSString stringWithPrice: position_.stopLossPrice symbol: position_.symbol ];
   self.valueLabel.text = position_.stopLossOrder.orderType == PFOrderTrailingStop ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;
}

@end

@implementation PFPositionIdCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = [ NSString stringWithFormat: @"%d", position_.positionId ];
}

@end

@implementation PFPositionTpCell_iPad

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   self.valueLabel.text = [ NSString stringWithPrice: position_.takeProfitPrice symbol: position_.symbol ];
}

@end
