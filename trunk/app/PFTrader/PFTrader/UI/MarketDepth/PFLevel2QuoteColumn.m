#import "PFLevel2QuoteColumn.h"

#import "PFLevel2QuoteCell.h"

#import "UIImage+Skin.h"

@implementation PFLevel2QuoteColumn

+(id)priceColumnWithTitle:( NSString* )title_
                 delegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > unsafe_delegate_ = delegate_;

   return [ self columnWithTitle: title_
                       cellClass: [ PFLevel2QuotePriceCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFSymbolBidCell* )grid_cell_;
              [ price_cell_.priceButton setBackgroundImage: [ UIImage transparentButtonBackgroundImage ] forState: UIControlStateNormal ];
              [ price_cell_.priceButton setBackgroundImage: nil forState: UIControlStateHighlighted ];
              price_cell_.delegate = unsafe_delegate_;
           }];
}

+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   return [ self priceColumnWithTitle: NSLocalizedString( @"ASK", nil ) delegate: delegate_ ];
}

+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   return [ self priceColumnWithTitle: NSLocalizedString( @"BID", nil ) delegate: delegate_ ];
}

+(id)sizeColumnWithTitle:( NSString* )title_
{
   return [ self columnWithTitle: title_
                       cellClass: [ PFLevel2QuoteSizeCell class ] ];
}

+(id)bSizeColumn
{
   return [ self sizeColumnWithTitle: NSLocalizedString( @"BSIZE", nil ) ];
}

+(id)aSizeColumn
{
   return [ self sizeColumnWithTitle: NSLocalizedString( @"ASIZE", nil ) ];
}

@end
