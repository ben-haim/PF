//
//  PFWatchlistInstrumentEditorViewController.m
//  PFTrader
//
//  Created by Denis on 29.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFWatchlistInstrumentEditorViewController.h"
#import "PFEditorInfoViewController.h"
#import "PFFilteredInstrumentGroup.h"
#import "PFTextField.h"
#import "PFTabItem.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>
#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFWatchlistInstrumentEditorViewController () < PFSessionDelegate, UITextFieldDelegate >

@property ( nonatomic, strong ) id< PFWatchlist > watchlist;
@property ( nonatomic, strong ) NSArray* groups;
@property ( nonatomic, strong ) UIViewController* contentController;
@property ( nonatomic, strong ) PFSearchField* searchField;

@end

@implementation PFWatchlistInstrumentEditorViewController

@synthesize watchlist;
@synthesize groups;
@synthesize contentController = _contentController;
@synthesize searchField;

+(NSArray*)filteredGroupsForWatchlist:( id< PFWatchlist > )watchlist_
                            serchterm:( NSString* )serrch_term_
{
   return [ PFFilteredInstrumentGroup filterGroups: [ PFSession sharedSession ].instruments.groups
                                      forWatchlist: watchlist_
                                        searchTerm: serrch_term_
                                              type: PFInstrumentGroupFilterAll
                                         skipEmpty: YES ];
}

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
   
   self.watchlist = nil;
   self.groups = nil;
   self.contentController = nil;
   self.searchField = nil;
}

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_
{
   NSArray* groups_ = [ PFWatchlistInstrumentEditorViewController filteredGroupsForWatchlist: watchlist_
                                                                                   serchterm: nil ];
   self = [ self initWithTabItems: [ groups_ map: ^id( id object_ )
                                    {
                                       PFFilteredInstrumentGroup* group_ = (PFFilteredInstrumentGroup*)object_;
                                       
                                       return [ PFTabItem itemWithControllerBuilder: ^UIViewController*()
                                               {
                                                  return [ [ PFEditorInfoViewController alloc ] initWithInstrumentGroup: group_
                                                                                                              watchlist: watchlist_ ];
                                               }
                                                                              title: group_.name
                                                                               icon: nil ];
                                    } ]
                 selectedTabIndex: 0 ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"WATCHLIST_EDITOR", nil );
      self.watchlist = watchlist_;
      self.groups = groups_;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.view.backgroundColor = [ UIColor backgroundLightColor ];
   self.tabsTableView.backgroundColor = [ UIColor backgroundDarkColor ];
   self.bottomTabsView.backgroundColor = [ UIColor backgroundDarkColor ];
   self.contentView.backgroundColor = [ UIColor backgroundLightColor ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( badgeValueDidChangeNotification: )
                                                   name: PFMenuItemBadgeValueDidChangeNotification
                                                 object: nil ];
   [ self useHeaderView: YES ];
   [ self useRemoveAllButton: YES ];
   
   self.searchField = [ [ PFSearchField alloc ] initWithFrame: CGRectMake( 10.f, 10.f, self.headerView.frame.size.width - 20.f, 30.f ) ];
   self.searchField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   self.searchField.delegate = self;
   [ self.searchField addTarget: self
                         action: @selector( filterAction )
               forControlEvents: UIControlEventEditingChanged ];
   
   if ( [ self.searchField respondsToSelector: @selector( setAttributedPlaceholder: ) ] )
   {
      self.searchField.attributedPlaceholder = [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @"SEARCH", nil )
                                                                                  attributes: @{ NSForegroundColorAttributeName: [ UIColor blueTextColor ] } ];
   }
   
   [ self.headerView addSubview: self.searchField ];
   
   [ self updateCounters ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setDarkNavigationBar ];
   }
}

-(IBAction)removeAllAction:( id )sender_
{
   __weak PFWatchlistInstrumentEditorViewController* weak_self_ = self;
   
   JFFAlertButton* close_all_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"REMOVE_ALL", nil )
                                                             action: ^( JFFAlertView* sender_ )
                                        {
                                           [ weak_self_.watchlist removeAllSymbols ];
                                           [ (PFEditorInfoViewController*)weak_self_.contentController updateTable ];
                                        } ];
   
   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: NSLocalizedString( @"REMOVE_ALL_SYMBOLS_PROMPT", nil )
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: close_all_button_
                                                       otherButtonsArray: nil ];
   
   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.view ];
}

-(void)filterAction
{
   self.groups = [ PFWatchlistInstrumentEditorViewController filteredGroupsForWatchlist: self.watchlist
                                                                              serchterm: self.searchField.text ];
   [ self updateWithTabItems: [ self.groups map: ^id( id object_ )
                               {
                                  PFFilteredInstrumentGroup* group_ = (PFFilteredInstrumentGroup*)object_;
                                  
                                  return [ PFTabItem itemWithControllerBuilder: ^UIViewController*()
                                          {
                                             return [ [ PFEditorInfoViewController alloc ] initWithInstrumentGroup: group_
                                                                                                         watchlist: self.watchlist ];
                                          }
                                                                         title: group_.name
                                                                          icon: nil ];
                               } ] ];
   [ self updateCounters ];
}

-(void)updateCounters
{
   for ( int index_ = 0; index_ < self.groups.count; index_++ )
   {
      NSUInteger active_symbols_count_ = 0;
      for ( id< PFSymbol > symbol_ in [ [ self.groups objectAtIndex: index_ ] symbols ] )
      {
         if ( [ self.watchlist containsSymbol: symbol_ ] )
         {
            active_symbols_count_++;
         }
      }
      [ (PFTabItem*)[ self.tabItems objectAtIndex: index_ ] setBadgeValue: active_symbols_count_ ];
   }
}
-(void)badgeValueDidChangeNotification:( NSNotification* )notification_
{
   [ self.tabsTableView reloadData ];
}

-(void)setContentController:(UIViewController *)content_controller_
{
   [ _contentController.view removeFromSuperview ];
   _contentController = nil;
   
   if ( content_controller_ )
   {
      _contentController = content_controller_;
      
      _contentController.view.frame = self.contentView.bounds;
      _contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [ _contentController.view removeFromSuperview ];
      [ self.contentView addSubview: _contentController.view ];
      [ (PFEditorInfoViewController*)self.contentController updateTable ];
   }
}

-(void)performActionWithItem:( PFTabItem* )item_
{
   [ super performActionWithItem: item_ ];
   
   self.contentController = item_.controller;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:( UITextField* )text_field_
{
   [ text_field_ resignFirstResponder ];
   return YES;
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_
{
   if ( self.watchlist == watchlist_ )
   {
      [ (PFEditorInfoViewController*)self.contentController updateTable ];
      [ self updateCounters ];
   }
}

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbols:( NSArray* )symbols_
{
   if ( self.watchlist == watchlist_ )
   {
      [ (PFEditorInfoViewController*)self.contentController updateTable ];
      [ self updateCounters ];
   }
}

@end
