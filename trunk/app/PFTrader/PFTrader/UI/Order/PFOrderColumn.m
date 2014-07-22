#import "PFOrderColumn.h"

#import "PFOrderCell.h"

@implementation PFOrderColumn

+(id)lastColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST_PRICE", nil )
                     secondTitle: NSLocalizedString( @"SL", nil )
                       cellClass: [ PFOrderLastCell class ] ];
}

+(id)tifColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TIF", nil )
                     secondTitle: NSLocalizedString( @"TP", nil )
                       cellClass: [ PFOrderTifCell class ] ];
}

+(id)instrumentColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"INSTRUMENT_TYPE", nil )
                     secondTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFOrderInstrumentCell class ] ];
}

@end
