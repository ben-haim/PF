//
//  PFAccountInfoViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFAccountInfoViewController_iPad.h"
#import "PFAccountInfoViewController.h"
#import "PFAccountSpeedometr.h"
#import "PFTableView.h"
#import "PFTableViewCategory+AccountDetail.h"

#import "UIColor+Skin.h"
#import "UIImage+Skin.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountInfoViewController_iPad () < PFSessionDelegate >

@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation PFAccountInfoViewController_iPad

@synthesize account;

@synthesize headerView;
@synthesize assetTable;
@synthesize assetInfoTable;

@synthesize fundView;

@synthesize contentScrollView;

@synthesize firstTitleTodayLabel;
@synthesize secondTitleTodayLabel;
@synthesize thirdTitleTodayLabel;
@synthesize firstValueTodayLabel;
@synthesize secondValueTodayLabel;
@synthesize thirdValueTodayLabel;
@synthesize fifthTitleTodayLabel;
@synthesize fifthValueTodayLabel;

@synthesize currentFundCapitalActivityTitleLabel;
@synthesize fundCapitalGainActivityTitleLabel;
@synthesize investedFundCapitalActivityTitleLabel;

@synthesize todayLabel;

@synthesize firstTitleActivityLabel;
@synthesize secondTitleActivityLabel;
@synthesize thirdTitleActivityLabel;
@synthesize firstValueActivityLabel;
@synthesize secondValueActivityLabel;
@synthesize thirdValueActivityLabel;
@synthesize fifthTitleActivityLabel;
@synthesize sixthTitleActivityLabel;
@synthesize fifthValueActivityLabel;
@synthesize sixthValueActivityLabel;

@synthesize currentFundCapitalActivityValueLabel;
@synthesize fundCapitalGainActivityValueLabel;
@synthesize investedFundCapitalActivityValueLabel;

@synthesize activeLabel;

@synthesize accountSpeedometrTodayView;
@synthesize accountSpeedometrActivityView;

