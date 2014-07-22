#import "PFPositionColumn.h"

#import "PFPositionCell.h"

@implementation PFPositionColumn

+(id)netPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"NET_PL", nil )
                     secondTitle: NSLocalizedString( @"OPEN_PRICE", nil )
                       cellClass: [ PFPositionNetPlCell class ] ];
}

+(id)grossPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                     secondTitle: NSLocalizedString( @"PL_TICKS", nil )
                       cellClass: [ PFPositionGrossPlCell class ] ];
}

+(id)commissionColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"COMMISSION", nil )
                     secondTitle: NSLocalizedString( @"SWAPS", nil )
                       cellClass: [ PFPositionCommissionCell class ] ];
}

+(id)slColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SL", nil )
                     secondTitle: NSLocalizedString( @"POSITION_ID", nil )
                       cellClass: [ PFPositionSlCell class ] ];
}

+(id)tpColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TP", nil )
                     secondTitle: NSLocalizedString( @"INSTRUMENT_TYPE", nil )
                       cellClass: [ PFPositionTpCell class ] ];
}

+(id)accountColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFPositionAccountCell class ] ];
}

+(id)expirationDateColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"EXPIRATION_DATE", nil )
                       cellClass: [ PFPositionExpirationDateCell class ] ];
}

@end
