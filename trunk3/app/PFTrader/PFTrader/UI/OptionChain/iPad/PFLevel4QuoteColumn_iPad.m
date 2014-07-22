#import "PFLevel4QuoteColumn_iPad.h"

#import "PFLevel4QuoteCell_iPad.h"

@implementation PFLevel4QuoteColumn_iPad

+(id)lastColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST", nil )
                       cellClass: [ PFLevel4QuoteLastCell class ] ];
}

+(id)changeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CHANGE", nil )
                       cellClass: [ PFLevel4QuoteChangeCell class ] ];
}

+(id)tickerColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TICKER", nil )
                       cellClass: [ PFLevel4QuoteTickerCell class ] ];
}

+(id)volumeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"VOLUME", nil )
                       cellClass: [ PFLevel4QuoteVolumeCell class ] ];
}

+(id)askSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ASIZE", nil )
                       cellClass: [ PFLevel4QuoteAskSizeCell class ] ];
}

+(id)bidSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"BSIZE", nil )
                       cellClass: [ PFLevel4QuoteBidSizeCell class ] ];
}

+(id)openColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"OPEN", nil )
                       cellClass: [ PFLevel4QuoteOpenCell class ] ];
}

+(id)highColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"HIGH", nil )
                       cellClass: [ PFLevel4QuoteHighCell class ] ];
}

+(id)lowColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LOW", nil )
                       cellClass: [ PFLevel4QuoteLowCell class ] ];
}

+(id)closeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CLOSE", nil )
                       cellClass: [ PFLevel4QuoteCloseCell class ] ];
}

+(id)deltaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"DELTA", nil )
                       cellClass: [ PFLevel4QuoteDeltaCell class ] ];
}

+(id)gammaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"GAMMA", nil )
                       cellClass: [ PFLevel4QuoteGammaCell class ] ];
}

+(id)vegaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"VEGA", nil )
                       cellClass: [ PFLevel4QuoteVegaCell class ] ];
}

+(id)thetaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"THETA", nil )
                       cellClass: [ PFLevel4QuoteThetaCell class ] ];
}

@end
