#import "PFPositionsViewController.h"

#import "PFModifyPositionViewController.h"
#import "PFPositionColumn.h"
#import "PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@class PFGridFooterView;

@interface PFPositionsViewController ()< PFSessionDelegate >

@property ( nonatomic, weak ) NSTimer* updateTimer;
@property ( nonatomic, assign ) BOOL needReloadElements;

@end

@implementation PFPositionsViewController

@synthesize updateTimer;
@synthesize needReloadElements;

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
      self.title = NSLocalizedString( @"POSITIONS", nil );
   }
   return self;
}

-(NSArray*)positionsColumns
{
   return [ NSArray arrayWithObjects: [ PFPositionColumn symbolColumn ]
           , [ PFPositionColumn quantityColumn ]
           , [ PFPositionColumn netPlColumn ]
           , [ PFPositionColumn grossPlColumn ]
           , [ PFPositionColumn commissionColumn ]
           , [ PFPositionColumn slColumn ]
           , [ PFPositionColumn tpColumn ]
           , [ PFPositionColumn accountColumn ]
           , [ PFPositionColumn expirationDateColumn ]
           , nil ];
}

-(void)reloadBottomText
{
}

-(void)viewDidLoad
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   self.elements = [PFAccounts sortedOrdersByDateCreatedWithArray: session_.accounts.allPositions];
   self.columns = [ self positionsColumns ];

   [ super viewDidLoad ];
   
   [ self reloadBottomText ];
}

-(void)timerUpdate
{
   if ( self.needReloadElements )
   {
      PFSession* session_ = [ PFSession sharedSession ];
      self.elements = [PFAccounts sortedOrdersByDateCreatedWithArray: session_.accounts.allPositions];
      [ self reloadData ];
      self.needReloadElements = NO;
   }
   
   [ self updateRows ];
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];
   
   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(timerUpdate)
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

#pragma mark PFGridFooterViewDelegate

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
{
   JFFAlertButton* close_all_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CLOSE_ALL", nil )
                                                             action: ^( JFFAlertView* sender_ )
                                        {
                                           PFSession* session_ = [ PFSession sharedSession ];
                                           [ session_ closeAllPositionsForAccount: nil ];
                                        } ];

   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: NSLocalizedString( @"CLOSE_ALL_POSITIONS_PROMPT", nil )
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: close_all_button_
                                                       otherButtonsArray: nil ];

   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.view ];
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
   id< PFPosition > position_ = [ self.elements objectAtIndex: row_index_ ];
   
   if ( ![ [ PFSession sharedSession ] allowsTradingForSymbol: position_.symbol ] )
      return;
   
   [ [ [ PFModifyPositionViewController alloc ] initWithPosition: position_ ] showControllerWithController: self ];
}

-(void)handlePosition:( id< PFPosition > )position_
{
   if ( !self.needReloadElements )
   {
      self.needReloadElements = YES;
   }
}

-(void)session:( PFSession* )session_
didRemovePosition:( id< PFPosition > )position_
{
   [ self handlePosition: position_ ];
}

-(void)session:( PFSession* )session_
didAddPosition:( id< PFPosition > )position_
{
   [ self handlePosition: position_ ];
}

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self reloadBottomText ];
}

-(void)session:(PFSession *)session_
didSelectDefaultAccount:(id<PFAccount>)account_
{
   [ self reloadBottomText ];
}

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   self.elements = [PFAccounts sortedOrdersByDateCreatedWithArray: session_.accounts.allPositions];
   
   [ self reloadData ];
}

@end
