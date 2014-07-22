#import "PFSymbolColumn_iPad.h"

#import "PFSymbolCell_iPad.h"

@implementation PFSymbolColumn_iPad

+(id)bSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"BSIZE", nil )
                       cellClass: [ PFSymbolBSizeCell_iPad class ] ];
}

+(id)aSizeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ASIZE", nil )
                       cellClass: [ PFSymbolASizeCell_iPad class ] ];
}

+(id)lastColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST", nil )
                       cellClass: [ PFSymbolLastCell_iPad class ] ];
}

+(id)spreadColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"SPREAD", nil )
                       cellClass: [ PFSymbolSpreadCell_iPad class ] ];
}

+(id)openColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"OPEN", nil )
                       cellClass: [ PFSymbolOpenCell_iPad class ] ];
}
+(id)closeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CLOSE", nil )
                       cellClass: [ PFSymbolCloseCell_iPad class ] ];
}

+(id)changePercentColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CHANGE_PERCENT", nil )
                       cellClass: [ PFSymbolChangePercentCell_iPad class ] ];
}

+(id)changeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"CHANGE", nil )
                       cellClass: [ PFSymbolChangeCell_iPad class ] ];
}

+(id)volumeColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"VOLUME", nil )
                       cellClass: [ PFSymbolVolumeCell_iPad class ] ];
}

+(id)highColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"HIGH", nil )
                       cellClass: [ PFSymbolHighCell_iPad class ] ];
}

+(id)lowColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LOW", nil )
                       cellClass: [ PFSymbolLowCell_iPad class ] ];
   
}

+(id)lastUpdateColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST_UPDATE", nil )
                       cellClass: [ PFSymbolLastUpdateCell_iPad class ] ];
}

@end
