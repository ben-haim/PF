#import "PFTradeColumn_iPad.h"

#import "PFTradeCell_iPad.h"

@implementation PFTradeColumn_iPad

+(id)grossPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                       cellClass: [ PFTradeGrossPlCell_iPad class ] ];
}

+(id)netPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"NET_PL", nil )
                       cellClass: [ PFTradeNetPlCell_iPad class ] ];
}

+(id)commissionColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"COMMISSION", nil )
                       cellClass: [ PFTradeCommissionCell_iPad class ] ];
}
+(id)tradeIdColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TRADE_ID", nil )
                       cellClass: [ PFTradeIdCell_iPad class ] ];
}

+(id)accountColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFTradeAccountCell_iPad class ] ];
}

@end
