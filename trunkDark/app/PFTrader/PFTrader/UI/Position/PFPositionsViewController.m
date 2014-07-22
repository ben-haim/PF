#import "PFPositionsViewController.h"
#import "PFNavigationController.h"
#import "PFTableViewCard.h"
#import "PFTableViewCategory+Positions.h"
#import "PFTableViewPositionItemCell.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFPositionsViewController () < PFSessionDelegate >

@property ( nonatomic, assign ) BOOL needReloadElements;
@property ( nonatomic, weak ) NSTimer* updateTimer;

@end

@implementation PFPositionsViewController

@synthesize selectedPosition = _selectedPosition;
@synthesize delegate;
@synthesize updateTimer;
@synthesize needReloadElements;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   
   if ( self )
   {
      [self setTitle];
   }
   
   return self;
}

-(void)setTitle
{
   self.title = NSLocalizedString( @"POSITIONS", nil );

   NSUInteger count_ = [PFSession sharedSession].accounts.allPositions.count;
   if (count_ > 0)
      self.title = [ self.title stringByAppendingFormat: @" (%d)", (uint)count_ ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   self.tableView.skipCellsBackground = YES;
   [ self directUpdatePositions ];
   
   UIBarButtonItem* right_button_ = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFTrashButton" ]
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector( closeAllPositionsAction ) ];
   
   if ( self.pfNavigationWrapperController )
   {
      self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = right_button_;
   }
   else
   {
      self.navigationItem.rightBarButtonItem = right_button_;
   }
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setSuperLightNavigationBar ];
      self.view.backgroundColor = [ UIColor backgroundLightColor ];
   }
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];

   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector( updatePositions )
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(void)directUpdatePositions
{
   self.needReloadElements = NO;

   self.tableView.categories = [ PFTableViewCategory positionCategoriesWithPositions: [ PFAccounts sortedOrdersByDateCreatedWithArray:
                                                                                       [ PFSession sharedSession ].accounts.allPositions]
                                                                          controller: self ];


   [ self setTitle ];
   self.pfNavigationWrapperController.title = self.title;
   self.pfNavigationController.navigationTitle = self.title ;

   [ self.tableView reloadData ];
}

-(void)closeAllPositionsAction
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

-(void)updatePositions
{
   if ( self.needReloadElements )
   {
      [ self directUpdatePositions ];
   }
   else
   {
      NSMutableArray* cells_ = [ NSMutableArray new ];

      for ( NSInteger j = 0; j < self.tableView.tableView.numberOfSections; j++ )
      {
         for ( NSInteger i = 0; i < [ self.tableView.tableView numberOfRowsInSection: j ]; i++ )
         {
            id cell_ = [ self.tableView.tableView cellForRowAtIndexPath: [ NSIndexPath indexPathForRow: i inSection: j ] ];

            if ( cell_ )
            {
               [ cells_ addObject: cell_ ];
            }
         }
      }

      for ( PFTableViewPositionItemCell* cell_ in cells_ )
      {
         [ cell_ updateDataWithItem: cell_.item ];
      }
   }
}

-(void)setSelectedPosition:( id< PFPosition > )selected_position_
{
   if ( _selectedPosition != selected_position_ )
   {
      _selectedPosition = selected_position_;
      [ self directUpdatePositions ];
      
      if ( [ self.delegate respondsToSelector: @selector(positionsViewController:didSelectPosition:) ] )
      {
         [ self.delegate positionsViewController: self didSelectPosition: _selectedPosition ];
      }
   }
}

-(void)handlePosition:( id< PFPosition > )position_
{
   self.needReloadElements = YES;
}

#pragma mark - PFSessionDelegate

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

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self directUpdatePositions ];
}

@end
