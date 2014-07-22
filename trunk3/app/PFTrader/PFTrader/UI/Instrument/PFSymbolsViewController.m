#import "PFSymbolsViewController.h"

#import "PFSymbolColumn.h"
#import "PFSymbolCell.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSymbolsViewController ()< PFSessionDelegate, PFSymbolPriceCellDelegate >

@end

@implementation PFSymbolsViewController

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"SYMBOLS", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];

   self.elements = session_.symbols.symbols;

   self.columns = [ NSArray arrayWithObjects: [ PFSymbolColumn nameColumn ]
                   , [ PFSymbolColumn bidColumnWithDelegate: self ]
                   , [ PFSymbolColumn askColumnWithDelegate: self ]
                   , [ PFSymbolColumn bSizeColumn ]
                   , [ PFSymbolColumn aSizeColumn ]
                   , [ PFSymbolColumn lastColumn ]
                   , [ PFSymbolColumn spreadColumn ]
                   , [ PFSymbolColumn openColumn ]
                   , [ PFSymbolColumn closeColumn ]
                   , nil ];

   [ super viewDidLoad ];
}

#pragma mark PFSymbolPriceCellDelegate

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
             buySymbol:( id< PFSymbol > )symbol_
{
   NSLog( @"buy: %@", symbol_ );
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
            sellSymbol:( id< PFSymbol > )symbol_
{
   NSLog( @"sell: %@", symbol_ );
}

@end
