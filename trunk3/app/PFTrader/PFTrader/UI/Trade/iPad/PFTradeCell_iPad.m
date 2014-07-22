#import "PFTradeCell_iPad.h"

#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTradeGrossPlCell_iPad

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = [ NSString stringWithAmount: trade_.grossPl lotStep: trade_.symbol.instrument.lotStepExp1 ];
}

@end

@implementation PFTradeCommissionCell_iPad

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = [ NSString stringWithAmount: trade_.commission == 0.0 ? 0.0 : ( -1 * trade_.commission )
                                              lotStep: trade_.symbol.instrument.lotStepExp1 ];
}

@end

@implementation PFTradeNetPlCell_iPad

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = [ NSString stringWithAmount: trade_.netPl lotStep: trade_.symbol.instrument.lotStepExp1 ];
}

@end

@implementation PFTradeIdCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = [ NSString stringWithFormat: @"%d", trade_.tradeId ];
}

@end

@implementation PFTradeAccountCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = trade_.account.name;
}

@end
