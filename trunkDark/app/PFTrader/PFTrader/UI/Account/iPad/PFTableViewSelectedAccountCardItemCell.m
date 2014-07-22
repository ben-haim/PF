//
//  PFTableViewSelectedAccountCardItemCell.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewSelectedAccountCardItemCell.h"
#import "PFTableViewAccountCardItem.h"
#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewSelectedAccountCardItemCell

@synthesize accountTitleLabel;
@synthesize headerView;
@synthesize arrowImageView;
@synthesize contentView;

@synthesize accountBalanceLabel;
@synthesize projectedBalanceLabel;
@synthesize accountValueLabel;
@synthesize marginAvaliableLabel;
@synthesize currentMarginLabel;
@synthesize marginWarningLabel;
@synthesize blockedBalanceLabel;
@synthesize cashBalanceLabel;
@synthesize withdrawalLabel;

@synthesize accountBalanceValueLabel;
@synthesize projectedBalanceValueLabel;
@synthesize accountValueValueLabel;
@synthesize marginAvaliableValueLabel;
@synthesize currentMarginValueLabel;
@synthesize marginWarningValueLabel;
@synthesize blockedBalanceValueLabel;
@synthesize cashBalanceValueLabel;
@synthesize withdrawalValueLabel;

@synthesize assetView;
@synthesize currentAssetTitleLable;
@synthesize currentAssetValueLabel;

@synthesize makeActiveButton;

-(Class)expectedItemClass
{
   return [ PFTableViewAccountCardItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImage ] ];
   self.headerView.image = [ UIImage topGroupedCellBackgroundImageLight ];
//   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
//                                                                                      action: @selector( headerTapAction ) ] ];

   self.accountBalanceLabel.textColor = [UIColor grayTextColor];
   self.projectedBalanceLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.marginAvaliableLabel.textColor = [UIColor grayTextColor];
   self.currentMarginLabel.textColor = [UIColor grayTextColor];
   self.marginWarningLabel.textColor = [UIColor grayTextColor];
   self.blockedBalanceLabel.textColor = [UIColor grayTextColor];
   self.cashBalanceLabel.textColor = [UIColor grayTextColor];
   self.withdrawalLabel.textColor = [UIColor grayTextColor];

   self.accountBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.projectedBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.accountValueValueLabel.textColor = [UIColor mainTextColor];
   self.marginAvaliableValueLabel.textColor = [UIColor mainTextColor];
   self.currentMarginValueLabel.textColor = [UIColor mainTextColor];
   self.marginWarningValueLabel.textColor = [UIColor mainTextColor];
   self.blockedBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.cashBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.withdrawalValueLabel.textColor = [UIColor mainTextColor];

   self.accountBalanceLabel.text = NSLocalizedString( @"ACCOUNT_BALANCE", nil );
   self.projectedBalanceLabel.text = NSLocalizedString( @"PROJECTED_BALANCE", nil );
   self.accountValueLabel.text = NSLocalizedString( @"ACCOUNT_VALUE", nil );
   self.marginAvaliableLabel.text = NSLocalizedString( @"MARGIN_AVAILABLE", nil );
   self.currentMarginLabel.text = NSLocalizedString( @"CURRENT_MARGIN", nil );
   self.marginWarningLabel.text = NSLocalizedString( @"MARGIN_WARNING", nil );
   self.blockedBalanceLabel.text = NSLocalizedString( @"BLOCKED_BALANCE", nil );
   self.cashBalanceLabel.text = NSLocalizedString( @"CASH_BALANCE", nil );
   self.withdrawalLabel.text = NSLocalizedString( @"WITHDRAWAL_AVAILABLE", nil );

   self.currentAssetTitleLable.textColor = [UIColor grayTextColor];
   self.currentAssetValueLabel.textColor = [UIColor mainTextColor];

   self.currentAssetTitleLable.text = [NSLocalizedString( @"CURRENT_ASSET", nil ) stringByAppendingString: @":"];
}

-(void)headerTapAction
{
   [ (PFTableViewAccountCardItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewAccountCardItem* account_item_ = ( PFTableViewAccountCardItem* )item_;
   id< PFAccount > currentAccount = account_item_.account;

   self.accountTitleLabel.text = currentAccount.name;

   if (currentAccount.accountType == PFAccountTypeMultiAsset)
   {
      self.contentView.hidden = YES;
      self.currentAssetValueLabel.text = currentAccount.currency;
      
      CGRect rect_ = self.makeActiveButton.frame;
      self.makeActiveButton.frame = CGRectMake(rect_.origin.x, 119.0f, rect_.size.width, rect_.size.height);
   }
   else
   {
      self.assetView.hidden = YES;

      [ self.accountBalanceValueLabel showAmount: currentAccount.balance
                                       precision: currentAccount.precision
                                        currency: currentAccount.currency ];

      [ self.projectedBalanceValueLabel showAmount: currentAccount.balance + currentAccount.totalGrossPl
                                         precision: currentAccount.precision
                                          currency: currentAccount.currency ];

      [ self.accountValueValueLabel showAmount: currentAccount.value
                                     precision: currentAccount.precision
                                      currency: currentAccount.currency ];

      [ self.marginAvaliableValueLabel showAmount: currentAccount.marginAvailable
                                        precision: currentAccount.precision
                                         currency: currentAccount.currency ];

      [ self.currentMarginValueLabel showAmount: currentAccount.usedMargin
                                      precision: currentAccount.precision
                                       currency: currentAccount.currency ];

      [ self.marginWarningValueLabel showAmount: currentAccount.marginWarning
                                      precision: currentAccount.precision
                                       currency: currentAccount.currency ];

      [ self.blockedBalanceValueLabel showAmount: currentAccount.blockedSum
                                       precision: currentAccount.precision
                                        currency: currentAccount.currency ];

      [ self.cashBalanceValueLabel showAmount: currentAccount.cashBalance
                                    precision: currentAccount.precision
                                     currency: currentAccount.currency ];

      [ self.withdrawalValueLabel showAmount: currentAccount.withdrawalAvailable
                                   precision: currentAccount.precision
                                    currency: currentAccount.currency ];
   }

   [ self.makeActiveButton setTitle: NSLocalizedString( @"MAKE_ACTIVE", nil ) forState: UIControlStateNormal ];

   if ( account_item_.isActiveAccount )
   {
      [ (UIImageView*)self.headerView setImage: [UIImage topGroupedCellBackgroundBlue] ];
      [ (UIImageView*)self.arrowImageView setImage: [ [UIImage imageNamed: @"PFAccessoryIndicatorDown"] whiteImage ] ];
      self.accountTitleLabel.textColor = [UIColor mainTextColor];
      makeActiveButton.hidden = true;
   }
   else
   {
      [ (UIImageView*)self.headerView setImage: [ UIImage topGroupedCellBackgroundImageLight ] ];
      [ (UIImageView*)self.arrowImageView setImage: [ UIImage imageNamed: @"PFAccessoryIndicatorDown" ] ];
      self.accountTitleLabel.textColor = [ UIColor blueTextColor ];
      makeActiveButton.hidden = false;
   }
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

- (IBAction)makeActiveAction:(id)sender
{
   PFTableViewAccountCardItem* account_item_ = (PFTableViewAccountCardItem*)self.item;
   [ [PFSession sharedSession] selectDefaultAccount: account_item_.account ];
}

@end
