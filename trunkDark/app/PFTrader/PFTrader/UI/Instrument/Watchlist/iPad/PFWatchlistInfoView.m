//
//  PFOrdersInfo.m
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFWatchlistInfoView.h"

#import "UIView+LoadFromNib.h"
#import "UIColor+Skin.h"
#import "UILabel+Price.h"
#import "UIImage+Icons.h"
#import "NSString+DoubleFormatter.h"
#import "PFInstrumentTypeConversion.h"

#import "PFOrderEntryViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistInfoView ()

@property ( nonatomic, strong ) id< PFSymbol > currentSymbol;

@end

@implementation PFWatchlistInfoView

@synthesize currentSymbol;

@synthesize bidNameLabel;
@synthesize spreadNameLabel;
@synthesize askNameLabel;
@synthesize changeNameLabel;
@synthesize lastNameLabel;
@synthesize closeNameLabel;
@synthesize highNameLabel;
@synthesize lowNameLabel;
@synthesize openNameLabel;

@synthesize valueNameLabel;
@synthesize openInterNameLabel;
@synthesize symbolTypeNameLabel;
@synthesize tickSizeNameLabel;
@synthesize prevSettlPriceNameLabel;
@synthesize settlPriceNameLabel;

@synthesize bidValueLabel;
@synthesize spreadValueLabel;
@synthesize askValueLabel;
@synthesize changeValueLabel;
@synthesize lastValueLabel;
@synthesize closeValueLabel;
@synthesize highValueLabel;
@synthesize lowValueLabel;
@synthesize openValueLabel;

@synthesize valueValueLabel;
@synthesize openInterValueLabel;
@synthesize symbolValueLabel;
@synthesize tickValueLabel;
@synthesize prevSettlPriceValueLabel;
@synthesize settlPriceValueLabel;

@synthesize orederEntryButton;
@synthesize createOrderLabel;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   [ self.orederEntryButton setImage: [ UIImage orderEntryBigIcon ] forState: UIControlStateNormal ];
   [ self.orederEntryButton setImage: [ UIImage orderEntryBigIcon ] forState: UIControlStateHighlighted ];

   self.bidNameLabel.textColor = [UIColor mainTextColor];
   self.changeNameLabel.textColor = [UIColor mainTextColor];
   self.highNameLabel.textColor = [UIColor mainTextColor];
   self.spreadNameLabel.textColor = [UIColor mainTextColor];
   self.lastNameLabel.textColor = [UIColor mainTextColor];
   self.lowNameLabel.textColor = [UIColor mainTextColor];
   self.askNameLabel.textColor = [UIColor mainTextColor];
   self.closeNameLabel.textColor = [UIColor mainTextColor];
   self.openNameLabel.textColor = [UIColor mainTextColor];

   self.bidValueLabel.textColor = [UIColor grayTextColor];
   self.spreadValueLabel.textColor = [UIColor grayTextColor];
   self.askValueLabel.textColor = [UIColor grayTextColor];
   self.changeValueLabel.textColor = [UIColor grayTextColor];
   self.lastValueLabel.textColor = [UIColor grayTextColor];
   self.closeValueLabel.textColor = [UIColor grayTextColor];
   self.highValueLabel.textColor = [UIColor grayTextColor];
   self.lowValueLabel.textColor = [UIColor grayTextColor];
   self.openValueLabel.textColor = [UIColor grayTextColor];

   self.valueNameLabel.textColor = [UIColor mainTextColor];
   self.openInterNameLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeNameLabel.textColor = [UIColor mainTextColor];
   self.tickSizeNameLabel.textColor = [UIColor mainTextColor];
   self.prevSettlPriceNameLabel.textColor = [UIColor mainTextColor];
   self.settlPriceNameLabel.textColor = [UIColor mainTextColor];

   self.valueValueLabel.textColor = [UIColor grayTextColor];
   self.openInterValueLabel.textColor = [UIColor grayTextColor];
   self.symbolValueLabel.textColor = [UIColor grayTextColor];
   self.tickValueLabel.textColor = [UIColor grayTextColor];
   self.prevSettlPriceValueLabel.textColor = [UIColor grayTextColor];
   self.settlPriceValueLabel.textColor = [UIColor grayTextColor];

   self.createOrderLabel.textColor = [UIColor grayTextColor];

   self.bidNameLabel.text = NSLocalizedString( @"DASHBOARD_BID", nil );
   self.changeNameLabel.text = NSLocalizedString( @"CHANGE", nil );
   self.highNameLabel.text = NSLocalizedString( @"DASHBOARD_HIGH", nil );
   self.spreadNameLabel.text = NSLocalizedString( @"DASHBOARD_SPREAD", nil );
   self.lastNameLabel.text = NSLocalizedString( @"DASHBOARD_LAST", nil );
   self.lowNameLabel.text = NSLocalizedString( @"DASHBOARD_LOW", nil );
   self.askNameLabel.text = NSLocalizedString( @"DASHBOARD_ASK", nil );
   self.closeNameLabel.text = NSLocalizedString( @"DASHBOARD_CLOSE", nil );
   self.openNameLabel.text = NSLocalizedString( @"DASHBOARD_OPEN", nil );

   self.bidValueLabel.text = @"-";
   self.spreadValueLabel.text = @"-";
   self.askValueLabel.text = @"-";
   self.changeValueLabel.text = @"-";
   self.lastValueLabel.text = @"-";
   self.closeValueLabel.text = @"-";
   self.highValueLabel.text = @"-";
   self.lowValueLabel.text = @"-";
   self.openValueLabel.text = @"-";

   self.valueNameLabel.text = NSLocalizedString( @"VOLUME", nil );
   self.openInterNameLabel.text = NSLocalizedString( @"OPEN_INTEREST", nil );
   self.symbolTypeNameLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );
   self.tickSizeNameLabel.text = NSLocalizedString( @"SYMBOL_INFO_TICKS", nil );
   self.prevSettlPriceNameLabel.text = NSLocalizedString( @"PREV_SETTLEMENT_PRICE", nil );
   self.settlPriceNameLabel.text = NSLocalizedString( @"SETTLEMENT_PRICE", nil );

   self.createOrderLabel.text = NSLocalizedString( @"ORDER_ENTRY", nil );

   self.valueValueLabel.text = @"-";
   self.openInterValueLabel.text = @"-";
   self.symbolValueLabel.text = @"-";
   self.tickValueLabel.text = @"-";
   self.prevSettlPriceValueLabel.text = @"-";
   self.settlPriceValueLabel.text = @"-";
}

