#import "PFLevel2QuoteColumn.h"
#import "PFLevel2QuoteCell.h"

@implementation PFLevel2QuoteColumn

+(id)level2PriceColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > weak_delegate_ = delegate_;
   
   return [ self columnWithTitle: NSLocalizedString( @"PRICE", nil )
                       cellClass: [ PFLevel2QuotePriceCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFSymbolBidCell* )grid_cell_;
              price_cell_.delegate = weak_delegate_;
           } ];
}

+(id)level2SizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SIZE", nil )
                       cellClass: [ PFLevel2QuoteSizeCell class ] ];
}

+(id)level2CCYSizeColumnWithSymbolName:( NSString* )symbol_name_
{
   return [ self columnWithTitle: [ NSString stringWithFormat: @"%@ %@", symbol_name_, NSLocalizedString( @"SIZE", nil ) ]
                       cellClass: [ PFLevel2QuoteCCYSizeCell class ] ];
}

@end
