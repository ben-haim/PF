//
//  PFTradesChartViewController_iPad.h
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFChartViewController_iPad.h"

@protocol PFTrade;

@interface PFTradesChartViewController_iPad : PFChartViewController_iPad

-(id)initWithTrade:( id< PFTrade > )trade_
       andInfoView:( UIView< PFChartInfoView >* )info_view_;

@end
