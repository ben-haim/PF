#import "PFTradeColumn.h"

#import "PFTradeCell.h"

@implementation PFTradeColumn

+(id)grossPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                     secondTitle: NSLocalizedString( @"COMMISSION", nil )
                       cellClass: [ PFTradeGrossPlCell class ] ];
}

+(id)netPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"NET_PL", nil )
                     secondTitle: NSLocalizedString( @"TRADE_ID", nil )
                       cellClass: [ PFTradeNetPlCell class ] ];
}

+(id)instrumentColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"INSTRUMENT_TYPE", nil )
                     secondTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFTradeInstrumentCell class ] ];
}

@end