//
//  PFTableViewAccountCardItemCell.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewAccountCardItemCell.h"
#import "PFTableViewAccountCardItem.h"
#import "UIImage+PFTableView.h"
#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewAccountCardItemCell

@synthesize accountTitleLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewAccountCardItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
}

-(BOOL)useWhiteAccessoryImage
{
   return ( (PFTableViewAccountCardItem*)self.item ).account == [ PFSession sharedSession ].accounts.defaultAccount;
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewAccountCardItem* account_item_ = ( PFTableViewAccountCardItem* )item_;
   BOOL is_default_account_ = account_item_.account == [ PFSession sharedSession ].accounts.defaultAccount;
   
   if ( is_default_account_ )
   {
      [ (UIImageView*)self.backgroundView setImage: [ UIImage blueButtonBackground ] ];
      self.accountTitleLabel.textColor = [ UIColor mainTextColor ];
   }
   else
   {
      [ (UIImageView*)self.backgroundView setImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
      self.accountTitleLabel.textColor = [ UIColor blueTextColor ];
   }
   
   self.accountTitleLabel.text = account_item_.account.name;
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

@end
