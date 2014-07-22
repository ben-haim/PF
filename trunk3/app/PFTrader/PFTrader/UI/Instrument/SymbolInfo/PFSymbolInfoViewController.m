#import "PFSymbolInfoViewController.h"

#import "PFWatchlistEditorGroupCell.h"
#import "PFSymbolInfoCell.h"
#import "PFSymbolInfoCell_iPad.h"
#import "UIImage+Skin.h"

#import "PFSymbolInfoRow.h"
#import "PFSymbolInfoGroup.h"

#import "DDMenuController+PFTrader.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSymbolInfoViewController () < PFSessionDelegate >

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) NSArray* groups;

@end

@implementation PFSymbolInfoViewController

@synthesize treeView;
@synthesize symbol;
@synthesize groups;

-(void)dealloc
{
   self.treeView.delegate = nil;
   self.treeView.dataSource = nil;
   
   [ [ PFSession sharedSession ] removeDelegate: self ];

   self.treeView = nil;
   self.groups = nil;
   self.symbol = nil;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.symbol = symbol_;
      self.title = [ self.symbol.name stringByAppendingFormat: @" %@", NSLocalizedString( @"SYMBOL_INFO", nil ) ];
   }
   
   return self;
}

-(NSArray*)symbolGroups
{
   return [ PFSymbolInfoGroup groupsForSymbol: self.symbol ];
}

-(void)viewDidLoad
{
   self.groups = [ self symbolGroups ];
   
   [ super viewDidLoad ];
   
   [ self.backgroundView removeFromSuperview ];
   self.view.backgroundColor = [ UIColor whiteColor ];
   
   NSArray* buttons_ = [ self.parentViewController.menuController.delegate leftBarButtonItemsInMenuController: self.parentViewController.menuController ];
   if ( [ UINavigationItem instancesRespondToSelector: @selector(leftBarButtonItems) ] && [ buttons_ count ] > 0 )
   {
      self.navigationItem.leftItemsSupplementBackButton = YES;
      self.navigationItem.leftBarButtonItems = buttons_;
   }
   
   [ [ PFSession sharedSession ] addDelegate: self ];
}

-(void)updateTable
{
   self.groups = [ self symbolGroups ];
   [ self.treeView reloadData ];
}

-(NSString*)nameForSymbolInfoGroup: ( id< PFSymbolInfoGroup > )group_
{
   switch ( group_.groupType )
   {
      case PFSymbolInfoGroupTypeTrading:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_TRADING", nil );
         
      case PFSymbolInfoGroupTypeMargin:
         return [NSString stringWithFormat:@"%@ - %@",
                 NSLocalizedString( @"SYMBOL_INFO_GROUP_MARGIN", nil ),
                 NSLocalizedString( @"SYMBOL_INFO_INIT_MAINT", nil )];
         
      case PFSymbolInfoGroupTypeFees:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_FEES", nil );
         
      case PFSymbolInfoGroupTypeSession:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_SESSION", nil );
         
      default:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_GENERAL", nil );
   }
}

#pragma mark - ETOneLevelTreeViewDataSource

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
   id< PFSymbolInfoGroup > group_ = [ self.groups objectAtIndex: root_index_ ];
   return [ group_.infoRows count ];
}

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
     cellForRootItemAtIndex:( NSInteger )root_index_
{
   PFWatchlistEditorGroupCell* group_cell_ = [ tree_view_ dequeueReusableCellWithIdentifier: @"PFSymbolInfoGroupCell" ];
   if ( !group_cell_ )
   {
      group_cell_ = [ PFWatchlistEditorGroupCell cell ];
   }
   
   group_cell_.nameLabel.text = [ self nameForSymbolInfoGroup: [ self.groups objectAtIndex: root_index_ ] ];
   group_cell_.disclosureView.image = [ tree_view_ isExpandedRootItemAtIndex: root_index_ ] ? [ UIImage expandedIndicatorImage ] : [ UIImage collapsedIndicatorImage ];
   
   return group_cell_;
}

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
    cellForChildItemAtIndex:( NSInteger )child_index_
                parentIndex:( NSInteger )root_index_
{
   PFSymbolInfoCell* symbol_info_cell_ = [ tree_view_ dequeueReusableCellWithIdentifier: @"PFSymbolInfoCell" ];
   
   if ( !symbol_info_cell_ )
   {
      symbol_info_cell_ = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [ PFSymbolInfoCell_iPad cell ] : [ PFSymbolInfoCell cell ];
   }

   id< PFSymbolInfoGroup > group_ = [ self.groups objectAtIndex: root_index_ ];
   id< PFSymbolInfoRow > info_row_ = [ group_.infoRows objectAtIndex: child_index_ ];
   
   [ symbol_info_cell_ setName: info_row_.name andValue: info_row_.value ];
   
   return symbol_info_cell_;
}

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isInitiallyExpandedRootItemAtIndex:( NSInteger )root_index_
{
   return NO;
}

#pragma mark - ETOneLevelTreeViewDelegate

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

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didReceiveTradingHaltForSymbol:( id< PFSymbol > )symbol_
{
   [ self updateTable ];
}

@end
