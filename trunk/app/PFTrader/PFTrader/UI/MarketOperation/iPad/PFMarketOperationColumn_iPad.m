#import "PFMarketOperationColumn_iPad.h"

#import "PFMarketOperationCell_iPad.h"

@implementation PFMarketOperationColumn_iPad

+(id)symbolColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SYMBOL", nil )
                       cellClass: [ PFOperationNameCell_iPad class ] ];
}

+(id)quantityColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"QUANTITY", nil )
                       cellClass: [ PFOperationQuantityCell_iPad class ] ];
}

+(id)typeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TYPE", nil )
                       cellClass: [ PFOperationTypeCell_iPad class ] ];
}

+(id)tifColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TIF", nil )
                       cellClass: [ PFOperationTifCell_iPad class ] ];
}

+(id)accountColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFOperationAccountCell_iPad class ] ];

}

+(id)orderIdColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ORDER_ID", nil )
                       cellClass: [ PFOperationOrderIdCell_iPad class ] ];
}

+(id)sideColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SIDE", nil )
                       cellClass: [ PFOperationSideCell_iPad class ] ];
}

+(id)priceColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"PRICE", nil )
                       cellClass: [ PFOperationPriceCell_iPad class ] ];
}

+(id)dateTimeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"OPEN_TIME", nil )
                       cellClass: [ PFOperationDateTimeCell_iPad class ] ];
}

+(id)stopPriceColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"STOP_PRICE", nil )
                       cellClass: [ PFOperationStopPriceCell_iPad class ] ];
}

@end
