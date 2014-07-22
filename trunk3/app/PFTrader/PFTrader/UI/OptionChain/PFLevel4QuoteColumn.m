#import "PFLevel4QuoteColumn.h"

#import "PFLevel4QuoteCell.h"

@implementation PFLevel4QuoteColumn

+(id)strikeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"STRIKE", nil )
                       cellClass: [ PFNameCell class ] ];
}

+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > unsafe_delegate_ = delegate_;
   
   return [ self columnWithTitle: NSLocalizedString( @"ASK", nil )
                       cellClass: [ PFLevel4QuoteAskCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFLevel4QuoteAskCell* )grid_cell_;
              price_cell_.delegate = unsafe_delegate_;
           }];
}

+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > unsafe_delegate_ = delegate_;
   
   return [ self columnWithTitle: NSLocalizedString( @"BID", nil )
                       cellClass: [ PFLevel4QuoteBidCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFLevel4QuoteBidCell* )grid_cell_;
              price_cell_.delegate = unsafe_delegate_;
           }];
}

+(id)lastAndVolumeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST", nil )
                     secondTitle: NSLocalizedString( @"VOLUME", nil )
                       cellClass: [ PFLevel4QuoteLastAndVolumeCell class ] ];
}

+(id)askSizeAndBidSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ASIZE", nil )
                     secondTitle: NSLocalizedString( @"BSIZE", nil )
                       cellClass: [ PFLevel4QuoteAskSizeAndBidSizeCell class ] ];
}

+(id)deltaAndGammaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"DELTA", nil )
                     secondTitle: NSLocalizedString( @"GAMMA", nil )
                       cellClass: [ PFLevel4QuoteDeltaAndGammaCell class ] ];
}

+(id)vegaAndThetaColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"VEGA", nil )
                     secondTitle: NSLocalizedString( @"THETA", nil )
                       cellClass: [ PFLevel4QuoteVegaAndThetaCell class ] ];
}

@end
