#import "PFTradesViewController.h"

#import "PFGridView.h"

#import "PFTradeColumn.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTradesViewController () < PFSessionDelegate >

@end

@implementation PFTradesViewController

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
      self.title = NSLocalizedString( @"TRADES", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   self.elements = session_.accounts.allTrades;
   
   self.columns = [ NSArray arrayWithObjects: [ PFTradeColumn symbolColumn ]
                   , [ PFTradeColumn quantityColumn ]
                   , [ PFTradeColumn typeColumn ]
                   , [ PFTradeColumn grossPlColumn ]
                   , [ PFTradeColumn netPlColumn ]
                   , [ PFTradeColumn instrumentColumn ]
                   , [ PFTradeColumn orderIdColumn ]
                   , nil ];
   
   [ super viewDidLoad ];
}

-(void)session:( PFSession* )session_ didAddTrade:( id< PFTrade > )trade_
{
   self.elements = session_.accounts.allTrades;
   [ self reloadData ];
}

@end
