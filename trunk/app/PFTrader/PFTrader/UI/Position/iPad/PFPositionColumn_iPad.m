#import "PFPositionColumn_iPad.h"

#import "PFPositionCell_iPad.h"

@implementation PFPositionColumn_iPad

+(id)netPLColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"NET_PL", nil )
                       cellClass: [ PFPositionNetPlCell_iPad class ] ];
}

+(id)openPriceColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"OPEN_PRICE", nil )
                       cellClass: [ PFPositionOpenPriceCell_iPad class ] ];
}

+(id)grossPlColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                       cellClass: [ PFPositionGrossPlCell_iPad class ] ];
}

+(id)plTicksColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"PL_TICKS", nil )
                       cellClass: [ PFPositionPlTicksCell_iPad class ] ];
}

+(id)commissionColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"COMMISSION", nil )
                       cellClass: [ PFPositionCommissionCell_iPad class ] ];
}

+(id)swapsColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SWAPS", nil )
                       cellClass: [ PFPositionSwapsCell_iPad class ] ];
}

+(id)slColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SL", nil )
                       cellClass: [ PFPositionSlCell_iPad class ] ];
}

+(id)positionIdColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"POSITION_ID", nil )
                       cellClass: [ PFPositionIdCell_iPad class ] ];
}

+(id)tpColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"TP", nil )
                       cellClass: [ PFPositionTpCell_iPad class ] ];
}

@end
