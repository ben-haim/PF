#import "PFOptionChainViewController_iPad.h"

#import "PFLevel4QuoteColumn.h"
#import "PFLevel4QuoteColumn_iPad.h"

@implementation PFOptionChainViewController_iPad

-(NSArray*)optionChainColumns
{
   return @[[ PFLevel4QuoteColumn strikeColumn ]
           , [ PFLevel4QuoteColumn askColumnWithDelegate: self ]
           , [ PFLevel4QuoteColumn_iPad askSizeColumn ]
           , [ PFLevel4QuoteColumn bidColumnWithDelegate: self ]
           , [ PFLevel4QuoteColumn_iPad bidSizeColumn ]
           , [ PFLevel4QuoteColumn_iPad lastColumn ]
           , [ PFLevel4QuoteColumn_iPad volumeColumn ]
           , [ PFLevel4QuoteColumn_iPad deltaColumn ]
           , [ PFLevel4QuoteColumn_iPad gammaColumn ]
           , [ PFLevel4QuoteColumn_iPad vegaColumn ]
           , [ PFLevel4QuoteColumn_iPad thetaColumn ]];
}

@end
