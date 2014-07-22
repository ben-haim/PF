#import "PFMarketOperationColumn.h"

#import "PFConcreteGridCell.h"
#import "PFMarketOperationCell.h"

@implementation PFMarketOperationColumn

+(id)symbolColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SYMBOL", nil )
                     secondTitle: NSLocalizedString( @"OPEN_TIME", nil )
                       cellClass: [ PFNameCell class ] ];
}

+(id)quantityColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"QUANTITY", nil )
                     secondTitle: NSLocalizedString( @"SIDE", nil )
                       cellClass: [ PFOperationQuantityCell class ] ];
}

+(id)slColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SL", nil )
                       cellClass: [ PFOperationSLCell class ] ];
}

+(id)tpColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TP", nil )
                       cellClass: [ PFOperationTPCell class ] ];
}

+(id)typeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TYPE", nil )
                     secondTitle: NSLocalizedString( @"PRICE", nil )
                       cellClass: [ PFOperationTypeCell class ] ];
}

+(id)accountColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ACCOUNT", nil )
                     secondTitle: NSLocalizedString( @"STOP_PRICE", nil )
                       cellClass: [ PFOperationAccountCell class ] ];
}

+(id)tifColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TIF", nil )
                     secondTitle: NSLocalizedString( @"ORDER_ID", nil )
                       cellClass: [ PFOperationTifCell class ] ];
}

+(id)instrumentTypeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"INSTRUMENT_TYPE", nil )
                       cellClass: [ PFOperationInstrumentTypeCell class ] ];
}

+(id)statusColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"STATUS", nil )
                       cellClass: [ PFOperationStatusCell class ] ];
}

+(id)orderIdColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"STATUS", nil )
                     secondTitle: NSLocalizedString( @"ORDER_ID", nil )
                       cellClass: [ PFOperationOrderIdCell class ] ];
}

@end
