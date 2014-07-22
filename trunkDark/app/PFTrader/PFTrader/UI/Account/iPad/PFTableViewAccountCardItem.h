//
//  PFTableViewAccountCardItem.h
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewItem.h"

@protocol PFAccount;

@interface PFTableViewAccountCardItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFAccount > account;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithAccount:( id< PFAccount > )account_
          controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

-(BOOL)isActiveAccount;

@end
