#import "PFTradeCell.h"

#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "PFInstrumentTypeConversion.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTradeGrossPlCell

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = [ NSString stringWithMoney: trade_.grossPl ];
   self.bottomLabel.text = [ NSString stringWithMoney: trade_.commission == 0.0 ? 0.0 : ( -1 * trade_.commission ) ];
}

@end

@implementation PFTradeNetPlCell

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = [ NSString stringWithMoney: trade_.netPl ];
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", trade_.tradeId ];
}

@end

@implementation PFTradeInstrumentCell

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = NSStringForAssetClass( trade_.symbol.instrument.type );
   self.bottomLabel.text = trade_.account.name;
}

@end
