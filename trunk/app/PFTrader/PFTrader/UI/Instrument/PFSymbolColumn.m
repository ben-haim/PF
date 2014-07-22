#import "PFSymbolColumn.h"

#import "PFSymbolCell.h"

@implementation PFSymbolColumn

+(id)nameColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SYMBOL", nil )
                       cellClass: [ PFNameCell class ] ];
}

+(id)bidColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > unsafe_delegate_ = delegate_;

   return [ self columnWithTitle: NSLocalizedString( @"BID", nil )
                       cellClass: [ PFSymbolBidCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFSymbolBidCell* )grid_cell_;
              price_cell_.delegate = unsafe_delegate_;
           }];
}

+(id)askColumnWithDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   __weak id< PFSymbolPriceCellDelegate > unsafe_delegate_ = delegate_;

   return [ self columnWithTitle: NSLocalizedString( @"ASK", nil )
                       cellClass: [ PFSymbolAskCell class ]
                   doneCellBlock: ^( PFConcreteGridCell* grid_cell_, id context_ )
           {
              PFSymbolPriceCell* price_cell_ = ( PFSymbolBidCell* )grid_cell_;
              price_cell_.delegate = unsafe_delegate_;
           }];
}

+(id)bSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"BSIZE", nil )
                     secondTitle: NSLocalizedString( @"CHANGE_PERCENT", nil )
                       cellClass: [ PFSymbolBSizeCell class ] ];
}

+(id)aSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ASIZE", nil )
                     secondTitle: NSLocalizedString( @"CHANGE", nil )
                       cellClass: [ PFSymbolASizeCell class ] ];
}

+(id)lastColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST", nil )
                     secondTitle: NSLocalizedString( @"VOLUME", nil )
                       cellClass: [ PFSymbolLastCell class ] ];
}

+(id)spreadColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SPREAD", nil )
                     secondTitle: NSLocalizedString( @"LAST_UPDATE", nil )
                       cellClass: [ PFSymbolSpreadCell class ] ];
}

+(id)openColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"OPEN", nil )
                     secondTitle: NSLocalizedString( @"LOW", nil )
                       cellClass: [ PFSymbolOpenCell class ] ];
}
+(id)closeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CLOSE", nil )
                     secondTitle: NSLocalizedString( @"HIGH", nil )
                       cellClass: [ PFSymbolCloseCell class ] ];
}

@end
