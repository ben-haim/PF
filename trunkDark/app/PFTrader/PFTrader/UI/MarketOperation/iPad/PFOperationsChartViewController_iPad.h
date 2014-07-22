//
//  PFOperationsChartViewController_iPad.h
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFChartViewController_iPad.h"

@protocol PFMarketOperation;

@interface PFOperationsChartViewController_iPad : PFChartViewController_iPad

-(id)initWithOperation:( id< PFMarketOperation > )operation_
           andInfoView:( UIView< PFChartInfoView >* )info_view_;

@end
