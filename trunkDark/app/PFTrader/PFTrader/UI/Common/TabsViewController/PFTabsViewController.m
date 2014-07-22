//
//  PFTabsViewController.m
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabsViewController.h"
#import "PFTabItem.h"
#import "PFImageTabCell.h"
#import "PFNoImageTabCell.h"
#import "PFLayoutManager.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"
#import "UIImage+PFTableView.h"

@interface PFTabsViewController () < UITableViewDelegate, UITableViewDataSource >

@property ( nonatomic, strong ) NSArray* tabItems;
@property ( nonatomic, assign ) NSUInteger selectedTabIndex;

@end

@implementation PFTabsViewController

@synthesize tabsTableView;
@synthesize contentView;
@synthesize separatorView;
@synthesize bottomTabsView;
@synthesize headerView;
@synthesize tabItems;
@synthesize selectedTabIndex = _selectedTabIndex;

-(id)initWithTabItems:( NSArray* )tab_items_
     selectedTabIndex:( NSUInteger )selected_tab_index_
{
   self = [ self initWithNibName: @"PFTabsViewController" bundle: nil ];
   
   if ( self )
   {
      self.tabItems = tab_items_;
      self.selectedTabIndex = selected_tab_index_ < tab_items_.count ? selected_tab_index_ : 0;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.tabsTableView.bounces = NO;
   
   self.headerView.backgroundColor = [ UIColor backgroundLightColor ];
   self.headerView.image = [ UIImage thinShadowImage ];
   
   self.selectedTabIndex = _selectedTabIndex;
}

-(void)setSelectedTabIndex:( NSUInteger )selected_tabIndex_
{
   if ( selected_tabIndex_ < self.tabItems.count )
   {
      _selectedTabIndex = selected_tabIndex_;
      
      [ self.tabsTableView reloadData ];
      [ self performActionWithItem: (self.tabItems)[_selectedTabIndex] ];
   }
   else
   {
      [ self performActionWithItem: nil ];
   }
}

-(void)updateWithTabItems:( NSArray* )tab_items_
{
   self.tabItems = tab_items_;
   [ self.tabsTableView reloadData ];
   self.selectedTabIndex = 0;
}

-(void)performActionWithItem:( PFTabItem* )item_
{
   
}

-(void)useRemoveAllButton:( BOOL )use_
{
   self.bottomTabsView.hidden = !use_;
   
   CGRect tabs_rect_ = self.tabsTableView.frame;
   tabs_rect_.size.height = self.view.frame.size.height - ( self.headerView.hidden ? 0.f : self.headerView.frame.size.height ) - ( use_ ? self.bottomTabsView.frame.size.height : 0.f );
   self.tabsTableView.frame = tabs_rect_;
}

-(void)useHeaderView:( BOOL )use_
{
   self.headerView.hidden = !use_;
   
   CGRect tabs_rect_ = self.tabsTableView.frame;
   tabs_rect_.origin.y = use_ ? self.headerView.frame.size.height : 0.f;
   tabs_rect_.size.height = self.view.frame.size.height - tabs_rect_.origin.y;
   
   CGRect content_rect_ = self.contentView.frame;
   content_rect_.origin.y = tabs_rect_.origin.y;
   content_rect_.size.height = tabs_rect_.size.height;
   
   CGRect separator_rect_ = self.separatorView.frame;
   separator_rect_.origin.y = tabs_rect_.origin.y;
   separator_rect_.size.height = tabs_rect_.size.height;
   
   self.tabsTableView.frame = tabs_rect_;
   self.contentView.frame = content_rect_;
   self.separatorView.frame = separator_rect_;
}

-(IBAction)removeAllAction:( id )sender_
{
   
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscape;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return self.tabItems.count;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* image_cell_identifier_ = @"PFImageTabCell";
   static NSString* no_image_cell_identifier_ = @"PFNoImageTabCell";
   
   PFTabItem* current_item_ = (self.tabItems)[index_path_.row];
   UITableViewCell< PFTabCell >* cell_ = [ table_view_ dequeueReusableCellWithIdentifier: current_item_.icon ? image_cell_identifier_ : no_image_cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = current_item_.icon ? [ PFImageTabCell cell ] : [ PFNoImageTabCell cell ];
   }
   
   cell_.tabItem = current_item_;
   
   return cell_;
}

#pragma mark - UITableViewDelegate

-(void)tableView:( UITableView* )table_view_ willDisplayCell:( UITableViewCell* )cell_ forRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFTabItem* current_item_ = (self.tabItems)[index_path_.row];
   BOOL is_selected_ = index_path_.row == self.selectedTabIndex;
   
   
   cell_.contentView.backgroundColor = is_selected_ ? [ UIColor blueTextColor ] : [ UIColor clearColor ];
   
   if ( [ cell_ isKindOfClass: [ PFImageTabCell class ] ] )
   {
      PFImageTabCell* image_tab_cell_ = (PFImageTabCell*)cell_;
      
      image_tab_cell_.imageView.image = is_selected_ ? [ current_item_.icon whiteImage ] : current_item_.icon;
      image_tab_cell_.counterLabel.textColor = is_selected_ ? [ UIColor whiteColor ] : [ UIColor blueTextColor ];
      image_tab_cell_.titleLabel.textColor = is_selected_ ? [ UIColor whiteColor ] : [ UIColor blueTextColor ];
   }
   else if ( [ cell_ isKindOfClass: [ PFNoImageTabCell class ] ] )
   {
      PFNoImageTabCell* no_image_tab_cell_ = (PFNoImageTabCell*)cell_;
      
      no_image_tab_cell_.counterLabel.textColor = is_selected_ ? [ UIColor whiteColor ] : [ UIColor blueTextColor ];
      no_image_tab_cell_.titleLabel.textColor = is_selected_ ? [ UIColor whiteColor ] : [ UIColor blueTextColor ];
   }
}

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return 83.f;
}

-(void)tableView:( UITableView* )table_view_ didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
   [ table_view_ deselectRowAtIndexPath: index_path_ animated: NO ];
   self.selectedTabIndex = index_path_.row;
}

@end
