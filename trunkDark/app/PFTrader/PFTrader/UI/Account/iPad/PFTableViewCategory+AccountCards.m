//
//  PFTableViewCategory+AccountCards.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewCategory+AccountCards.h"
#import "PFTableViewAccountCardItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (AccountCards)

+(NSArray*)accountCardsCategoriesWithAccounts:( NSArray* )accounts_
                                   controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: accounts_.count ];
   
   for ( id< PFAccount > account_ in accounts_ )
   {
      PFTableViewAccountCardItem* account_item_ = [ PFTableViewAccountCardItem itemWithAccount: account_ controller: controller_ ];
      account_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewAccountCardItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: @[account_item_] ] ];
   }
   
   return categories_array_;
}

@end
