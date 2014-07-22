//
//  PFAccountCardsViewController.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFAccountCardsViewController.h"
#import "PFTableViewCategory+AccountCards.h"
#import "PFTableViewCategory.h"
#import "PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountCardsViewController () < PFSessionDelegate >

@end

@implementation PFAccountCardsViewController

@synthesize delegate;
@synthesize selectedAccount = _selectedAccount;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"ACCOUNTS", nil );
   }
   
   return self;
}

-(void)setSelectedAccount:( id< PFAccount > )selected_account_
{
   if ( _selectedAccount != selected_account_ )
   {
      _selectedAccount = selected_account_;
      [ self reloadData ];
      
      if ( [ self.delegate respondsToSelector: @selector(accountCardsViewController:didSelectAccount:) ] )
      {
         [ self.delegate accountCardsViewController: self
                                   didSelectAccount: selected_account_ ];
      }
   }
}

-(void)reloadData
{
   self.tableView.categories = [ PFTableViewCategory accountCardsCategoriesWithAccounts: [ PFSession sharedSession ].accounts.accounts
                                                                             controller: self ];
   [ self.tableView reloadData ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   self.tableView.skipCellsBackground = YES;
   [ self reloadData ];
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

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self reloadData ];
}

-(void)didReconnectedSessionWithNewSession:(PFSession *)session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self reloadData ];
}

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self.tableView reloadData ];
}

@end
