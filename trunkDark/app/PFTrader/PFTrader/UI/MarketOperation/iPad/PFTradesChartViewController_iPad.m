//
//  PFTradesChartViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTradesChartViewController_iPad.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTradesChartViewController_iPad ()

@property ( nonatomic, strong ) id< PFTrade > currentTrade;

@end

@implementation PFTradesChartViewController_iPad

@synthesize currentTrade;

-(id)initWithTrade:( id< PFTrade > )trade_
       andInfoView:( UIView< PFChartInfoView >* )info_view_
{
   self = [ super initWithSybol: trade_.symbol
                    andInfoView: info_view_ ];
   
   if ( self )
   {
      self.currentTrade = trade_;
   }
   
   return self;
}

@end
