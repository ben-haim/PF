//
//  PFGeneralMenuViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 04.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFGeneralMenuViewController_iPad.h"
#import "PFMenuItem.h"
#import "PFSplitViewController.h"
#import "UIViewController+Wrapper.h"
#import "PFSystemHelper.h"
#import "PFPositionsViewController_iPad.h"
#import "PFMarketOperationsViewController_iPad.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>
#import <ProFinanceApi/ProFinanceApi.h>

@interface PFGeneralMenuViewController_iPad () < PFSessionDelegate >

@property ( nonatomic, strong ) UIViewController* contentController;

@end

@implementation PFGeneralMenuViewController_iPad

@synthesize contentController = _contentController;

-(void)dealloc
{
   self.contentController = nil;
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( badgeValueDidChangeNotification: )
                                                   name: PFMenuItemBadgeValueDidChangeNotification
                                                 object: nil ];
   
   if ( useFlatUI() )
   {
      CGRect table_rect_ = self.tabsTableView.frame;
      table_rect_.origin.y += 20.f;
      table_rect_.size.height -= 20.f;
      self.tabsTableView.frame = table_rect_;
      
      UIView* black_view_ = [ [ UIView alloc ] initWithFrame: CGRectMake( 0.f, 0.f, table_rect_.size.width, 20.f ) ];
      black_view_.backgroundColor = [ UIColor blackColor ];
      [ self.view addSubview: black_view_ ];
   }
}

-(void)performActionWithItem:( PFTabItem* )item_
{
   [ super performActionWithItem: item_ ];
   
   UIViewController* controller_ = item_.controller;
   
   if ( controller_ )
   {
      if ( ![ controller_ isMemberOfClass: [ PFPositionsViewController_iPad class ] ] && ![ controller_ isMemberOfClass: [ PFMarketOperationsViewController_iPad class ] ] )
      {
         item_.badgeValue = 0;
      }
      
      self.contentController = [ controller_ isKindOfClass: [ PFSplitViewController class ] ] ? controller_ : [ controller_ wrapIntoNavigationController ];
   }
   else
   {
      [ item_ performAction ];
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
   }
}

-(PFMenuItem*)menuItemWithType:( PFMenuItemType )type_
{
   return [ self.tabItems firstMatch: ^BOOL( id object_ ) { return [ ( PFMenuItem* )object_ type ] == type_; } ];
}

#pragma - mark PFSessionDelegate

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_
{
   if ( message_.senderId != session_.user.userId )
   {
      [ self menuItemWithType: PFMenuItemTypeChat ].badgeValue++;
   }
}

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   if ( [ PFSession sharedSession ].accounts.defaultAccount == account_ )
   {
      [ self menuItemWithType: PFMenuItemTypePositions ].badgeValue = [ PFSession sharedSession ].accounts.allPositions.count;
      [ self menuItemWithType: PFMenuItemTypeOrders ].badgeValue = [ PFSession sharedSession ].accounts.allActiveOrders.count;
   }
}

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories_
{
   [ self menuItemWithType: PFMenuItemTypeNews ].badgeValue += stories_.count;
}

@end