+(id)watchlistInfoViewWithSymbol:( id< PFSymbol > )symbol_
{
   PFWatchlistInfoView* watchlist_info_view_ = [ UIView viewAsFirstObjectFromNibNamed: @"PFWatchlistInfoView" ];
   watchlist_info_view_.currentSymbol = symbol_;

   return watchlist_info_view_;
}

#pragma mark - PFChartInfoView Protocol

-(void)updateDataByTimer
{
   [ self.bidValueLabel showBidForSymbol: self.currentSymbol ];
   [ self.askValueLabel showAskForSymbol: self.currentSymbol ];
   [ self.lastValueLabel showLastForSymbol: self.currentSymbol ];
   self.openInterValueLabel.text = self.currentSymbol.quote.openInterest > 0 ? [ NSString stringWithAmount: self.currentSymbol.quote.openInterest ] : @"-";
   self.symbolValueLabel.text = NSStringForAssetClass( self.currentSymbol.instrument.type );
   self.tickValueLabel.text = [ NSString stringWithAmount: self.currentSymbol.instrument.pointSize ];

   if ( self.currentSymbol.quote )
   {
      self.openValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.open symbol: self.currentSymbol ];
      self.highValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.high symbol: self.currentSymbol ];
      self.lowValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.low symbol: self.currentSymbol ];
      self.closeValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.previousClose symbol: self.currentSymbol ];
      self.spreadValueLabel.text = [ NSString stringWithDouble: self.currentSymbol.spread precision: 1 ];
      self.valueValueLabel.text = [ NSString stringWithVolume: self.currentSymbol.quote.volume ];
      self.prevSettlPriceValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.prevSettlementPrice symbol: self.currentSymbol ];
      self.settlPriceValueLabel.text = [ NSString stringWithPrice: self.currentSymbol.quote.settlementPrice symbol: self.currentSymbol ];
      [ self.changeValueLabel showLastForSymbol: self.currentSymbol ];
   }
   else
   {
      self.openValueLabel.text = nil;
      self.highValueLabel.text = nil;
      self.lowValueLabel.text = nil;
      self.closeValueLabel.text = nil;
      self.spreadValueLabel.text = nil;
   }
}

- (IBAction)OEButtonAction:(id)sender
{
   [ PFOrderEntryViewController showWithSymbol: self.currentSymbol ];
}

@end