@synthesize realizedNetPLValueTodayLabel;
@synthesize realizedNetPLValueActivityLabel;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   if ( self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ] )
   {
      self.title = account_.name;
      self.account = account_;
   }
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   if ( self.account.accountType == PFAccountTypeMultiAsset )
   {
      self.headerView.backgroundColor = [ UIColor navigationBarColor ];
      self.headerView.image = [ UIImage thinShadowImage ];

      self.contentScrollView.hidden = YES;
      self.assetTable.tableView.scrollEnabled = NO;

      self.assetTable.categories = @[[ PFTableViewCategory assetAccountCategoryWithAccount: self.account ]];
      self.assetInfoTable.categories = @[[ PFTableViewCategory generalAssetCategoryWithAccount: self.account ]];

      self.assetTable.backgroundColor = [ UIColor clearColor ];
      self.assetInfoTable.backgroundColor = [ UIColor clearColor ];
      [ self.assetTable reloadData ];
   }
   else
   {
      todayLabel.text = NSLocalizedString( @"TODAY", nil );
      activeLabel.text = NSLocalizedString( @"ACTIVITY", nil );

      self.firstTitleActivityLabel.text = NSLocalizedString( @"OPEN_GROSS_PL", nil );
      self.secondTitleActivityLabel.text = NSLocalizedString( @"ORDERS_MARGIN", nil );
      self.thirdTitleActivityLabel.text = NSLocalizedString( @"POSITIONS_MARGIN", nil );
      self.fifthTitleActivityLabel.text = NSLocalizedString( @"N_ORDERS", nil );
      self.sixthTitleActivityLabel.text = NSLocalizedString( @"N_POSITIONS", nil );
      self.firstTitleTodayLabel.text = NSLocalizedString( @"GROSS_PL", nil );
      self.secondTitleTodayLabel.text = NSLocalizedString( @"VOLUME", nil );
      self.thirdTitleTodayLabel.text = NSLocalizedString( @"FEES", nil );
      self.fifthTitleTodayLabel.text = NSLocalizedString( @"TRADES", nil );

      self.firstValueTodayLabel.text = @"";
      self.secondValueTodayLabel.text = @"";
      self.thirdValueTodayLabel.text = @"";
      self.fifthValueTodayLabel.text = @"";

      self.firstValueActivityLabel.text = @"";
      self.secondValueActivityLabel.text = @"";
      self.thirdValueActivityLabel.text = @"";
      self.fifthValueActivityLabel.text = @"";
      self.sixthValueActivityLabel.text = @"";

      self.realizedNetPLValueTodayLabel.text = @"";
      self.realizedNetPLValueActivityLabel.text = @"";

      todayLabel.textColor = [UIColor grayTextColor];
      activeLabel.textColor = [UIColor grayTextColor];

      self.firstTitleTodayLabel.textColor = [UIColor grayTextColor];
      self.firstValueTodayLabel.textColor = [UIColor mainTextColor];
      self.secondTitleTodayLabel.textColor = [UIColor grayTextColor];
      self.secondValueTodayLabel.textColor = [UIColor mainTextColor];
      self.thirdTitleTodayLabel.textColor = [UIColor grayTextColor];
      self.thirdValueTodayLabel.textColor = [UIColor mainTextColor];
      self.fifthTitleTodayLabel.textColor = [UIColor grayTextColor];
      self.fifthValueTodayLabel.textColor = [UIColor mainTextColor];

      self.firstTitleActivityLabel.textColor = [UIColor grayTextColor];
      self.firstValueActivityLabel.textColor = [UIColor mainTextColor];
      self.secondTitleActivityLabel.textColor = [UIColor grayTextColor];
      self.secondValueActivityLabel.textColor = [UIColor mainTextColor];
      self.thirdTitleActivityLabel.textColor = [UIColor grayTextColor];
      self.thirdValueActivityLabel.textColor = [UIColor mainTextColor];
      self.fifthTitleActivityLabel.textColor = [UIColor grayTextColor];
      self.fifthValueActivityLabel.textColor = [UIColor mainTextColor];
      self.sixthValueActivityLabel.textColor = [UIColor mainTextColor];
      self.sixthTitleActivityLabel.textColor = [UIColor grayTextColor];

      self.currentFundCapitalActivityTitleLabel.textColor = [UIColor grayTextColor];
      self.fundCapitalGainActivityTitleLabel.textColor = [UIColor grayTextColor];
      self.investedFundCapitalActivityTitleLabel.textColor = [UIColor grayTextColor];

      self.currentFundCapitalActivityValueLabel.textColor = [UIColor mainTextColor];
      self.fundCapitalGainActivityValueLabel.textColor = [UIColor mainTextColor];
      self.investedFundCapitalActivityValueLabel.textColor = [UIColor mainTextColor];
      
      self.realizedNetPLValueTodayLabel.textColor = [UIColor grayTextColor];
      self.realizedNetPLValueActivityLabel.textColor = [UIColor grayTextColor];


      if (self.isFundVisible)
      {
         self.currentFundCapitalActivityTitleLabel.text = NSLocalizedString( @"CURRENT_FUND_CAPITAL", nil );
         self.fundCapitalGainActivityTitleLabel.text = NSLocalizedString( @"FUND_CAPITAL_GAIN", nil );
         self.investedFundCapitalActivityTitleLabel.text = NSLocalizedString( @"INVESTED_FUND_CAPITAL", nil );

         self.currentFundCapitalActivityValueLabel.text = @"";
         self.fundCapitalGainActivityValueLabel.text = @"";
         self.investedFundCapitalActivityValueLabel.text = @"";

         self.contentScrollView.contentSize = CGSizeMake( self.contentScrollView.frame.size.width, 670.f );
      }
      else
      {
         fundView.hidden = YES;
         self.contentScrollView.contentSize = CGSizeMake( self.contentScrollView.frame.size.width, 670.f - fundView.frame.size.height );
      }


      self.headerView.hidden = YES;
      self.assetInfoTable.hidden = YES;

      self.assetTable.categories = [ NSArray new ];
      self.assetInfoTable.categories = [ NSArray new ];
   }
}

+(id)infoControllerWithAccount:( id< PFAccount > )account_
{
   return [ [ self alloc ] initWithAccount: account_ ];
}

