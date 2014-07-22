#import "PFWatchlistEditorViewController.h"

#import "PFWatchlistEditorGroupCell.h"
#import "PFWatchlistEditorSymbolCell.h"

#import "PFFilteredInstrumentGroup.h"

#import "PFSegmentedControl.h"

#import "PFLayoutManager.h"

#import "NSObject+KeyboardNotifications.h"
#import "UIImage+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistEditorViewController ()

@property ( nonatomic, strong ) id< PFWatchlist > watchlist;
@property ( nonatomic, strong ) NSArray* groups;

@end

@implementation PFWatchlistEditorViewController

@synthesize treeView;
@synthesize searchField;
@synthesize filterControl;

@synthesize watchlist;
@synthesize groups;

-(void)dealloc
{
   self.treeView.delegate = nil;
   self.treeView.dataSource = nil;

   self.treeView = nil;
   self.filterControl = nil;
   self.searchField = nil;
   self.groups = nil;
}

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];

   if ( self )
   {
      self.title = NSLocalizedString( @"WATCHLIST_EDITOR", nil );
      self.watchlist = watchlist_;
   }

   return self;
}

-(NSArray*)filteredGroups
{
   return [ PFFilteredInstrumentGroup filterGroups: [ PFSession sharedSession ].instruments.groups
                                      forWatchlist: self.watchlist
                                        searchTerm: self.searchField.text
                                              type: (int)self.filterControl.selectedSegmentIndex
                                         skipEmpty: YES ];
}

-(void)viewDidLoad
{
   self.filterControl.items = [ NSArray arrayWithObjects: NSLocalizedString( @"ACTIVE_MODE", nil )
                               , NSLocalizedString( @"ALL", nil )
                               , nil ];

   [ self.filterControl setSelectedSegmentIndex: 1 ];

   self.groups = [ self filteredGroups ];
   
   [ super viewDidLoad ];
}

-(void)updateTable
{
   self.groups = [ self filteredGroups ];
   [ self.treeView reloadData ];
}

-(IBAction)filterAction:( id )sender_
{
   [ self updateTable ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( [ PFLayoutManager currentLayoutManager ].shouldShrinkOnKeyboard )
   {
      [ self subscribeKeyboardNotifications ];
   }
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self unsubscribeKeyboardNotifications ];
}

-(void)didHideKeyboard
{
   self.treeView.contentInset = UIEdgeInsetsZero;
}

-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_
{
   UIEdgeInsets content_inset_ = UIEdgeInsetsZero;
   content_inset_.bottom = height_;

   self.treeView.contentInset = content_inset_;
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:( UITextField* )text_field_
{
   [ text_field_ resignFirstResponder ];
   return YES;
}

#pragma mark ETOneLevelTreeViewDataSource

-(NSInteger)numberOfRootItemsInTreeView:( ETOneLevelTreeView* )tree_view_
{
   return [ self.groups count ];
}

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isExpandableRootItemAtIndex:( NSInteger )root_index_
{
   return YES;
}

-(NSInteger)treeView:( ETOneLevelTreeView* )tree_view_
numberOfChildItemsForRootAtIndex:( NSInteger )root_index_
{
   id< PFInstrumentGroup > group_ = [ self.groups objectAtIndex: root_index_ ];
   return [ group_.symbols count ];
}

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
     cellForRootItemAtIndex:( NSInteger )root_index_
{
   PFWatchlistEditorGroupCell* group_cell_ = [ tree_view_ dequeueReusableCellWithIdentifier: @"PFWatchlistEditorGroupCell" ];
   if ( !group_cell_ )
   {
      group_cell_ = [ PFWatchlistEditorGroupCell cell ];
   }

   id< PFInstrumentGroup > group_ = [ self.groups objectAtIndex: root_index_ ];
   group_cell_.nameLabel.text = group_.name;
   group_cell_.disclosureView.image = [ tree_view_ isExpandedRootItemAtIndex: root_index_ ] ? [ UIImage expandedIndicatorImage ] : [ UIImage collapsedIndicatorImage ];

   return group_cell_;
}

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
    cellForChildItemAtIndex:( NSInteger )child_index_
                parentIndex:( NSInteger )root_index_
{
   PFWatchlistEditorSymbolCell* symbol_cell_ = [ tree_view_ dequeueReusableCellWithIdentifier: @"PFWatchlistEditorSymbolCell" ];
   if ( !symbol_cell_ )
   {
      symbol_cell_ = [ PFWatchlistEditorSymbolCell cell ];
   }
   
   id< PFInstrumentGroup > group_ = [ self.groups objectAtIndex: root_index_ ];
   id< PFSymbol > symbol_ = [ group_.symbols objectAtIndex: child_index_ ];

   [ symbol_cell_ setSymbol: symbol_ watchlist: self.watchlist ];

   return symbol_cell_;
}

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isInitiallyExpandedRootItemAtIndex:( NSInteger )root_index_
{
   return NO;
}

#pragma mark ETOneLevelTreeViewDelegate

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
heightForRootItemAtIndex:( NSInteger )root_index_
{
   return 30.f;
}

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
heightForChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_
{
   return 44.f;
}

#pragma mark PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self updateTable ];
}

@end
