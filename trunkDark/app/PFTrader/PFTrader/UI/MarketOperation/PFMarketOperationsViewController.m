#import "PFMarketOperationsViewController.h"
#import "PFMarketOperationsDataSource.h"
#import "PFSegmentedControl.h"
#import "UIImage+Skin.h"
#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMarketOperationsViewController () < PFSegmentedControlDelegate >

@property ( nonatomic, strong ) NSArray* dataSources;
@property ( nonatomic, strong ) id< PFMarketOperationsDataSource > activeDataSource;
@property ( nonatomic, weak ) NSTimer* updateTimer;

@end

@implementation PFMarketOperationsViewController

@synthesize sourceSelector;
@synthesize headerView;
@synthesize selectedOrder = _selectedOrder;
@synthesize selectedTrade = _selectedTrade;
@synthesize selectedOperation = _selectedOperation;
@synthesize delegate;
@synthesize dataSources;
@synthesize activeDataSource;
@synthesize updateTimer;

-(void)dealloc
{
   [ self.activeDataSource deactivate ];
   self.dataSources = nil;
   self.activeDataSource = nil;
}

-(id)initWithNibName:( NSString* )nib_name_
              bundle:( NSBundle* )bundle_
{
   self = [ super initWithNibName: nib_name_ bundle: bundle_ ];
   
   if ( self )
   {
      self.title = self.navigationTitle;
   }
   
   return self;
}

-(NSString*)navigationTitle
{
   NSString* title_ = NSLocalizedString( @"ORDERS", nil );

   NSUInteger count_ = [self.activeDataSource isMemberOfClass: [PFActiveOperationsDataSource class]] ? [PFSession sharedSession].accounts.allActiveOrders.count : 0;
   if (count_ > 0)
      title_  = [ title_  stringByAppendingFormat: @" (%d)", (int)count_ ];

   return title_;
}

-(id)init
{
   return [ self initWithNibName: NSStringFromClass( [ self class ] )
                          bundle: nil ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.dataSources = @[ [ PFActiveOperationsDataSource new ],
                         [ PFFilledOperationsDataSource new ],
                         [ PFAllOperationsDataSource new ] ];
   
   self.sourceSelector.items = [ self.dataSources valueForKeyPath: @"@unionOfObjects.title" ];
   self.sourceSelector.selectedSegmentIndex = 0;

   if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
   {
      self.headerView.backgroundColor = [ UIColor backgroundLightColor ];
      self.headerView.image = [ UIImage thinShadowImage ];
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
                                                      selector: @selector( updateActiveDataSource )
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(void)updateActiveDataSource
{
   self.title = self.navigationTitle;
   [ self.activeDataSource updateCategoriesWithTitle: self.title ];
}

-(void)setSelectedOrder:( id< PFOrder > )selected_order_
{
   if ( _selectedOrder != selected_order_ )
   {
      _selectedOrder = selected_order_;
      [ self updateActiveDataSource ];
      
      if ( [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectOrder:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectOrder: _selectedOrder ];
      }
   }
}

-(void)setSelectedTrade:( id< PFTrade > )selected_trade_
{
   if ( _selectedTrade != selected_trade_ )
   {
      _selectedTrade = selected_trade_;
      [ self updateActiveDataSource ];
      
      if ( [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectTrade:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectTrade: _selectedTrade ];
      }
   }
}

-(void)setSelectedOperation:( id< PFMarketOperation > )selected_operation_
{
   if ( _selectedOperation != selected_operation_ )
   {
      _selectedOperation = selected_operation_;
      [ self updateActiveDataSource ];
      
      if ( [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectMarketOperation:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectMarketOperation: _selectedOperation ];
      }
   }
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self.activeDataSource deactivate ];
   self.activeDataSource = [ self.dataSources objectAtIndex: index_ ];
   [ self.activeDataSource activateInController: self ];

   self.title = self.navigationTitle;
   [ self.activeDataSource updateCategoriesWithTitle: self.title ];
   
   if ( self.delegate )
   {
      if ( index_ == 0 && [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectOrder:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectOrder: self.selectedOrder ];
      }
      else if ( index_ == 1 && [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectTrade:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectTrade: self.selectedTrade ];
      }
      else if ( index_ == 2 && [ self.delegate respondsToSelector: @selector(marketOperationsViewController:didSelectMarketOperation:) ] )
      {
         [ self.delegate marketOperationsViewController: self didSelectMarketOperation: self.selectedOperation ];
      }
   }
}

@end
