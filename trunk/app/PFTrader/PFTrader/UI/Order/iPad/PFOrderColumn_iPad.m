#import "PFOrderColumn_iPad.h"

#import "PFOrderCell_iPad.h"

@implementation PFOrderColumn_iPad

+(id)lastColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"LAST_PRICE", nil )
                       cellClass: [ PFOrderLastCell_iPad class ] ];
}

+(id)accountColumn
{
   return [ self columnWithTitle: NSLocalizedString( @"ACCOUNT", nil )
                       cellClass: [ PFOrderAccount_iPad class ] ];
}

@end
