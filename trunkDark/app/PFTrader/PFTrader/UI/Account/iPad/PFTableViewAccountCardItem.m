//
//  PFTableViewAccountCardItem.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewAccountCardItem.h"
#import "PFTableViewAccountCardItemCell.h"
#import "PFTableViewSelectedAccountCardItemCell.h"
#import "PFAccountCardsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewAccountCardItem ()

@property ( nonatomic, strong ) id< PFAccount > account;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewAccountCardItem

@synthesize account;
@synthesize currentController;

+(id)itemWithAccount:( id< PFAccount > )account_
          controller:( UIViewController* )controller_
{
   PFTableViewAccountCardItem* account_item_ = [ self itemWithAction: nil
                                                               title: account_.name ];
   account_item_.account = account_;
   account_item_.currentController = controller_;
   account_item_.accessoryType = [ account_item_ isSelected ] ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
   
   return account_item_;
}

-(PFAccountCardsViewController*)cardsController
{
   return (PFAccountCardsViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.account == self.cardsController.selectedAccount;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.cardsController.selectedAccount = self.account;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.cardsController.selectedAccount = nil;
   }
}

-(Class)cellClass
{
   return  [ self isSelected ] ? [ PFTableViewSelectedAccountCardItemCell class ] : [ PFTableViewAccountCardItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return [ self isSelected ] ? (271.0f + (!self.isActiveAccount)*50.0f - self.isMultiAsset*148.0f) : 44.0f;
}

-(BOOL)isActiveAccount
{
   return (self.account == [ PFSession sharedSession ].accounts.defaultAccount);
}

-(BOOL)isMultiAsset
{
   return self.account.accountType == PFAccountTypeMultiAsset;
}

@end