-(void)updateAccountInfo
{
   if ( self.account.accountType == PFAccountTypeMultiAsset )
   {
      self.assetInfoTable.categories = @[[ PFTableViewCategory generalAssetCategoryWithAccount: self.account ]];
      [ self.assetInfoTable reloadData ];
   }
   else
   {
      // Activity
      [ PFAccountInfoViewController displayMoneyStringWithLabel: self.firstValueActivityLabel
                                                         amount: self.account.totalGrossPl
                                                      precision: self.account.precision
                                                       currency: self.account.currency
                                                      colorSign: YES ];

      [ self.firstValueActivityLabel showPositiveNegativeColouredValue: self.account.totalGrossPl
                                                             precision: self.account.precision
                                                              currency: self.account.currency
                                                     negativeTextColor: [UIColor redTextColor]
                                                     positiveTextColor: [UIColor greenTextColor]
                                                         zeroTextColor: [UIColor mainTextColor]
                                                       dashIfValueZero: NO isPositiveSign: NO ];

      [ PFAccountInfoViewController displayMoneyStringWithLabel: self.secondValueActivityLabel
                                                         amount: self.account.blockedForOrders
                                                      precision: self.account.precision
                                                       currency: self.account.currency
                                                      colorSign: NO ];

      [ PFAccountInfoViewController displayMoneyStringWithLabel: self.thirdValueActivityLabel
                                                         amount: self.account.initMargin
                                                      precision: self.account.precision
                                                       currency: self.account.currency
                                                      colorSign: NO ];

      self.fifthValueActivityLabel.text = [ NSString stringWithFormat: @"%d", (int)self.account.orderSum ];
      self.sixthValueActivityLabel.text = [ NSString stringWithFormat: @"%d", (int)self.account.positionSum ];

      [ self.accountSpeedometrActivityView redrawWithPositiveValue: self.account.sumPositivePositionsNetPL
                                                  andNegativeValue: self.account.sumNegativePositionsNetPL ];

      [ self.realizedNetPLValueActivityLabel showPositiveNegativeColouredValue: self.account.realizedPositionsNetPl
                                                                     precision: self.account.precision
                                                                      currency: self.account.currency
                                                             negativeTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueActivityLabel
                                                                                                                    andColor: [UIColor redTextColor] ]
                                                             positiveTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueActivityLabel
                                                                                                                    andColor: [UIColor greenTextColor] ]
                                                                 zeroTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueActivityLabel
                                                                                                                    andColor: [UIColor grayTextColor] ]
                                                               dashIfValueZero: NO isPositiveSign: YES ];

      if (self.isFundVisible)
      {
         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.currentFundCapitalActivityValueLabel
                                                            amount: self.account.currentFundCapital
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.fundCapitalGainActivityValueLabel
                                                            amount: self.account.fundCapitalGain
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.investedFundCapitalActivityValueLabel
                                                            amount: self.account.investedFundCapital
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];
      }

      // Today
      [ self.firstValueTodayLabel showPositiveNegativeColouredValue: self.account.grossPl
                                                          precision: self.account.precision
                                                           currency: self.account.currency
                                                  negativeTextColor: [UIColor redTextColor]
                                                  positiveTextColor: [UIColor greenTextColor]
                                                      zeroTextColor: [UIColor mainTextColor]
                                                    dashIfValueZero: NO isPositiveSign: NO ];

      [ PFAccountInfoViewController displayMoneyStringWithLabel: self.thirdValueTodayLabel
                                                         amount: self.account.todayFees
                                                      precision: self.account.precision
                                                       currency: self.account.currency
                                                      colorSign: NO ];

      self.secondValueTodayLabel.text = [ NSString stringWithAmount: self.account.amount ];
      self.fifthValueTodayLabel.text = [ NSString stringWithFormat: @"%d", self.account.tradesCount ];

      [ self.accountSpeedometrTodayView redrawWithPositiveValue: self.account.sumPositiveFilledOrdersNetPL
                                               andNegativeValue: self.account.sumNegativeFilledOrdersNetPL ];

      [ self.realizedNetPLValueTodayLabel showPositiveNegativeColouredValue: self.account.realizedFilledOrdersNetPl
                                                                  precision: self.account.precision
                                                                   currency: self.account.currency
                                                          negativeTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueTodayLabel
                                                                                                                 andColor: [UIColor redTextColor] ]
                                                          positiveTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueTodayLabel
                                                                                                                 andColor: [UIColor greenTextColor] ]
                                                              zeroTextColor: [ PFAccountSpeedometr gradientImageWithLabel: self.realizedNetPLValueTodayLabel
                                                                                                                 andColor: [UIColor grayTextColor] ]
                                                            dashIfValueZero: NO isPositiveSign:YES ];
   }
}

-(BOOL)isFundVisible
{
   return (self.account.currentFundCapital  != 0.) &&
          (self.account.fundCapitalGain     != 0.) &&
          (self.account.investedFundCapital != 0.);
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self updateAccountInfo ];
}

@end
